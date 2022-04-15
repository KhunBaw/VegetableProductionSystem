<template>
  <div id="Add">
    <!-- add modal Add -->
    <b-modal
      id="AddFarmers"
      title="เพิ่มข้อมูลเกษตรกร"
      ok-title="ตกลง"
      cancel-title="ยกเลิก"
      @ok="handleOk"
      @show="resetData"
      size="lg"
    >
      <form class="needs-validation">
        <div class="form-group row">
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">ชื่อผู้ใช้</span>
              <input
                type="text"
                name="username"
                aria-label="username"
                v-model="data.username"
                v-validate="'required|alpha_num|min:4|unique'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('username'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("username")
              }}</span>
            </div>
          </div>
        </div>

        <div class="form-group row">
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">ชื่อ</span>
              <input
                type="text"
                name="fm_name"
                aria-label="fm_name"
                v-model="data.fm_name"
                :class="{
                  input: true,
                  'is-invalid': errors.has('fm_name'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("fm_name")
              }}</span>
            </div>
          </div>
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">นามสกุล</span>
              <input
                type="text"
                name="fm_lname"
                aria-label="fm_lname"
                v-model="data.fm_lname"
                :class="{
                  input: true,
                  'is-invalid': errors.has('fm_lname'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("fm_lname")
              }}</span>
            </div>
          </div>
        </div>

        <div class="form-group row">
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">ที่อยู่</span>
              <textarea
                type="text"
                name="fm_address"
                aria-label="fm_address"
                v-model="data.fm_address"
                :class="{
                  input: true,
                  'is-invalid': errors.has('fm_address'),
                }"
                class="form-control"
              ></textarea>
              <span class="invalid-feedback">{{
                errors.first("fm_address")
              }}</span>
            </div>
          </div>
        </div>

        <div class="form-group row">
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">เบอร์โทรศัพท์</span>
              <input
                type="text"
                name="fm_phnum"
                aria-label="fm_phnum"
                v-model="data.fm_phnum"
                v-validate="'digits:10'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('fm_phnum'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("fm_phnum")
              }}</span>
            </div>
          </div>
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">ตำแหน่ง</span>
              <input
                type="text"
                name="position"
                aria-label="position"
                v-model="data.position"
                :class="{
                  input: true,
                  'is-invalid': errors.has('position'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("position")
              }}</span>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col mb-3">
            <div class="input-group mb-3">
              <div class="input-group-prepend">
                <span class="input-group-text" id="inputGroupFileAddon01"
                  >อัพโหลดภาพ</span
                >
              </div>
              <div class="custom-file">
                <input
                  type="file"
                  class="custom-file-input"
                  id="inputGroupFile01"
                  aria-describedby="inputGroupFileAddon01"
                  ref="file"
                  v-on:change="handleFileUpload()"
                />
                <label class="custom-file-label" for="inputGroupFile01">{{
                  file == "" ? "เลือกไฟล์" : file.name
                }}</label>
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col">
            <div id="preview" class="text-center">
              <img
                v-if="url"
                :src="url"
                style="max-width: 50%; height: auto;"
              />
            </div>
          </div>
        </div>
      </form>
    </b-modal>
  </div>
</template>

<script>
import axios from "axios";
import swal from "sweetalert";
import { Validator } from "vee-validate";

export default {
  components: {},
  props: {
    Farmers: Function,
  },
  data() {
    return {
      file: "",
      url: null,
      data: {},
    };
  },

  async mounted() {
    Validator.extend("unique", {
      validate: this.isUsernameUnique,
      getMessage: "มี ชื่อผู้ใช้ นี้อยู่แล้ว",
    });
  },
  methods: {
    handleOk(bvModalEvt) {
      // Prevent modal from closing
      bvModalEvt.preventDefault();
      // Trigger submit handler
      this.SaveFarmers();
    },

    handleFileUpload() {
      this.file = this.$refs.file.files[0];
      this.url = URL.createObjectURL(this.file);
    },

    resetData() {
      this.data = {
        username: "",
        fm_name: "",
        fm_lname: "",
        fm_address: "",
        fm_phnum: "",
        position: "",
        photo: ""
      };
    },

    async isUsernameUnique() {
      try {
        const accessToken = localStorage.getItem("accessToken");
        const response = await axios.get(
          this.$apiUrl + "farmers/" + this.data.username,
          {
            headers: { Authorization: `bearer ${accessToken}` },
          }
        );
        if (response.status === 204) {
          return false;
        }
      } catch (err) {
        if (err.response.status === 403) {
          return true;
        }
      }
    },

    async SaveFarmers() {
      this.$validator.validateAll().then(async (result) => {
        if (result) {
          const accessToken = localStorage.getItem("accessToken");
          if (await accessToken) {
            try {

              this.$bvModal.hide("AddFarmers");

              let formData = new FormData();
              formData.append("file", this.file);

              if (this.url != null) {
                let photo_url = await axios
                  .post(this.$apiUrl + "upload", formData, {
                    headers: {
                      Authorization: `bearer ${accessToken}`,
                      "Content-Type": "multipart/form-data",
                    },
                  })
                  .catch(() =>
                    swal("ผิดพลาด", "อัพรูปไม่สำเร็จ", {
                      icon: "error",
                      button: "ตกลง",
                    })
                  );
                this.data.photo = photo_url.data;
              }

              await axios.post(this.$apiUrl + "user/register", this.data, {
                headers: { Authorization: `bearer ${accessToken}` },
              });
              this.Farmers();
              swal("เพิ่มข้อมูลเสร็จสิ้นแล้ว!", {
                icon: "success",
                button: "ตกลง",
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
  },
};
</script>

<style>
.table th,
.table td {
  vertical-align: middle;
}
</style>
