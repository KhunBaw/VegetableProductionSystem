<template>
  <div>
    <Loading :isloaded="Loading.isloaded" />
    <div class="wrapper">
      <div class="container">
        <div class="row justify-content-md-center">
          <div
            class="col form-group"
            style="min-width: 300px; max-width: 500px;">
            <div class="card card-signin my-5">
              <div class="card-body">
                <form v-on:submit.prevent="">
                  <h3 class="card-title text-center">เข้าสู่ระบบ</h3>
                  <div class="input-group mb-3 mt-3">
                    <div class="input-group-prepend">
                      <span class="input-group-text" id="basic-addon1"
                        >ชื่อผู้ใช้:</span
                      >
                    </div>
                    <input
                      class="form-control"
                      type="username"
                      v-model="data.username"
                      v-validate="'required|alpha_num|min:4'"
                      :class="{
                        input: true,
                        'is-invalid': errors.has('username'),
                      }"
                      name="username"
                      id="username"
                    />
                    <span class="invalid-feedback">{{
                      errors.first("username")
                    }}</span>
                  </div>
                  <div class="input-group mb-3">
                    <div class="input-group-prepend">
                      <span class="input-group-text" id="basic-addon1"
                        >รหัสผ่าน:</span
                      >
                    </div>
                    <input
                      class="form-control"
                      type="password"
                      v-model.trim="data.password"
                      v-validate="'required|min:6'"
                      :class="{
                        input: true,
                        'is-invalid': errors.has('password'),
                      }"
                      name="password"
                      id="password"
                    />
                    <span class="invalid-feedback">{{
                      errors.first("password")
                    }}</span>
                  </div>
                  <div class="d-flex justify-content-center">
                    <button class="btn btn-primary" v-on:click="Login()">
                      เข้าสู่ระบบ
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import swal from "sweetalert";
import Loading from "./Loading.vue";
import { Validator } from "vee-validate";
const dictionary = {
  th: {
    attributes: {
      username: "ชื่อผู้ใช้",
      password: "รหัสผ่าน",
    },
  },
};

Validator.localize(dictionary);

export default {
  name: "Login",
  metaInfo: {
    titleTemplate: "Login",
  },
  components: { Loading },
  data() {
    return {
      data: {
        username: "",
        password: "",
      },
      Loading: {
        isloaded: false,
      },
    };
  },
  methods: {
    async Login() {
      this.Loading.isloaded = false;
      this.$validator.validateAll().then(async (result) => {
        if (result) {
          await axios
            .post(this.$apiUrl + "signin", this.data)
            .then((result2) => {
              if (result2) {
                if (result2.data.user.role == "admin") {
                  this.Loading.isloaded = true;
                  localStorage.setItem("accessToken", result2.data.accessToken);
                  localStorage.setItem("username", result2.data.user.username);
                  localStorage.setItem(
                    "name",
                    result2.data.user.fm_name + " " + result2.data.user.fm_lname
                  );
                  localStorage.setItem("photo", result2.data.user.photo);
                  swal("สำเร็จ", result2.data.message, {
                    icon: "success",
                    button: "ตกลง",
                  });
                  this.$router.push("/Home");
                } else {
                  this.Loading.isloaded = true;
                  swal(
                    "สวัสดี " +
                      result2.data.user.fm_name +
                      " " +
                      result2.data.user.fm_lname +
                      " คุณไม่มีสิทธิ์เข้าถึง",
                    {
                      icon: "error",
                      button: "ตกลง",
                    }
                  );
                }
              } else {
                this.Loading.isloaded = true;
              }
            })
            .catch((error) => {
              if (error.response && error.response.status >= 400 && error.response.status < 500) {
                this.Loading.isloaded = true;
                return swal(
                  "ผิดพลาด : " + error.response.status,
                  error.response.data,
                  "ผิดพลาด",
                  {
                    icon: "error",
                    button: "ตกลง",
                  }
                );
              } else if (error.response) {
                this.Loading.isloaded = true;
                return swal("ผิดพลาด", "ไม่สามารถระบุปัญหาได้!", {
                  icon: "error",
                  button: "ตกลง",
                });
              }
              this.Loading.isloaded = true;
                return swal("ผิดพลาด", "ไม่สามารถเชื่อมต่อเซิฟเวอร์ได้!", {
                  icon: "error",
                  button: "ตกลง",
                });
            });
          return;
        }
        this.Loading.isloaded = true;
        swal("ผิดพลาด", "กรุณากรอกข้อมูลให้ถูกต้อง!", {
          icon: "error",
          button: "ตกลง",
        });
      });
    },
  },

  async mounted() {
    const user = localStorage.getItem("username");
    const accessToken = localStorage.getItem("accessToken");

    if (accessToken) {
      try {
        await axios
          .get(this.$apiUrl + "farmers/" + user, {
            headers: { Authorization: `bearer ${accessToken}` },
          })
          .then((response) => {
            if (response.status == 200) this.$router.push("/Home");
          })
          .catch((error) => {
            if (error.response && error.response.status === 401) {
              console.log(error.response);
            }
          });
        this.Loading.isloaded = true;
      } catch {
        localStorage.removeItem("username");
        this.Loading.isloaded = true;
      }
    } else {
      this.Loading.isloaded = true;
    }
  },
};
</script>

<style scoped>
.wrapper {
  width: 100vw;
  height: 100vh;
  background: linear-gradient(
    45deg,
    #f17c58,
    #e94584,
    #24aadb,
    #27dbb1,
    #ffdc18,
    #ff3706
  );
  background-size: 600% 100%;
  animation: gradient 16s linear infinite;
  animation-direction: alternate;
}

@keyframes gradient {
  0% {
    background-position: 0%;
  }

  100% {
    background-position: 100%;
  }
}

.card-signin {
  border: 0;
  border-radius: 1rem;
  box-shadow: 0 0.5rem 1rem 0 rgba(0, 0, 0, 0.1);
}

.card-signin .card-title {
  margin-bottom: 2rem;
  font-weight: 300;
  font-size: 1.5rem;
}

.card-signin .card-body {
  padding: 2rem;
}
</style>
