<template>
  <div id="Add">
    <!-- add modal Add -->
    <b-modal
      id="AddProblems"
      title="เพิ่มข้อมูลปัญหา"
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
              <span class="input-group-text">ปัญหา:</span>
              <input
                type="text"
                name="problems_name"
                aria-label="Problems type"
                v-model="data.problems_name"
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

        <div class="row mb-3" v-for="(solving,index) in data.solving"
            :key="index">
          <div
            class="col"
          >
            <div class="input-group">
              <span class="input-group-text">แก้ปัญหา:</span>
              <b-form-input
                list="my-list-id"
                type="text"
                aria-label="solving"
                name="solving"
                v-validate="'required'"
                v-model="data.solving[index].name"
                :class="{
                  input: true,
                  'is-invalid': errors.has('solving'),
                }"
                class="form-control"
                ></b-form-input
              >

              <datalist id="my-list-id">
                <option v-for="(size,i) in sizes" :key="i">{{ size.name }}</option>
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
                v-model="data.solving[index].amount"
                name="amount"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('amount'),
                }"
                class="form-control"
              />
              <span class="invalid-feedback">{{
                errors.first("amount")
              }}</span>
            </div>
          </div>
          <div class="col-3" >
            <select
              v-model="data.solving[index].unit_id"
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
                v-model="data.cycle"
                name="cycle"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('cycle'),
                }"
                class="form-control"
              />
              <span class="input-group-text">วันครั้ง</span>
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
                v-model="data.phase"
                name="phase"
                v-validate="'required'"
                :class="{
                  input: true,
                  'is-invalid': errors.has('phase'),
                }"
                class="form-control"
              />
              <span class="input-group-text">ครั้ง</span>
              <span class="invalid-feedback">{{
                errors.first("phase")
              }}</span>
            </div>
          </div>
        </div>
        <!-- <div class="text-center">
          <b-button
            class="btn btn-success btn-sm ml-1 mt-1 actions"
            style="height: 35px; width: 80px;"
            @click="data.solving.push('');"
          >
            เพิ่ม
          </b-button>
          <b-button
            class="btn btn-danger btn-sm ml-1 mt-1 actions"
            style="height: 35px; width: 80px;"
            @click="data.solving.length > 1 ? data.solving.pop(): null"
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
      solving: "การแก้ปัญหา",
      problems_name:"ปัญหา"
    },
  },
};

Validator.localize(dictionary);

export default {
  components: {},
  props: {
    Problems: Function,
    sizes:Array
  },
  data() {
    return {
      data: {},
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

    resetData() {
      this.data = {
        problems_name: "",
        cycle:"",
        solving: [
          {
            name: '',
            amount: '',
            unit_id: ''
          },
        ],
      };
    },

    async SaveProblems() {
      this.$validator.validateAll().then(async (result) => {
        if (result) {
      const accessToken = localStorage.getItem("accessToken");
      if (await accessToken) {
        try {
          this.$bvModal.hide("AddProblems");

          let result = await axios.post(this.$apiUrl + "addproblems", this.data, {
            headers: { Authorization: `bearer ${accessToken}` },
          }).catch(function(error) {
            if (error.response && error.response.status === 401) {
                swal(
                  "ผิดพลาด : " + error.response.status,
                  error.response.data,
                  "ผิดพลาด"
                  ,{
                icon: "error",
                button: "ตกลง",
              }
                );
              }
          });

          if(result){
            this.Problems();
          swal("เพิ่มข้อมูลเสร็จสิ้นแล้ว!", {
            icon: "success",
            button: "ตกลง",
          });
          }

        } catch {
          this.$router.push("/");
          // localStorage.removeItem("username");
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
