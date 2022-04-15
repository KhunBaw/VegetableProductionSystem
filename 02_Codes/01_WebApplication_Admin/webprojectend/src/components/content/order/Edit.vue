<template>
  <div id="Edit">
    <!-- edit modal Edit -->
    <b-modal
      :id="editModal.id"
      :title="editModal.title"
      ok-title="ตกลง"
      cancel-title="ยกเลิก"
      @ok="handleOk"
      @cancel="Order"
      size="lg"
    >
      <form class="needs-validation">
        <div class="form-group row">
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">ชื่อ:</span>
              <input
                type="text"
                aria-label="od_name"
                v-model="editModal.content.od_name"
                name="od_name"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('od_name'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("od_name")
              }}</span>
            </div>
          </div>
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">นามสกุล:</span>
              <input
                type="text"
                aria-label="od_lname"
                v-model="editModal.content.od_lname"
                name="od_lname"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('od_lname'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("od_lname")
              }}</span>
            </div>
          </div>
        </div>

        <div class="form-group row">
          <div class="col-6">
            <div class="input-group">
              <span class="input-group-text">บ้านเลขที่:</span>
              <input
                type="text"
                aria-label="od_address"
                v-model.number="editModal.content.od_address"
                name="od_address"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('od_address'),
                }"
                class="form-control"
              />
            </div>
            <span class="invalid-feedback">{{
                errors.first("od_address")
              }}</span>
          </div>

          <div class="col-6">
            <div class="input-group">
              <span class="input-group-text">ถนน:</span>
              <input
                type="text"
                aria-label="od_road"
                v-model.number="editModal.content.od_road"
                name="od_road"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('od_road'),
                }"
                class="form-control"
              />
            </div>
            <span class="invalid-feedback">{{
                errors.first("od_road")
              }}</span>
          </div>
        </div>

        <div class="form-group row">
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">ตำบล:</span>
              <input
                type="text"
                aria-label="od_locality"
                v-model.number="editModal.content.od_locality"
                name="od_locality"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('od_locality'),
                }"
                class="form-control"
              />
            </div>
            <span class="invalid-feedback">{{
                errors.first("od_locality")
              }}</span>
          </div>

          <div class="col">
            <div class="input-group">
              <span class="input-group-text">อำเภอ:</span>
              <input
                type="text"
                aria-label="od_district"
                v-model.number="editModal.content.od_district"
                name="od_district"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('od_district'),
                }"
                class="form-control"
              />
            </div>
            <span class="invalid-feedback">{{
                errors.first("od_district")
              }}</span>
          </div>
        </div>

        <div class="form-group row">
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">จังหวัด:</span>
              <input
                type="text"
                aria-label="od_province"
                v-model.number="editModal.content.od_province"
                name="od_province"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('od_province'),
                }"
                class="form-control"
              />
            </div>
            <span class="invalid-feedback">{{
                errors.first("od_province")
              }}</span>
          </div>
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">เบอร์โทรศัพท์:</span>
              <input
                type="tel"
                aria-label="od_phnum"
                v-model="editModal.content.od_phnum"
                name="od_phnum"
                v-validate="'required|digits:10'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('od_phnum'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("od_phnum")
              }}</span>
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
import moment from "moment";

export default {
  components: {},
  props: {
    editModal: Object,
    Order: Function,
  },

  data() {
    return {};
  },

  methods: {
    handleOk(bvModalEvt) {
      // Prevent modal from closing
      bvModalEvt.preventDefault();
      // Trigger submit handler
      this.SaveOrder();
    },

    filter(value) {
      if (value) {
        return moment(String(value)).format("DD/MM/YYYY");
      }
    },

    async SaveOrder() {
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
              await axios.put(
                this.$apiUrl + "order/" + this.editModal.content.od_id,
                this.editModal.content,
                {
                  headers: { Authorization: `bearer ${accessToken}` },
                }
              );
              swal("อัพเดทเสร็จสิ้น!", {
                icon: "success",
                buttons: "ตกลง",
              });
              this.Order;
            } else {
              swal("ยกเลิกแล้ว!",{buttons: "ตกลง",});
              this.Order;
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
