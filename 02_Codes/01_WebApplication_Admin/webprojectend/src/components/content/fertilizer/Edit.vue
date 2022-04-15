<template>
  <div id="Edit">
    <!-- edit modal Edit -->
    <b-modal
      :id="editModal.id"
      :title="editModal.title"
      ok-title="ตกลง"
      cancel-title="ยกเลิก"
      @ok="handleOk"
      @cancel="Fertilizer"
      size="lg"
    >
      <form class="form-group needs-validation">
        <div class="row mb-3">
          <div class="col" style="min-width: 300px;">
            <div class="input-group">
              <span class="input-group-text">ชื่อปุ๋ย:</span>
              <input
                type="text"
                aria-label="fertilizer_type"
                name="fertilizer_type"
                v-validate="'required'"
                v-model="editModal.content.fertilizer_type"
                :class="{
                  input: true,
                  'is-invalid': errors.has('fertilizer_type'),
                }"
                class="form-control"
              />
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
                v-model.number="editModal.content.day_times"
                v-validate="'required|min_value:1|integer'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('day_times'),
                }"
                min="1"
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
          <div class="col" style="min-width: 300px;">
            <div class="input-group">
              <span class="input-group-text">จำนวนวันก่อนใส่ปุ๋ยครั้งแรก:</span>
              <input
                type="number"
                aria-label="num_first"
                name="num_first"
                v-model.number="editModal.content.num_first"
                v-validate="'required|min_value:1|integer'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('num_first'),
                }"
                min="1"
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
                v-model.number="editModal.content.num_pick"
                v-validate="'required|min_value:1|integer'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('num_pick'),
                }"
                min="1"
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
          v-for="f_at in editModal.content.fertilizer_at"
          :key="f_at.time"
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
                min="1"
                class="form-control"
              />
              <span class="invalid-feedback">{{ errors.first("time") }}</span>
            </div>
          </div>
          <div class="col" style="min-width: 300px;">
            <div class="input-group">
              <span class="input-group-text">ปริมาณปุ๋ย/พื้นที่:</span>
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
                min="1"
                class="form-control"
              />
              <select
                v-model="f_at.unit.unit_id"
                class="custom-select input-group-text"
                name="unit"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('unit'),
                }"
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
                errors.first("unit")
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
            editModal.content.fertilizer_at.length > 1
              ? editModal.content.fertilizer_at.pop()
              : null
          "
          :class="editModal.content.fertilizer_at.length > 1 ? null:'disabled'"
          class="btn btn-danger btn-sm ml-1 mt-1 actions"
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
    editModal: Object,
    Fertilizer: Function,
  },

  data() {
    return {
      unit: Array,
    };
  },

  async mounted() {
    const accessToken = localStorage.getItem("accessToken");
    if (await accessToken) {
      try {
        const unit = await axios.get(this.$apiUrl + "unit", {
          headers: { Authorization: `bearer ${accessToken}` },
        });
        this.unit = unit.data;
      } catch {
        this.$router.push("/");
        localStorage.removeItem("username");
      }
    } else {
      this.$router.push("/");
    }
  },

  methods: {
    addindex() {
      this.editModal.content.fertilizer_at.push({
        fertilizer_amount: 1,
        time: "",
        unit: {
          unit_id:""
        },
      });
    },

    handleOk(bvModalEvt) {
      // Prevent modal from closing
      bvModalEvt.preventDefault();
      // Trigger submit handler
      this.SaveFertilizer();
    },

    async SaveFertilizer() {
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
                this.$apiUrl +
                  "fertilizer/" +
                  this.editModal.content.fertilizer_id,
                this.editModal.content,
                {
                  headers: { Authorization: `bearer ${accessToken}` },
                }
              );
              swal("อัพเดทเสร็จสิ้น!", {
                icon: "success",
                button: "ตกลง",
              });
              this.Fertilizer();
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
