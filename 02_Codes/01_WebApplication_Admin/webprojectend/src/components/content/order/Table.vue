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
        <b-col sm="7" md="5" lg="4" xl="4" class="my-1 text-right">
          <b-button
            v-b-modal.AddOrder
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
        :filter-included-fields="filterOn"
        :busy="isBusy"
        empty-text="ไม่มีข้อมูล"
        empty-filtered-text="ไม่มีข้อมูล"
        stacked="sm"
        show-empty
        class="table table-bordered"
      >
        <template #table-busy>
          <div class="text-center text-danger my-2">
            <b-spinner class="align-middle"></b-spinner>
            <strong>กำลังโหลด...</strong>
          </div>
        </template>

        <template #cell(od_name)="row">
          {{ row.value }} {{ row.item.od_lname }}</template
        >
        <template #cell(od_id)="row"> {{ row.item.id }}</template>

        <template #cell(actions)="row">
          <b-button
            @click="row.toggleDetails"
            class="btn btn-info btn-sm ml-1 mt-1 actions"
            style="height: 35px;"
          >
            <i class="material-icons">
              {{ row.detailsShowing ? "expand_less" : "expand_more" }}
            </i>
          </b-button>

          <b-button
            @click="Edit(row.item, row.item.od_id, $event.target)"
            class="btn btn-warning btn-sm ml-1 mt-1 actions"
            style="height: 35px;"
            v-b-popover.hover.top="'แก้ไข : ' + row.item.od_name"
          >
            <i class="material-icons">
              edit
            </i>
          </b-button>
          <b-button
            @click="Delete(row.item.od_id)"
            :disabled=row.item.status
            class="btn btn-danger btn-sm ml-1 mt-1 actions"
            style="height: 35px;"
            v-b-popover.hover.top="'ลบ : ' + row.item.od_name"
          >
            <i class="material-icons">
              delete_forever
            </i>
          </b-button>
        </template>

        <template #row-details="row">
          <b-card style="background-color: #eee;">
            <Vorder :od_id="row.item.od_id" />
          </b-card>
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
      <Edit :editModal="editModal" v-bind:Order="Order" />
      <Add v-bind:Order="Order" />
    </b-container>
  </div>
</template>

<script>
import axios from "axios";
import swal from "sweetalert";
import Edit from "./Edit";
import Add from "./Add";
import Vorder from "./v_order/Table";
import { Validator } from 'vee-validate';
const dictionary = {
  th: {
    attributes: {
      od_name: 'ชื่อ',
      od_lname: 'นามสกุล',
      od_address: 'บ้านเลขที่',
      od_road: 'ถนน',
      od_locality: 'ตำบล',
      od_district: 'อำเภอ',
      od_province: 'จังหวัด',
      od_phnum: 'เบอร์โทรศัพท์',
      od_date: 'วันที่เพิ่ม',
    }
  },
};

Validator.localize(dictionary);

export default {
  components: { Edit, Add, Vorder },
  metaInfo: {
    title: "Order",
  },
  data() {
    return {
      items: [],
      isBusy: true,
      fields: [
        {
          key: "od_id",
          label: "ลำดับ",
          sortable: true,
          sortDirection: "desc",
        },
        {
          key: "od_name",
          label: "ชื่อ",
          sortable: true,
          class: "text-center",
        },
        {
          key: "od_address",
          label: "บ้านเลขที่",
          sortable: true,
          class: "text-center",
        },
        {
          key: "od_road",
          label: "ถนน",
          sortable: true,
          class: "text-center",
        },
        {
          key: "od_locality",
          label: "ตำบล",
          sortable: true,
          class: "text-center",
        },
        {
          key: "od_district",
          label: "อำเภอ",
          sortable: true,
          class: "text-center",
        },
        {
          key: "od_province",
          label: "จังหวัด",
          sortable: true,
          class: "text-center",
        },
        {
          key: "od_phnum",
          label: "เบอร์โทรศัพท์",
          sortable: true,
          class: "text-center",
        },
        {
          key: "od_date",
          label: "วันที่เพิ่ม",
          sortable: true,
          class: "text-center",
        },
        { key: "actions", label: "การดำเนินการ" },
      ],
      totalRows: 1,
      currentPage: 1,
      perPage: 5,
      pageOptions: [5, 10, 15, 30, 50, { value: 100, text: "100" }],
      filter: "",
      filterOn: [],
      editModal: {
        id: "edit-modal",
        title: "",
        content: "",
      },
    };
  },
  async mounted() {
    this.Order();
  },

  methods: {
    Edit(item, index, button) {
      this.editModal.title = `แก้ไขรายชื่อลูกค้า`;
      this.editModal.content = item;
      this.$root.$emit("bv::show::modal", this.editModal.id, button);
    },

    async Order() {
      this.$toasts.warning('กำลังโหลดข้อมูลกรุณารอสักครู่')
      const accessToken = localStorage.getItem("accessToken");
      if (await accessToken) {
        try {
          const response = await axios.get(this.$apiUrl + "order", {
            headers: { Authorization: `bearer ${accessToken}` },
          });

          this.items = response.data;
          this.editModal.content = response.data[0];

          // Set the initial number of items
          this.totalRows = this.items.length;
          this.isBusy = false;
          this.$toasts.success('เรียกข้อมูลเสร็จสิ้น')
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
          await axios.delete(this.$apiUrl + "order/" + id, {
            headers: { Authorization: `bearer ${accessToken}` },
          });
          this.Order();
          swal("ลบเสร็จสิ้น!", {
            icon: "success",
            buttons: "ตกลง",
          });
        } else {
          swal("ยกเลิกแล้ว!",{buttons: "ตกลง",});
        }
      });
    },
  },
};
</script>

<style scoped>
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
