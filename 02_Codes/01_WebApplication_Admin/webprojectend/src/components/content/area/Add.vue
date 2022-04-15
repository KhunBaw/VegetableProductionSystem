<template>
  <div id="Add">
    <!-- add modal Add -->
    <b-modal
      id="AddArea"
      title="เพิ่มข้อมูลพื้นที่ปลูก"
      ok-title="ตกลง"
      cancel-title="ยกเลิก"
      @ok="handleOk"
      @show="resetData"
      size="lg"
    >
      <form class="needs-validation form-group">
        <div class="row">
          <div class="col mb-3">
            <div class="input-group">
              <span class="input-group-text">ชื่อแปลงผัก:</span>
              <input
                type="text"
                aria-label="Area type"
                v-model="data.area_name"
                name="area_name"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('area_name'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("area_name")
              }}</span>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="col-6 mb-3">
            <div class="input-group">
              <span class="input-group-text">ความยาว:</span>
              <input
                type="number"
                aria-label="Area type"
                v-model.number="data.area_long"
                name="area_long"
                v-validate="'required|min:1'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('area_long'),
                }"
                class="form-control"
              />
              <span class="input-group-text">ซม.</span>
            </div>
            <span class="invalid-feedback">{{
              errors.first("area_long")
            }}</span>
          </div>

          <div class="col-6 mb-3">
            <div class="input-group">
              <span class="input-group-text">ความกว้าง:</span>
              <input
                type="number"
                aria-label="Area type"
                v-model.number="data.area_wide"
                name="area_wide"
                v-validate="'required|min:1'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('area_wide'),
                }"
                class="form-control"
              />
              <span class="input-group-text">ซม.</span>
              <span class="invalid-feedback">{{
                errors.first("area_wide")
              }}</span>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="col mb-3">
            <div class="input-group">
              <span class="input-group-text">พักพื้นที่:</span>
              <input
                type="number"
                aria-label="area_rest_period"
                v-model.number="data.area_rest_period"
                name="area_rest_period"
                v-validate="'required|min:1'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('area_rest_period'),
                }"
                class="form-control"
              />
              <span class="input-group-text">วัน</span>
            </div>
            <span class="invalid-feedback">{{
              errors.first("area_rest_period")
            }}</span>
          </div>
        </div>

        <div class="row">
          <div class="col mb-3">
            <div class="input-group">
              <div class="input-group-prepend">
                <span class="input-group-text">รายละเอียด</span>
              </div>
              <textarea
                class="form-control"
                aria-label="With textarea"
                v-model="data.area_detail"
              ></textarea>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="col">
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

export default {
  components: {},
  props: {
    Area: Function,
  },
  data() {
    return {
      file: "",
      url: null,
      data: {},
    };
  },

  async mounted() {},
  methods: {
    handleOk(bvModalEvt) {
      // Prevent modal from closing
      bvModalEvt.preventDefault();
      // Trigger submit handler
      this.SaveArea();
    },

    resetData() {
      (this.file = ""),
        (this.url = null),
        (this.data = {
          area_name: "",
          area_long: 1,
          area_wide: 1,
          area_photo: "",
          area_detail: "",
          area_rest_period: 1,
        });
    },

    handleFileUpload() {
      this.file = this.$refs.file.files[0];
      this.url = URL.createObjectURL(this.file);
    },

    async SaveArea() {
      this.$validator.validateAll().then(async (result) => {
        if (result) {
          const accessToken = localStorage.getItem("accessToken");
          if (await accessToken) {
            try {
              this.$bvModal.hide("AddArea");

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
                this.Save(photo_url.data);
              } else {
                this.Save(
                  "https://firebasestorage.googleapis.com/v0/b/project-end-e92b5.appspot.com/o/no-image.png?alt=media&token=dcc723f4-2f63-4b64-8b23-d22cd6f9b45c"
                );
              }

              this.Area();
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

    async Save(data) {
      this.data.area_photo = data;
      const accessToken = localStorage.getItem("accessToken");
      if (await accessToken) {
        await axios
          .post(this.$apiUrl + "addarea", this.data, {
            headers: { Authorization: `bearer ${accessToken}` },
          })
          .then(() =>
            swal("อัพเดทเสร็จสิ้น!", {
              icon: "success",
              button: "ตกลง",
            })
          )
          .catch(() =>
            swal("ผิดพลาด", {
              icon: "error",
              button: "ตกลง",
            })
          );
      }
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
