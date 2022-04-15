<template>
  <div>
    <b-container fluid>
      <b-row align-h="between">
        <b-col sm="9" md="6" lg="5" xl="4" class="my-1">
          <b-form-group
            label="ค้นหา"
            label-for="filter-input"
            label-cols-sm="3"
            label-align-sm="right"
            label-size="sm"
            class="mb-2"
          >
            <b-input-group size="sm">
              <b-form-input
                id="filter-input"
                v-model="filter"
                type="search"
                placeholder="พิมพ์เพื่อค้นหา"
              ></b-form-input>

              <b-input-group-append>
                <b-button :disabled="!filter" @click="filter = ''"
                  >ล้างการค้นหา</b-button
                >
              </b-input-group-append>
            </b-input-group>
          </b-form-group>
        </b-col>

        <b-col sm="7" md="5" lg="4" xl="5" class="my-1">
          <b-form-group
            label="ตัวกรอง"
            label-cols-sm="3"
            label-align-sm="right"
            label-size="sm"
            class="mb-3"
          >
            <!-- <b-form-checkbox-group
              id="checkbox-group-2"
              v-model="filter"
              name="flavour-2"
              class="pt-1"
            >
              <b-form-checkbox value="final">พร้อมส่ง</b-form-checkbox>
              <b-form-checkbox value="progress">กำลังปลูก</b-form-checkbox>
              <b-form-checkbox value="problem">มีปัญหา</b-form-checkbox>
              <b-form-checkbox value="start">ไม่เริ่มปลูก</b-form-checkbox>
            </b-form-checkbox-group> -->

            <b-form-radio-group
              id="radio-group-2"
              v-model="filter"
              name="radio-sub-component"
            >
              <b-form-radio value="final">พร้อมส่ง</b-form-radio>
              <b-form-radio value="progress">กำลังปลูก</b-form-radio>
              <b-form-radio value="problem">มีปัญหา</b-form-radio>
              <b-form-radio value="start">ไม่เริ่มปลูก</b-form-radio>
            </b-form-radio-group>
          </b-form-group>
        </b-col>

        <b-col sm="7" md="5" lg="4" xl="2" class="my-1 text-right">
          <b-button
            v-b-modal.AddVegetable_order
            class="btn btn-success btn-sm"
            style="height: 35px; width: 140px;"
          >
            เพิ่ม
          </b-button>
        </b-col>
      </b-row>

      <!-- Main table element -->
      <b-table
        :items="items"
        :fields="fields"
        :current-page="currentPage"
        :per-page="perPage"
        :filter="filter"
        :busy="isBusy"
        :tbody-tr-class="rowClass"
        :sort-by.sync="sortBy"
        :sort-desc.sync="sortDesc"
        stacked="sm"
        empty-text="ไม่มีข้อมูล"
        empty-filtered-text="ไม่มีข้อมูล"
        show-empty
        class="table table-bordered"
      >
        <template #table-busy>
          <div class="text-center text-danger my-2">
            <b-spinner class="align-middle"></b-spinner>
            <strong>กำลังโหลด...</strong>
          </div>
        </template>
        <template #cell(vegetable)="row">
          <span v-for="(vegetable, index) in row.value" :key="index"
            >{{ vegetable.vegetable.v_name }} {{ vegetable.weight }}
            {{ vegetable.unit.unit_th }} <br
          /></span>
        </template>
        <template #cell(order)="row">
          {{ row.item.order == null ? "มีการลบลูกค้าไปแล้ว" : row.value.od_name +" "+ row.value.od_lname }}</template
        >
        <template #cell(actions)="row">
          <b-button
            @click="Delete(row.item.order_id)"
            class="btn btn-danger btn-sm ml-1 mt-1 actions"
            v-if="row.item.status == 'start'"
            style="height: 35px;"
            v-b-popover.hover.top="'ลบ : ' + row.item.order_id" 
          >
            <i class="material-icons">
              delete_forever
            </i>
          </b-button>
          <b-button
            v-b-modal.QRCode
            v-if="row.item.status == 'final'"
            class="btn btn-info btn-sm ml-1 mt-1 actions"
            style="height: 35px; width: 140px;"
            @click="QR(row.item)"
          >
            QrCode
          </b-button>
          <b-button
            @click="status(row.item.order_id)"
            class="btn btn-success btn-sm ml-1 mt-1 actions"
            v-if="row.item.status == 'final'"
            style="height: 35px;"
            v-b-popover.hover.top="'ยืนยันการรับผัก'"
          >
            ยืนยัน
          </b-button>
        </template>
      </b-table>

      <!-- User Interface controls -->
      <b-row align-h="between">
        <b-col sm="6" md="6" lg="5" xl="4" class="my-1">
          <b-form-group
            label="แสดงหน้าละ"
            label-for="per-page-select"
            label-cols-sm="6"
            label-cols-md="4"
            label-cols-lg="3"
            label-align-sm="right"
            label-size="sm"
            class="mb-0"
          >
            <b-form-select
              id="per-page-select"
              v-model="perPage"
              :options="pageOptions"
              size="sm"
            ></b-form-select>
          </b-form-group>
        </b-col>
        <b-col sm="6" md="6" class="my-1">
          <b-pagination
            v-model="currentPage"
            :total-rows="totalRows"
            :per-page="perPage"
            align="fill"
            size="sm"
            class="my-0"
          ></b-pagination>
        </b-col>
      </b-row>
      <Add v-bind:vegetable_order="vegetable_order" :od_id="od_id" />
      <QR :editModal="editModal" />
    </b-container>
  </div>
</template>

<script>
import axios from "axios";
import swal from "sweetalert";
import Add from "./Add";
import QR from "./QR";
import { Validator } from "vee-validate";

const dictionary = {
  th: {
    attributes: {
      vegetable: "ออเดอร์",
      unit_id: "หน่วย",
      v_id: "ผัก",
      weight: "จำนวน",
      date_final: "วันรับของ",
      order: "ลูกค้า",
    },
  },
};
Validator.localize(dictionary);

export default {
  components: { Add, QR },
  props: {
    od_id: String,
  },
  metaInfo: {
    title: "Order",
  },
  data() {
    return {
      items: [],
      isBusy: true,
      sortBy: "order_id",
      fields: [
        {
          key: "order_id",
          label: "หมายเลข",
          sortable: true,
          sortDirection: "desc",
        },
        {
          key: "order",
          label: "ลูกค้า",
          sortable: true,
          class: "text-center",
        },
        {
          key: "vegetable",
          label: "ออเดอร์",
          sortable: true,
          class: "text-center",
        },
        {
          key: "date",
          label: "วันที่ใส่ข้อมูล",
          sortable: true,
          class: "text-center",
        },
        {
          key: "date_final",
          label: "วันที่รับของ",
          sortable: true,
          class: "text-center",
        },
        { key: "actions", label: "การดำเนินการ" },
      ],
      totalRows: 1,
      currentPage: 1,
      perPage: 5,
      pageOptions: [5, 10, 15, 30, 50, { value: 100, text: "100" }],
      sortDesc: false,
      filter: "",
      editModal: {
        id: "edit-modalv",
        title: "",
        content: "",
      },
    };
  },
  async mounted() {
    this.vegetable_order();
  },

  methods: {
    rowClass(item, type) {
      if (!item || type !== "row") return;
      if (item.status === "final") return "table-success";
      if (item.status === "progress") return "table-warning";
      if (item.status === "problem") return "table-danger";
    },

    async status(id) {
      const accessToken = localStorage.getItem("accessToken");
      if (await accessToken) {
        swal({
          title: "คุณแน่ใจหรือไม่?",
          text: "",
          icon: "warning",
          buttons: ["ยกเลิก", "ตกลง"],
          dangerMode: true,
        }).then(async (will) => {
          if (will) {
            try {
              await axios.get(this.$apiUrl + "vegetable_order_status/" + id, {
                headers: { Authorization: `bearer ${accessToken}` },
              });
              this.vegetable_order();
              swal("เสร็จสิ้น!", {
                icon: "success",
                buttons: "ตกลง",
              });
            } catch {
              this.$router.push("/");
              localStorage.removeItem("username");
              // this.Loading.isloaded = true;
            }
          } else {
            swal("ยกเลิกแล้ว!", { buttons: "ตกลง" });
          }
        });
      } else {
        this.$router.push("/");
        // this.Loading.isloaded = true;
      }
    },

    async vegetable_order() {
      this.$toasts.warning("กำลังโหลดข้อมูลกรุณารอสักครู่");
      const accessToken = localStorage.getItem("accessToken");
      if (await accessToken) {
        try {
          const response = await axios.get(this.$apiUrl + "vegetable_order", {
            headers: { Authorization: `bearer ${accessToken}` },
          });

          this.items = response.data;
          this.editModal.content = response.data[0];

          // Set the initial number of items
          this.totalRows = this.items.length;
          this.isBusy = false;
          this.$toasts.success("เรียกข้อมูลเสร็จสิ้น");
        } catch {
          this.$router.push("/");
          localStorage.removeItem("username");
          // this.Loading.isloaded = true;
        }
      } else {
        this.$router.push("/");
        // this.Loading.isloaded = true;
      }
    },

    QR(item) {
      this.editModal.content = item;
    },

    async Delete(id) {
      const accessToken = await localStorage.getItem("accessToken");
      swal({
        title: "คุณแน่ใจหรือไม่?",
        text: "คุณแน่ใจหรือไม่ที่จะลบไอดี : " + id,
        icon: "warning",
        buttons: ["ยกเลิก", "ตกลง"],
        dangerMode: true,
      }).then(async (willDelete) => {
        if (willDelete) {
          await axios.delete(this.$apiUrl + "vegetable_order/" + id, {
            headers: { Authorization: `bearer ${accessToken}` },
          });
          this.vegetable_order();
          swal("ลบเสร็จสิ้น!", {
            icon: "success",
            buttons: "ตกลง",
          });
        } else {
          swal("ยกเลิกแล้ว!", { buttons: "ตกลง" });
        }
      });
    },
  },
};
</script>

<style scoped>
table#table-transition-example .flip-list-move {
  transition: transform 1s;
}

@media (max-width: 1400px) {
  .actions {
    margin-top: 5px;
    margin-left: 0rem !important;
  }
}

@media (max-width: 768px) {
  .actions {
    margin-top: 0px;
    margin-left: 5px !important;
  }
}
</style>
