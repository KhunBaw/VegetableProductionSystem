<template>
  <div id="Edit">
    <!-- edit modal Edit -->
    <b-modal
      :id="editModal.id"
      :title="editModal.title"
      ok-title="ตกลง"
      cancel-title="ยกเลิก"
      @ok="handleOk"
      @cancel="Vegetable"
      size="lg"
    >
      <form class="needs-validation form-group">
        <div class="row">
          <div class="col mb-3">
            <div class="input-group">
              <span class="input-group-text">ชื่อผัก:</span>
              <input
                type="text"
                aria-label="v_name"
                name="v_name"
                v-validate="'required'"
                v-model="editModal.content.v_name"
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
                v-model.number="editModal.content.v_wide"
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
                v-model.number="editModal.content.v_long"
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
          <div class="col-6 mb-3">
            <div class="input-group">
              <span class="input-group-text">น้ำหนัก/ต้น:</span>
              <input
                type="number"
                aria-label="v_nfv"
                name="v_nfv"
                v-model.number="editModal.content.v_nfv"
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
          <div class="col-6 mb-3">
            <div class="input-group">
              <span class="input-group-text">จำนวนวันที่เพาะ:</span>
              <input
                type="number"
                aria-label="v_d1"
                name="v_d1"
                v-model.number="editModal.content.v_d1"
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
          <div class="col-6 mb-3">
            <div class="input-group">
              <span class="input-group-text">จำนวนวันที่ปลูก:</span>
              <input
                type="number"
                aria-label="v_d2"
                name="v_d2"
                v-model.number="editModal.content.v_d2"
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

          <div class="col-6 mb-3">
            <div class="input-group">
              <span class="input-group-text">จำนวนวันที่เก็บ:</span>
              <input
                type="number"
                aria-label="v_d3"
                name="v_d3"
                v-model.number="editModal.content.v_d3"
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
                  editModal.content.v_photo == ""
                    ? "เลือกไฟล์"
                    : editModal.content.v_photo
                }}</label>
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col">
            <div id="preview" class="text-center">
              <img
                v-if="url === null ? editModal.content.v_photo : url"
                :src="url === null ? editModal.content.v_photo : url"
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
    editModal: Object,
    Vegetable: Function,
  },

  data() {
    return {
      file: "",
      url: null,
    };
  },

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

    async SaveVegetable() {
      this.$validator.validateAll().then(async (result) => {
        if (result) {
          const accessToken = localStorage.getItem("accessToken");
          if (await accessToken) {
            try {
              swal({
                title: "คุณแน่ใจหรือไม่?",
                text: "คุณแน่ใจหรือไม่ที่จะอัพเดท?",
                icon: "warning",
                buttons: ["ยกเลิก", "ตกลง"],
                dangerMode: true,
              }).then(async (willDelete) => {
                if (willDelete) {
                  this.$bvModal.hide(this.editModal.id);
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
                    this.Save(this.editModal.content.v_photo);
                  }

                  this.Vegetable();
                } else {
                  swal("ยกเลิกแล้ว!", {
                    icon: "success",
                    button: "ตกลง",
                  });
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

    async Save(data) {
      this.editModal.content.v_photo = data;
      const accessToken = localStorage.getItem("accessToken");
      if (await accessToken) {
        await axios
          .put(
            this.$apiUrl + "vegetable/" + this.editModal.content.v_id,
            this.editModal.content,
            {
              headers: { Authorization: `bearer ${accessToken}` },
            }
          )
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

<style></style>
