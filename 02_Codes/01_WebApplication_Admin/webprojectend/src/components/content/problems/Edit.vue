<template>
  <div id="Edit">
    <!-- edit modal Edit -->
    <b-modal
      :id="editModal.id"
      :title="editModal.title"
      ok-title="ตกลง"
      cancel-title="ยกเลิก"
      @ok="handleOk"
      @cancel="Problems"
      size="lg"
    >
      <form class="needs-validation form-group">
        <div class="row mb-3">
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">ปัญหา:</span>
              <input
                type="text"
                name="problems_name"
                aria-label="Problems type"
                v-model="editModal.content.problems_name"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('problems_name'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("problems_name")
              }}</span>
            </div>
          </div>
        </div>

        <div
          class="row mb-3"
          v-for="(solving, index) in editModal.content.solving"
          :key="index"
        >
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">แก้ปัญหา:</span>
              <b-form-input
                list="my-list-id"
                type="text"
                aria-label="solving"
                name="solving"
                v-validate="'required'"
                v-model="editModal.content.solving[index].name"
                :class="{
                  input: true,
                  'is-invalid': errors.has('solving'),
                }"
                class="form-control"
                >{{ solving }}</b-form-input
              >

              <datalist id="my-list-id">
                <option v-for="size in sizes" :key="size">{{
                  size.name
                }}</option>
              </datalist>

              <span class="invalid-feedback">{{
                errors.first("solving")
              }}</span>
            </div>
          </div>
          <div class="col-3">
            <div class="input-group">
              <span class="input-group-text">จำนวน:</span>
              <input
                type="number"
                aria-label="amount"
                v-model="editModal.content.solving[index].amount"
                name="amount"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('amount'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{ errors.first("amount") }}</span>
            </div>
          </div>
          <div class="col-4" style="min-width: 300px;">
            <select
              v-model="editModal.content.solving[index].unit.unit_id"
              name="unit"
              v-validate="'required'"
              :class="{
                input: true,
                'is-invalid': errors.has('unit'),
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
            <span class="invalid-feedback">{{ errors.first("unit") }}</span>
          </div>
        </div>
        <div class="row">
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">รอบการใส่:</span>
              <input
                type="number"
                aria-label="cycle"
                v-model="editModal.content.cycle"
                name="cycle"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('cycle'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("cycle")
              }}</span>
            </div>
          </div>
          <div class="col">
            <div class="input-group">
              <span class="input-group-text">ระยะการใส่:</span>
              <input
                type="number"
                aria-label="phase"
                v-model="editModal.content.phase"
                name="phase"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('phase'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("phase")
              }}</span>
            </div>
          </div>
        </div>
        <!-- <div class="text-center disabled">
          <b-button
            @click="editModal.content.solving.push('')"
            class="btn btn-success btn-sm ml-1 mt-1 actions"
            style="height: 35px; width: 80px;"
          >
            เพิ่ม
          </b-button>
          <b-button
            @click="editModal.content.solving.length > 1 ? editModal.content.solving.pop() : null"
            class="btn btn-danger btn-sm ml-1 mt-1 actions"
            style="height: 35px; width: 80px;"
          >
            ลด
          </b-button>
        </div> -->
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
      solving: "แก้ปัญหา",
    },
  },
};

Validator.localize(dictionary);

export default {
  components: {},
  props: {
    editModal: Object,
    Problems: Function,
    sizes: Array,
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
      this.SaveProblems();
    },

    async SaveProblems() {
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
                  await axios.put(
                    this.$apiUrl +
                      "problems/" +
                      this.editModal.content.problems_id,
                    this.editModal.content,
                    {
                      headers: { Authorization: `bearer ${accessToken}` },
                    }
                  );
                  this.Problems();
                  swal("อัพเดทเสร็จสิ้น!", {
                    icon: "success",
                    button: "ตกลง",
                  });
                  this.$bvModal.hide(this.editModal.id);
                } else {
                  swal("ยกเลิกแล้ว!", {
                    icon: "error",
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

<style></style>
