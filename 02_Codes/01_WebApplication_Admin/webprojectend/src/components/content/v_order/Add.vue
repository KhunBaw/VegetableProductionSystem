<template>
  <div id="Addv">
    <!-- add modal Add -->
    <b-modal
      id="AddVegetable_order"
      title="เพิ่มข้อมูลออเดอร์"
      ok-title="ตกลง"
      cancel-title="ยกเลิก"
      @ok="handleOk"
      @show="resetData"
      size="lg"
    >
      <form class="needs-validation form-group">
        <div class="row mb-3">
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">ลูกค้า:</span>
              <select
                v-model="data.od_id"
                name="order"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('order'),
                }"
                class="custom-select form-control"
                required
              >
                <option value="" disabled selected>กรุณาเลือก...</option>
                <option
                  v-for="od in order"
                  v-bind:key="od.od_id"
                  v-bind:value="od.od_id"
                >
                  {{ od.od_name }} {{ od.od_lname }} ที่อยู่.{{
                    od.od_address
                  }}
                  ถนน.{{ od.od_road }} ตำบล.{{ od.od_locality }} อำเภอ.{{
                    od.od_district
                  }}
                  จังหวัด.{{ od.od_province }}
                </option>
              </select>
              <span class="invalid-feedback">{{ errors.first("order") }}</span>
            </div>
          </div>
        </div>

        <div class="row mb-3">
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">วันรับของ:</span>
              <input
                type="date"
                name="date_final"
                aria-label="date_final"
                v-model="data.date_final"
                :min="new Date().toLocaleDateString('en-CA')"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('date_final'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("date_final")
              }}</span>
            </div>
          </div>
        </div>

        <div v-for="(v, index) in data.vegetable" :key="index">
          <div class="row mb-2">
            <div class="col">
              <div class="input-group">
                <span class="input-group-text">{{ index + 1 }}</span>
                <select
                  v-model="v.v_id"
                  name="v_id"
                  v-validate="'required'"
                  :class="{
                    input: true,
                    'is-invalid': errors.has('v_id'),
                  }"
                  class="custom-select form-control"
                  required
                >
                  <option value="" disabled selected>กรุณาเลือกผัก</option>
                  <option
                    v-for="vegetables in vegetable"
                    v-bind:key="vegetables.v_id"
                    v-bind:value="vegetables.v_id"
                  >
                    {{ vegetables.v_name }}
                  </option>
                </select>
                <input
                  type="number"
                  aria-label="weight"
                  v-model.number="v.weight"
                  name="weight"
                  v-validate="'required'"
                  :class="{
                    input: true,
                    'is-invalid': errors.has('weight'),
                  }"
                  class="form-control form-control"
                />
                <select
                  v-model="v.unit_id"
                  name="unit_id"
                  v-validate="'required'"
                  :class="{
                    input: true,
                    'is-invalid': errors.has('unit_id'),
                  }"
                  class="custom-select form-control"
                  required
                >
                  <option value="" disabled selected>กรุณาเลือกหน่วย</option>
                  <option
                    v-for="units in unit"
                    v-bind:key="units.unit_id"
                    v-bind:value="units.unit_id"
                  >
                    {{ units.unit_eng }} ({{ units.unit_th }})
                  </option>
                </select>
              </div>
              <span class="invalid-feedback">{{ errors.first("v_id") }}</span>
              <span class="invalid-feedback">{{ errors.first("weight") }}</span>
              <span class="invalid-feedback">{{
                errors.first("unit_id")
              }}</span>
            </div>
          </div>
        </div>
      </form>
      <!-- <div class="text-center">
        <b-button
          @click="addindex()"
          class="btn btn-success btn-sm ml-1 mt-1 actions"
          style="height: 35px; width: 80px;"
        >
          เพิ่ม
        </b-button>
        <b-button
          @click="data.vegetable.length > 1 ? data.vegetable.pop() : null"
          class="btn btn-danger btn-sm ml-1 mt-1 actions"
          style="height: 35px; width: 80px;"
        >
          ลด
        </b-button>
      </div> -->
    </b-modal>
  </div>
</template>

<script>
import axios from "axios";
import swal from "sweetalert";
export default {
  components: {},
  props: {
    vegetable_order: Function,
  },
  data() {
    return {
      data: {},
      order: [],
      unit: [],
      vegetable: [],
    };
  },

  async mounted() {
    const accessToken = localStorage.getItem("accessToken");
    if (await accessToken) {
      try {
        const unit = await axios.get(this.$apiUrl + "unit", {
          headers: { Authorization: `bearer ${accessToken}` },
        });

        const vegetable = await axios.get(this.$apiUrl + "vegetable", {
          headers: { Authorization: `bearer ${accessToken}` },
        });

        const order = await axios.get(this.$apiUrl + "order", {
          headers: { Authorization: `bearer ${accessToken}` },
        });
        this.order = order.data;
        this.vegetable = vegetable.data;
        this.unit = unit.data;
      } catch {
        this.$router.push("/");
        localStorage.removeItem("user");
      }
    } else {
      this.$router.push("/");
    }
  },

  methods: {
    handleOk(bvModalEvt) {
      // Prevent modal from closing
      bvModalEvt.preventDefault();
      // Trigger submit handler
      this.SaveVegetable_order();
    },

    resetData() {
      this.data = {
        od_id: "",
        date_final: "",
        vegetable: [
          {
            unit_id: "",
            v_id: "",
            weight: 10,
          },
        ],
      };
    },

    addindex() {
      this.data.vegetable.push({ unit_id: "", v_id: "", weight: 10 });
    },

    async SaveVegetable_order() {
      this.$validator.validateAll().then(async (result) => {
        if (result) {
          const accessToken = localStorage.getItem("accessToken");
          if (await accessToken) {
            try {
              this.$bvModal.hide("AddVegetable_order");
              await axios.post(this.$apiUrl + "addvegetable_order", this.data, {
                headers: { Authorization: `bearer ${accessToken}` },
              });
              this.vegetable_order();
              swal("เพิ่มข้อมูลเสร็จสิ้นแล้ว!", {
                icon: "success",
                buttons: "ตกลง",
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
