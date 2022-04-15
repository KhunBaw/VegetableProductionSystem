<template>
  <div id="Edit">
    <!-- edit modal Edit -->
    <b-modal
      :id="userName1"
      :title="'แก้ไขข้อมูลส่วนตัว'"
      ok-title="ตกลง"
      cancel-title="ยกเลิก"
      @ok="handleOk"
      size="lg"
    >
      <form class="needs-validation">
        <div class="form-group row">
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">ชื่อ:</span>
              <input
                type="text"
                aria-label="fm_name"
                v-model="items.fm_name"
                name="fm_name"
                v-validate="'required'"
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
              <span class="input-group-text">นามสกุล:</span>
              <input
                type="text"
                aria-label="fm_lname"
                v-model="items.fm_lname"
                name="fm_lname"
                v-validate="'required'"
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
              <span class="input-group-text">ตำแหน่ง/หน้าที่:</span>
              <input
                type="text"
                v-model.number="items.position"
                name="position"
                id="position"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('position'),
                }"
                class="form-control"
              />
            </div>
            <span class="invalid-feedback">{{ errors.first("position") }}</span>
          </div>

          <div class="col">
            <div class="input-group">
              <span class="input-group-text">เบอร์โทรศัพท์:</span>
              <input
                type="tel"
                v-model="items.fm_phnum"
                name="fm_phnum"
                v-validate="'required'"
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
        </div>

        <div class="row">
          <div class="col mb-3">
            <div class="input-group">
              <span class="input-group-text">ที่อยู่:</span>
              <textarea
                type="text"
                aria-label="fm_address"
                v-model.number="items.fm_address"
                name="fm_address"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('fm_address'),
                }"
                class="form-control"
              ></textarea>
            </div>
            <span class="invalid-feedback">{{
              errors.first("fm_address")
            }}</span>
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
                  items.photo == "" ? "เลือกไฟล์" : items.photo
                }}</label>
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col">
            <div id="preview" class="text-center">
              <img
                v-if="url === null ? items.photo : url"
                :src="url === null ? items.photo : url"
                style="max-width: 25%; height: auto"
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
const dictionary = {
  th: {
    attributes: {
      fm_name: "ชื่อ",
      fm_lname: "นามสกุล",
      fm_address: "ที่อยู่",
      fm_phnum: "เบอร์โทรศัพท์",
      position: "ตำแหน่ง/หน้าที่",
    },
  },
};
Validator.localize(dictionary);

export default {
  components: {},
  props: {
    editData: Function,
  },

  data() {
    return {
      file: "",
      url: null,
      userName1: "",
      items: {},
    };
  },

  async mounted() {
    this.userName1 = localStorage.getItem("username");
    const accessToken = localStorage.getItem("accessToken");
    const response = await axios
      .get(this.$apiUrl + "farmers/" + this.userName1, {
        headers: { Authorization: `bearer ${accessToken}` },
      })
      .catch((res) => {
        swal(res.data, {
          icon: "error",
          buttons: "ตกลง",
        });
      });

    this.items = response.data;
  },

  methods: {
    handleOk(bvModalEvt) {
      // Prevent modal from closing
      bvModalEvt.preventDefault();
      // Trigger submit handler;
      this.SaveFarmers();
    },

    handleFileUpload() {
      this.file = this.$refs.file.files[0];
      this.url = URL.createObjectURL(this.file);
    },

    async SaveFarmers() {
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
                  this.$bvModal.hide(this.userName1);
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
                    this.Save(this.items.photo);
                  }
                  this.Farmers();
                } else {
                  swal("ยกเลิกแล้ว!", { button: "ตกลง" });
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
      this.items.photo = data;
      const accessToken = localStorage.getItem("accessToken");
      if (await accessToken) {
        await axios
          .put(this.$apiUrl + "farmers/" + this.userName1, this.items, {
            headers: { Authorization: `bearer ${accessToken}` },
          })
          .then((data) => {
            localStorage.setItem(
              "name",
              data.data.fm_name + " " + data.data.fm_lname
            );
            localStorage.setItem("photo", data.data.photo);
            this.editData();
            swal("อัพเดทเสร็จสิ้น!", {
              icon: "success",
              button: "ตกลง",
            });
          })
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
