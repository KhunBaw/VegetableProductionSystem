<template>
  <div id="Add">
    <!-- add modal Add -->
    <b-modal
      id="AddVegetable"
      title="เพิ่มข้อมูลผัก"
      @ok="handleOk"
      @show="resetData"
      ok-title="ตกลง"
      cancel-title="ยกเลิก"
      size="lg"
    >
      <form class="form-group needs-validation">
        <div class="row">
          <div class="col mb-3" style="min-width: 300px;">
            <div class="input-group">
              <span class="input-group-text">ชื่อผัก:</span>
              <input
                type="text"
                aria-label="v_name"
                name="v_name"
                v-validate="'required'"
                v-model="data.v_name"
                :class="{
                  input: true,
                  'is-invalid': errors.has('v_name'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{ errors.first("v_name") }}</span>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="col-6 mb-3">
            <div class="input-group">
              <span class="input-group-text">ระยะปลูก(กว้าง):</span>
              <input
                type="number"
                aria-label="v_wide"
                name="v_wide"
                v-model.number="data.v_wide"
                v-validate="'required|min_value:1|integer'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('v_wide'),
                }"
                min="1"
                class="form-control"
              />
              <span class="input-group-text">ซม.</span>
              <span class="invalid-feedback">{{ errors.first("v_wide") }}</span>
            </div>
          </div>

          <div class="col-6 mb-3">
            <div class="input-group">
              <span class="input-group-text">ระยะปลูก(ยาว):</span>
              <input
                type="number"
                aria-label="v_long"
                name="v_long"
                v-model.number="data.v_long"
                v-validate="'required|min_value:1|integer'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('v_long'),
                }"
                min="1"
                class="form-control"
              />
              <span class="input-group-text">ซม.</span>
              <span class="invalid-feedback">{{ errors.first("v_long") }}</span>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="col mb-3">
            <div class="input-group">
              <span class="input-group-text">น้ำหนัก/ต้น:</span>
              <input
                type="number"
                aria-label="v_nfv"
                name="v_nfv"
                v-model.number="data.v_nfv"
                v-validate="'required|min_value:1|integer'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('v_nfv'),
                }"
                min="1"
                class="form-control"
              />
              <span class="input-group-text">กรัม</span>
              <span class="invalid-feedback">{{ errors.first("v_nfv") }}</span>
            </div>
          </div>

          <div class="col mb-3" style="min-width: 300px;">
            <div class="input-group">
              <span class="input-group-text">จำนวนวันที่เพาะ:</span>
              <input
                type="number"
                aria-label="v_d1"
                name="v_d1"
                v-model.number="data.v_d1"
                v-validate="'required|min_value:1|integer'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('v_d1'),
                }"
                min="1"
                class="form-control"
              />
              <span class="input-group-text">วัน</span>
              <span class="invalid-feedback">{{ errors.first("v_d1") }}</span>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="col mb-3" style="min-width: 300px;">
            <div class="input-group">
              <span class="input-group-text">จำนวนวันที่ปลูก:</span>
              <input
                type="number"
                aria-label="v_d2"
                name="v_d2"
                v-model.number="data.v_d2"
                v-validate="'required|min_value:1|integer'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('v_d2'),
                }"
                min="1"
                class="form-control"
              />
              <span class="input-group-text">วัน</span>
              <span class="invalid-feedback">{{ errors.first("v_d2") }}</span>
            </div>
          </div>

          <div class="col mb-3" style="min-width: 300px;">
            <div class="input-group">
              <span class="input-group-text">จำนวนวันที่เก็บ:</span>
              <input
                type="number"
                aria-label="v_d3"
                name="v_d3"
                v-model.number="data.v_d3"
                v-validate="'required|min_value:1|integer'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('v_d3'),
                }"
                min="1"
                class="form-control"
              />
              <span class="input-group-text">วัน</span>
              <span class="invalid-feedback">{{ errors.first("v_d3") }}</span>
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

export default {
  components: {},
  props: {
    Vegetable: Function,
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
      this.SaveVegetable();
    },

    handleFileUpload() {
      this.file = this.$refs.file.files[0];
      this.url = URL.createObjectURL(this.file);
    },

    resetData() {
      (this.file = ""),
        (this.url = null),
        (this.data = {
          v_name: "",
          v_wide: 1,
          v_long: 1,
          v_nfv: 1,
          v_d1: 1,
          v_d2: 1,
          v_d3: 1,
          v_photo: "",
        });
    },

    async SaveVegetable() {
      this.$validator.validateAll().then(async (result) => {
        if (result) {
          const accessToken = localStorage.getItem("accessToken");
          if (await accessToken) {
            try {
              
              this.$bvModal.hide("AddVegetable");

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
                this.Save("https://firebasestorage.googleapis.com/v0/b/project-end-e92b5.appspot.com/o/no-image.png?alt=media&token=dcc723f4-2f63-4b64-8b23-d22cd6f9b45c");
              }

              this.Vegetable();
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
      this.data.v_photo = data;
      const accessToken = localStorage.getItem("accessToken");
      if (await accessToken) {
        await axios
          .post(this.$apiUrl + "addvegetable", this.data, {
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
