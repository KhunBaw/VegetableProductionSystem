<template>
  <div id="Edit">
    <!-- edit modal Edit -->
    <b-modal
      :id="editModal.id"
      :title="editModal.title"
      ok-title="ตกลง"
      cancel-title="ยกเลิก"
      @ok="handleOk"
      @cancel="Farmers"
      size="lg"
    >
      <form class="needs-validation">
        <div class="form-group row">
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">ชื่อ</span>
              <input
                type="text"
                name="fm_name"
                aria-label="fm_name"
                v-model="editModal.content.fm_name"
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
                v-model="editModal.content.fm_lname"
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
                v-model="editModal.content.fm_address"
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
                v-model="editModal.content.fm_phnum"
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
                v-model="editModal.content.position"
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
                  file.name == null ? editModal.content.photo : file.name
                }}</label>
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col">
            <div id="preview" class="text-center">
              <img
                v-if="url === null ? editModal.content.photo : url"
                :src="url === null ? editModal.content.photo : url"
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
    Farmers: Function,
  },

  data() {
    return {
      file: "",
      url: null,
    };
  },

  async mounted() {

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
                this.editModal.content.photo = photo_url.data;
              }

              await axios.put(
                this.$apiUrl +
                  "farmers/" +
                  this.editModal.content.username,
                this.editModal.content,
                {
                  headers: { Authorization: `bearer ${accessToken}` },
                }
              );
              swal("อัพเดทเสร็จสิ้น!", {
                icon: "success",
                button: "ตกลง",
              });
              this.Farmers();
            } else {
              swal("ยกเลิกแล้ว!",{button: "ตกลง",});
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
  },
};
</script>

<style></style>
