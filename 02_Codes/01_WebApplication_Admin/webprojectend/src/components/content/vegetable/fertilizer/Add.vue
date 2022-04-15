<template>
  <div id="Add">
    <!-- add modal Add -->
    <b-modal
      id="AddFertilizer"
      title="เพิ่มข้อมูลปุ๋ย"
      @ok="handleOk"
      @show="resetData"
      ok-title="ตกลง"
      cancel-title="ยกเลิก"
      size="lg"
    >
      <form class="form-group needs-validation">
        <div class="row mb-3">
          <div class="col" style="min-width: 300px;">
            <div class="input-group">
              <span class="input-group-text">ชนิดปุ๋ย:</span>
              <b-form-input
                list="my-list-id"
                type="text"
                aria-label="fertilizer_type"
                name="fertilizer_type"
                v-validate="'required'"
                v-model="data.fertilizer_type"
                :class="{
                  input: true,
                  'is-invalid': errors.has('fertilizer_type'),
                }"
                class="form-control"
              ></b-form-input>

              <datalist id="my-list-id">
                <option
                  v-for="(size, index) in sizes"
                  :key="size.fertilizer_type + index"
                  >{{ size.fertilizer_type }}</option
                >
              </datalist>

              <span class="invalid-feedback">{{
                errors.first("fertilizer_type")
              }}</span>
            </div>
          </div>
        </div>

        <div class="row mb-3">
          <div class="col" style="min-width: 300px;">
            <div class="input-group">
              <span class="input-group-text">จำนวนวัน/ครั้ง:</span>
              <input
                type="number"
                aria-label="day_times"
                name="day_times"
                v-model.number="data.day_times"
                v-validate="'required|min_value:0|integer'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('day_times'),
                }"
                min="0"
                class="form-control"
              />
              <span class="input-group-text">วัน</span>
              <span class="invalid-feedback">{{
                errors.first("day_times")
              }}</span>
            </div>
          </div>
        </div>

        <div class="row mb-3">
          <div class="col mb-3" style="min-width: 300px;">
            <div class="input-group">
              <span class="input-group-text">จำนวนวันก่อนใส่ปุ๋ยครั้งแรก:</span>
              <input
                type="number"
                aria-label="num_first"
                name="num_first"
                v-model.number="data.num_first"
                v-validate="'required|min_value:0|integer'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('num_first'),
                }"
                min="0"
                class="form-control"
              />
              <span class="input-group-text">วัน</span>
              <span class="invalid-feedback">{{
                errors.first("num_first")
              }}</span>
            </div>
          </div>

          <div class="col" style="min-width: 300px;">
            <div class="input-group">
              <span class="input-group-text">จำนวนวันหยุดใส่ปุ๋ยก่อนเก็บ:</span>
              <input
                type="number"
                aria-label="num_pick"
                name="num_pick"
                v-model.number="data.num_pick"
                v-validate="'required|min_value:0|integer'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('num_pick'),
                }"
                min="0"
                class="form-control"
              />
              <span class="input-group-text">วัน</span>
              <span class="invalid-feedback">{{
                errors.first("num_pick")
              }}</span>
            </div>
          </div>
        </div>
        <div
          class="row mb-3"
          v-for="(f_at, index) in data.fertilizer_at"
          :key="f_at.time + index"
        >
          <div class="col" style="min-width: 300px;">
            <div class="input-group">
              <span class="input-group-text">เวลา:</span>
              <input
                type="time"
                aria-label="time"
                name="time"
                v-model="f_at.time"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('time'),
                }"
                min="0"
                class="form-control"
              />
              <span class="invalid-feedback">{{ errors.first("time") }}</span>
            </div>
          </div>
          <div class="col" style="min-width: 300px;">
            <div class="input-group">
              <span class="input-group-text">ปริมาณปุ๋ย:</span>
              <input
                type="number"
                aria-label="fertilizer_amount"
                name="fertilizer_amount"
                v-model.number="f_at.fertilizer_amount"
                v-validate="'required|min_value:1|integer'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('fertilizer_amount'),
                }"
                min="0"
                class="form-control"
              />
              <select
                name="unit_id"
                v-validate="'required'"
                v-model="f_at.unit_id"
                :class="{
                  input: true,
                  'is-invalid': errors.has('unit_id'),
                }"
                class="custom-select input-group-text"
                required
              >
                <option value="" disabled selected>กรุณาเลือก...</option>
                <option
                  v-for="units in unit"
                  v-bind:key="units.unit_id"
                  v-bind:value="units.unit_id"
                >
                  {{ units.unit_eng }} ({{ units.unit_th }})
                </option>
              </select>
              <span class="invalid-feedback">{{
                errors.first("fertilizer_amount")
              }}</span>
              <span class="invalid-feedback">{{
                errors.first("unit_id")
              }}</span>
            </div>
          </div>
        </div>
      </form>
      <div class="text-center">
        <b-button
          @click="addindex()"
          class="btn btn-success btn-sm ml-1 mt-1 actions"
          style="height: 35px; width: 80px;"
        >
          เพิ่ม
        </b-button>
        <b-button
          @click="
            data.fertilizer_at.length > 1 ? data.fertilizer_at.pop() : null
          "
          class="btn btn-danger btn-sm ml-1 mt-1 actions"
          :disabled="data.fertilizer_at.length > 1 ? false : true"
          style="height: 35px; width: 80px;"
        >
          ลด
        </b-button>
      </div>
    </b-modal>
  </div>
</template>

<script>
import axios from "axios";
import swal from "sweetalert";

export default {
  components: {},
  props: {
    id: String,
    Vegetable: Function,
  },
  data() {
    return {
      sizes: [],
      data: {
        fertilizer_type: "",
        day_times: 1,
        num_first: 1,
        num_pick: 1,
        fertilizer_at: [
          {
            fertilizer_amount: 1,
            time: "",
            unit_id: "",
          },
        ],
      },
      unit: [],
    };
  },

  async mounted() {
    const accessToken = localStorage.getItem("accessToken");
    if (await accessToken) {
      try {
        const unit = await axios.get(this.$apiUrl + "unit", {
          headers: { Authorization: `bearer ${accessToken}` },
        });
        const fertilizer = await axios.get(this.$apiUrl + "fertilizer", {
          headers: { Authorization: `bearer ${accessToken}` },
        });
        this.sizes = fertilizer.data;
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
    addindex() {
      this.data.fertilizer_at.push({
        fertilizer_amount: 1,
        time: "",
        unit_id: "",
      });
    },

    handleOk(bvModalEvt) {
      // Prevent modal from closing
      bvModalEvt.preventDefault();
      // Trigger submit handler
      this.SaveFertilizer();
    },

    resetData() {
      this.data = {
        fertilizer_type: "",
        day_times: 1,
        num_first: 1,
        num_pick: 1,
        fertilizer_at: [
          {
            fertilizer_amount: 1,
            time: "",
            unit_id: "",
          },
        ],
      };
    },

    async SaveFertilizer() {
      this.$validator.validateAll().then(async (result) => {
        if (result) {
          const accessToken = localStorage.getItem("accessToken");
          if (await accessToken) {
            try {
              this.$bvModal.hide("AddFertilizer");
              await axios
                .post(
                  this.$apiUrl + "vegetable/vfertilizer/" + this.id,
                  this.data,
                  {
                    headers: { Authorization: `bearer ${accessToken}` },
                  }
                )
                .then((req) => {
                  if (req.status == 204) {
                    this.Vegetable();
                    swal("เพิ่มข้อมูลเสร็จสิ้นแล้ว!", {
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
  },
};
</script>

<style>
.table th,
.table td {
  vertical-align: middle;
}
</style>
