<template>
  <div class="wrapper">
    <!-- Sidebar  -->
    <nav id="sidebar" :class="{ active: isActive }">
      <div class="sidebar-header text-center">
        <b-avatar class="b-avatar" :src="photo" size="5rem"></b-avatar>
        <h3 class="mt-3">{{ userName }}</h3>
        <strong>DB</strong>
      </div>

      <ul class="list-unstyled components sidenav">
        <li class="">
          <router-link to="Dashboard"
            ><i class="material-icons"> home </i> หน้าแรก</router-link
          >
        </li>

        <li>
          <a
            href="#pageSubmenu"
            data-toggle="collapse"
            aria-expanded="false"
            class="dropdown-toggle"
          >
            <i class="material-icons"> bookmark </i>
            ข้อมูล
          </a>
          <ul class="collapse list-unstyled sidenav" id="pageSubmenu">
            <li>
              <router-link to="Farmers">ตารางเกษตรกร</router-link>
            </li>
            <li>
              <router-link to="Vegetable">ตารางผัก</router-link>
            </li>
            <li>
              <router-link to="Area">ตารางพื้นที่ปลูก</router-link>
            </li>
            <li>
              <router-link to="Fertilizer">ตารางปุ๋ย</router-link>
            </li>
            <li>
              <router-link to="Problems">ตารางปัญหา</router-link>
            </li>
          </ul>
        </li>

        <li>
          <router-link to="Order">
            <i class="material-icons"> account_box </i>
            ลูกค้า</router-link
          >
        </li>
        <li>
          <router-link to="V_order">
            <i class="material-icons"> add_business </i>
            ออเดอร์
          </router-link>
        </li>
        <li>
          <router-link to="/PGS" target="_blank">
            <i class="material-icons"> star </i>
            PGS
          </router-link>
        </li>
      </ul>

      <ul class="list-unstyled CTAs">
        <li>
          <a @click="logout" href="#" class="article"
            ><i class="fas fa-sign-out-alt"></i> ออกจากระบบ</a
          >
        </li>
      </ul>
    </nav>

    <!-- Page Content  -->
    <div id="content">
      <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container-fluid">
          <button
            type="button"
            id="sidebarCollapse"
            class="btn btn-info"
            style="width: 80px"
            @click="isActive = !isActive"
          >
            <i class="fas fa-align-left"></i>
          </button>
          <button
            class="btn btn-dark d-inline-block d-lg-none ml-auto"
            type="button"
            data-toggle="collapse"
            data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent"
            aria-expanded="false"
            aria-label="Toggle navigation"
          >
            <i class="fas fa-align-justify"></i>
          </button>

          <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="nav navbar-nav ml-auto sidenav">
              <li class="nav-item">
                <router-link class="nav-link" to="Dashboard"
                  >หน้าแรก</router-link
                >
              </li>

              <!-- <li class="nav-item active">
                <a class="nav-link" href="#"
                  ><i class="fas fa-user" style="font-size: 20px;"></i>
                  {{ userName }}</a
                >
              </li> -->
              <ul class="nav navbar-nav">
                <li class="dropdown active">
                  <a
                    href="#"
                    class="nav-link"
                    id="navbarDropdown"
                    data-toggle="dropdown"
                    aria-expanded="false"
                  >
                    {{ userName }} <i class="fas fa-address-card"></i>
                  </a>
                  <div class="dropdown-menu dropdown-menu-right">
                    <button
                      type="button"
                      class="dropdown-item"
                      v-b-modal.personalInformation
                    >
                      <i class="fas fa-address-book"></i> ข้อมูลส่วนตัว
                    </button>

                    <button
                      type="button"
                      class="dropdown-item"
                      v-b-modal.changePassword
                    >
                      <i class="fas fa-cog"></i> เปลี่ยนรหัสผ่าน
                    </button>

                    <div class="dropdown-divider"></div>
                    <a @click="logout" class="dropdown-item" href="#"
                      ><i class="fas fa-sign-out-alt"></i> ออกจากระบบ</a
                    >
                  </div>
                </li>
              </ul>
            </ul>
          </div>
        </div>
      </nav>
      <div>
        <Content />
      </div>
    </div>

    <!-- Modal  personalInformation-->
    <b-modal
      id="personalInformation"
      title="ข้อมูลส่วนตัว"
      ok-title="แก้ไขข้อมูล"
      cancel-title="ปิด"
      @ok="handleEdit"
    >
      <div class="p-3">
        <div class="d-flex align-items-center">
          <div class="image">
            <img :src="photo" class="rounded" width="155" />
          </div>
          <div class="ml-3 w-100">
            <h4 class="mb-0 mt-0">{{ userName }}</h4>
            <span>ผู้ดูแลระบบ</span>
          </div>
        </div>
      </div>
      <Edit :editData="editData" />
    </b-modal>

    <!-- Modal changePassword -->
    <b-modal
      id="changePassword"
      title="เปลี่ยนรหัสผ่าน"
      ok-title="ตกลง"
      cancel-title="ยกเลิก"
      @ok="handleOk"
      @show="resetData"
    >
      <form>
        <div class="form-group">
          <label for="password">รหัสผ่าน</label>
          <input
            type="password"
            class="form-control"
            name="password"
            id="password"
            v-model="password"
            v-validate="'required|min:6'"
            :class="{
              input: true,
              'is-invalid': errors.has('password'),
            }"
          />
          <span class="invalid-feedback">{{ errors.first("password") }}</span>
        </div>
        <div class="form-group">
          <label for="newPassword">รหัสผ่านใหม่</label>
          <input
            type="password"
            class="form-control"
            name="newPassword"
            v-model="newPassword"
            v-validate="'required|min:6'"
            :class="{
              input: true,
              'is-invalid': errors.has('newPassword'),
            }"
            ref="newPassword"
          />
          <span class="invalid-feedback">{{
            errors.first("newPassword")
          }}</span>
        </div>
        <div class="form-group">
          <label for="confirmPassword">ยืนยันรหัสผ่านใหม่</label>
          <input
            type="password"
            class="form-control"
            name="confirmPassword"
            v-model="confirmPassword"
            v-validate="'required|min:6|confirmed:newPassword'"
            :class="{
              input: true,
              'is-invalid': errors.has('confirmPassword'),
            }"
          />
          <span class="invalid-feedback">{{
            errors.first("confirmPassword")
          }}</span>
        </div>
      </form>
    </b-modal>
  </div>
</template>

<script>
import Content from "./Content.vue";
import axios from "axios";
import swal from "sweetalert";
import Edit from "./userConfig/Edit.vue";
import { Validator } from "vee-validate";
const dictionary = {
  th: {
    attributes: {
      password: "รหัสผ่าน",
      newPassword: "รหัสผ่านใหม่",
      confirmPassword: "ยืนยันรหัสผ่าน",
    },
  },
};
Validator.localize(dictionary);

export default {
  name: "Home",
  components: {
    Content,
    Edit,
  },
  data() {
    return {
      isActive: false,
      userName: "",
      photo: "",
      password: "",
      newPassword: "",
      confirmPassword: "",
    };
  },
  methods: {
    subIsActive(input) {
      const paths = Array.isArray(input) ? input : [input];
      return paths.some((path) => {
        return this.$route.path.indexOf(path) === 0; // current path starts with this path string
      });
    },

    Edit(button) {
      this.userName1 = localStorage.getItem("username");
      this.$root.$emit("bv::show::modal", this.userName1, button);
    },

    handleOk(bvModalEvt) {
      // Prevent modal from closing
      bvModalEvt.preventDefault();
      // Trigger submit handler
      this.changePassword();
    },

    handleEdit(bvModalEvt) {
      // Prevent modal from closing
      bvModalEvt.preventDefault();
      // Trigger submit handler
      this.Edit();
    },

    resetData() {
      (this.password = ""),
        (this.newPassword = ""),
        (this.confirmPassword = "");
    },

    async editData() {
      this.userName = await localStorage.getItem("name");
      this.photo = await localStorage.getItem("photo");
    },

    changePassword() {
      this.$validator.validateAll().then(async (result) => {
        if (result) {
          const accessToken = localStorage.getItem("accessToken");
          const username = localStorage.getItem("username");
          if (await accessToken) {
            try {
              swal({
                title: "คุณแน่ใจหรือไม่?",
                text: "คุณแน่ใจหรือไม่ที่จะเปลี่ยนรหัส?",
                icon: "warning",
                buttons: ["ยกเลิก", "ตกลง"],
                dangerMode: true,
              }).then(async (willDelete) => {
                if (willDelete) {
                  await axios
                    .put(
                      this.$apiUrl + "repass/" + username,
                      {
                        password: this.password,
                        newPassword: this.newPassword,
                        confirmPassword: this.confirmPassword,
                      },
                      {
                        headers: { Authorization: `bearer ${accessToken}` },
                      }
                    )
                    .then((res) => {
                      if (res.status == 200) {
                        swal(res.data, {
                          icon: "success",
                          buttons: "ตกลง",
                        });
                        this.$bvModal.hide("changePassword");
                        this.$toasts.success("เปลี่ยนรหัสเสร็จสิ้น");
                      }
                    })
                    .catch((res) => {
                      swal(res.data, {
                        icon: "error",
                        buttons: "ตกลง",
                      });
                    });
                } else {
                  swal("ยกเลิกแล้ว!", { buttons: "ตกลง" });
                }
              });
            } catch {
              this.$router.push("/");
              localStorage.removeItem("username");
            }
          } else {
            this.$router.push("/");
          }
          return;
        }
        swal("ผิดพลาด", "กรุณากรอกข้อมูลให้ถูกต้อง!", {
          icon: "error",
          button: "ตกลง",
        });
      });
    },

    // Exit login and return to login interface
    logout() {
      // TODO: Exit logic to be completed
      localStorage.removeItem("accessToken");
      localStorage.removeItem("username");
      localStorage.removeItem("fm_name");
      swal("สำเร็จ", "ออกจากระบบสำเร็จ", {
        icon: "success",
        button: "ตกลง",
      }).then(() => {
        this.$router.push({
          name: "Login",
        });
      });
    },
  },
  async mounted() {
    this.editData();
  },
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Sarabun:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800&display=swap");
.wrapper {
  font-family: "Sarabun", sans-serif;
  background: #fafafa;
  width: 100%;
}

p {
  font-family: "Sarabun", sans-serif;
  font-size: 1.1em;
  font-weight: 300;
  line-height: 1.7em;
  color: #999;
}

a,
a:hover,
a:focus {
  color: inherit;
  text-decoration: none;
  transition: all 0.3s;
}

.navbar {
  padding: 15px 10px;
  background: #fff;
  border: none;
  border-radius: 0;
  margin-bottom: 15px;
  box-shadow: 1px 1px 3px rgba(0, 0, 0, 0.1);
}

.navbar-btn {
  box-shadow: none;
  outline: none !important;
  border: none;
}

.line {
  width: 100%;
  height: 1px;
  border-bottom: 1px dashed #ddd;
  margin: 40px 0;
}

i,
span {
  display: inline-block;
}

/* ---------------------------------------------------
    SIDEBAR STYLE
----------------------------------------------------- */

.wrapper {
  display: flex;
  align-items: stretch;
}

#sidebar {
  min-width: 250px;
  max-width: 250px;

  background: linear-gradient(100deg, #7386d5, rgb(160, 205, 255));
  color: #fff;
  transition: all 1s;
}

#sidebar.active {
  min-width: 80px;
  max-width: 80px;
  text-align: center;
}
#sidebar.active .sidebar-header .b-avatar,
#sidebar.active .sidebar-header h3,
#sidebar.active .CTAs {
  display: none;
}

#sidebar.active .sidebar-header strong {
  display: block;
}

#sidebar ul li a {
  text-align: left;
}

#sidebar.active ul li a {
  padding: 20px 10px;
  text-align: center;
  font-size: 0.85em;
}

#sidebar.active ul li a i {
  margin-right: 0;
  display: block;
  font-size: 1.8em;
  margin-bottom: 5px;
}

#sidebar.active ul ul a {
  padding: 10px !important;
}

#sidebar.active .dropdown-toggle::after {
  top: auto;
  bottom: 10px;
  right: 50%;
  -webkit-transform: translateX(50%);
  -ms-transform: translateX(50%);
  transform: translateX(50%);
}

#sidebar .sidebar-header {
  padding: 20px;
  background: linear-gradient(50deg, #7386d5, rgb(160, 205, 255));
}

#sidebar .sidebar-header strong {
  display: none;
  font-size: 1.8em;
}

#sidebar ul.components {
  padding: 20px 0;
  border-bottom: 1px solid #47748b;
}

#sidebar ul li a {
  padding: 10px;
  font-size: 1.1em;
  display: block;
}

#sidebar ul li a:hover {
  color: #7386d5;
  background: #fff;
}

#sidebar ul li a i {
  margin-right: 10px;
}

#sidebar ul li a.router-link-active {
  color: #fff;
  background: linear-gradient(100deg, rgb(160, 205, 255), #8496dd);
}

#sidebar ul.ac li.active > a,
a[aria-expanded="true"] {
  color: rgb(143, 143, 143);
  background: #f8f9fa !important;
}

a[data-toggle="collapse"] {
  position: relative;
}

.dropdown-toggle::after {
  display: block;
  position: absolute;
  top: 50%;
  right: 20px;
  transform: translateY(-50%);
}

.sidenav ul ul a {
  font-size: 0.9em !important;
  padding-left: 30px !important;
  background: #6d7fcc;
}

.sidenav ul.CTAs {
  padding: 20px;
}

.sidenav ul.CTAs a {
  text-align: center;
  font-size: 0.9em !important;
  display: block;
  border-radius: 5px;
  margin-bottom: 5px;
}

/* ---------------------------------------------------
    CONTENT STYLE
----------------------------------------------------- */

#content {
  width: 100%;
  min-height: 100vh;
  transition: all 1s;
  background-color: #dddddd;
}

.caret.caret-up {
  border-top-width: 0;
  border-bottom: 4px solid #fff;
}

/* ---------------------------------------------------
    MEDIAQUERIES
----------------------------------------------------- */

@media (max-width: 768px) {
  #sidebar {
    min-width: 80px;
    max-width: 80px;
    text-align: center;
    margin-left: -80px !important;
  }
  .dropdown-toggle::after {
    top: auto;
    bottom: 10px;
    right: 50%;
    -webkit-transform: translateX(50%);
    -ms-transform: translateX(50%);
    transform: translateX(50%);
  }
  #sidebar.active {
    margin-left: 0 !important;
  }
  #sidebar .sidebar-header h3,
  #sidebar .CTAs {
    display: none;
  }
  #sidebar .sidebar-header strong {
    display: block;
  }
  #sidebar ul li a {
    padding: 20px 10px;
  }
  #sidebar ul li a span {
    font-size: 0.85em;
  }
  #sidebar ul li a i {
    margin-right: 0;
    display: block;
  }
  #sidebar ul ul a {
    padding: 10px !important;
  }
  #sidebar ul li a i {
    font-size: 1.3em;
  }
  #sidebar {
    margin-left: 0;
  }
  #sidebarCollapse span {
    display: none;
  }
}
</style>
