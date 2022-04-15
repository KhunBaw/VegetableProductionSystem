<template>
  <div id="Add">
    <!-- add modal Add -->
    <b-modal
      id="AddOrder"
      title="เพิ่มรายชื่อลูกค้า"
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
              <span class="input-group-text">ชื่อ:</span>
              <input
                type="text"
                aria-label="od_name"
                v-model="data.od_name"
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
                v-model="data.od_lname"
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
                v-model.number="data.od_address"
                name="od_address"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('od_address'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("od_address")
              }}</span>
            </div>
          </div>

          <div class="col-6">
            <div class="input-group">
              <span class="input-group-text">ถนน:</span>
              <input
                type="text"
                aria-label="od_road"
                v-model.number="data.od_road"
                name="od_road"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('od_road'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("od_road")
              }}</span>
            </div>
          </div>
        </div>

        <div class="form-group row">
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">ตำบล:</span>
              <b-form-input
                list="od_locality"
                type="text"
                aria-label="od_locality"
                name="od_locality"
                v-validate="'required'"
                v-model="data.od_locality"
                :class="{
                  input: true,
                  'is-invalid': errors.has('od_locality'),
                }"
                class="form-control"
              ></b-form-input>

              <datalist id="od_locality">
                <option v-for="(subDistricts, i) in subDistricts" :key="i">{{ subDistricts.SUB_DISTRICT_NAME }}</option>
              </datalist>

            </div>
          </div>

          <div class="col">
            <div class="input-group">
              <span class="input-group-text">อำเภอ:</span>
              <b-form-input
                list="od_district"
                type="text"
                aria-label="od_district"
                name="od_district"
                v-validate="'required'"
                v-model="data.od_district"
                :class="{
                  input: true,
                  'is-invalid': errors.has('od_district'),
                }"
                class="form-control"
              ></b-form-input>

              <datalist id="od_district">
                <option v-for="(districts, i) in districts" :key="i">{{ districts.DISTRICT_NAME }}</option>
              </datalist>
            </div>
          </div>
        </div>

        <div class="form-group row">
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">จังหวัด:</span>
              <b-form-input
                list="od_province"
                type="text"
                aria-label="od_province"
                name="od_province"
                v-validate="'required'"
                v-model="data.od_province"
                :class="{
                  input: true,
                  'is-invalid': errors.has('od_province'),
                }"
                class="form-control"
              ></b-form-input>

              <datalist id="od_province">
                <option v-for="(provinces, i) in provinces" :key="i">{{ provinces.PROVINCE_NAME }}</option>
              </datalist>

            </div>
          </div>
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">เบอร์โทรศัพท์:</span>
              <input
                type="tel"
                aria-label="od_phnum"
                v-model="data.od_phnum"
                name="od_phnum"
                v-validate="'required|digits:10'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('od_phnum'),
                }"
                class="form-control"
                minlength="10"
                maxlength="12"
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
import provinces from "../../../assets/provinces.json";
import districts from "../../../assets/districts.json";
import subDistricts from "../../../assets/subDistricts.json";

export default {
  components: {},
  props: {
    Order: Function,
  },
  data() {
    return {
      data: {},
      provinces: provinces,
      districts: districts,
      subDistricts: subDistricts
    };
  },

  async mounted() {},
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

    resetData() {
      this.data = {
        od_name: "",
        od_lname: "",
        od_address: "",
        od_road: "",
        od_locality: "",
        od_district: "",
        od_province: "",
        od_phnum: "",
      };
    },

    async SaveOrder() {
      this.$validator.validateAll().then(async (result) => {
        if (result) {
          const accessToken = localStorage.getItem("accessToken");
          if (await accessToken) {
            try {
              this.$bvModal.hide("AddOrder");
              await axios.post(this.$apiUrl + "addorder", this.data, {
                headers: { Authorization: `bearer ${accessToken}` },
              });
              this.Order();
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
