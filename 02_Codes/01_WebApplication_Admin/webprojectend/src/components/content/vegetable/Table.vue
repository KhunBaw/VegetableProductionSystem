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
            v-b-modal.AddVegetable
            class="btn btn-success btn-sm"
            style="height: 35px; width: 140px"
          >
            เพิ่ม
          </b-button>
        </b-col>
      </b-row>

      <!-- Main table element -->
      <b-table
        primary-key="v_id"
        :items="items"
        :fields="fields"
        :current-page="currentPage"
        :per-page="perPage"
        :filter="filter"
        :filter-included-fields="filterOn"
        :busy="isBusy"
        stacked="sm"
        empty-text="ไม่มีข้อมูล"
        empty-filtered-text="ไม่มีข้อมูล"
        show-empty
        class="table table-bordered"
      >
        <template #table-busy>
          <div class="text-center text-danger my-2">
            <b-spinner class="align-middle"></b-spinner>
            <strong> กำลังโหลด...</strong>
          </div>
        </template>

        <template #cell(v_id)="row"> {{ row.item.id }}</template>
        <template #cell(distance)="row"> {{ row.item.v_wide }} x {{ row.item.v_long }}</template>
        <template #cell(v_nfv)="row"> {{ row.value }} กรัม </template>
        <template #cell(v_d1)="row"> {{ row.value }} วัน </template>
        <template #cell(v_d2)="row"> {{ row.value }} วัน </template>
        <template #cell(v_d3)="row"> {{ row.value }} วัน </template>
        <template #cell(v_photo)="row"><img :src="row.value" style="width: auto; height: 100px;"></template>

        <template #cell(actions)="row">
          <b-button
            @click="row.toggleDetails"
            class="btn btn-info btn-sm ml-1 mt-1 actions"
            style="height: 35px"
          >
            <i class="material-icons"> grass </i>
          </b-button>
          <b-button
            @click="Edit(row.item, row.item.v_name, $event.target)"
            :disabled=row.item.status
            class="btn btn-warning btn-sm ml-1 mt-1 actions"
            style="height: 35px"
            v-b-popover.hover.top="'แก้ไข : ' + row.item.v_name"
          >
            <i class="material-icons"> edit </i>
          </b-button>
          <b-button
            @click="Delete(row.item.v_id, row.item.v_name)"
            :disabled=row.item.status
            class="btn btn-danger btn-sm ml-1 mt-1 actions"
            style="height: 35px"
            v-b-popover.hover.top="'ลบ : ' + row.item.v_name"
          >
            <i class="material-icons"> delete_forever </i>
          </b-button>
        </template>

        <template #row-details="row">
          <b-card style="background-color: #eee;">
            <Fertilizer :items="row.item.v_fertilizer" :v_id="row.item.v_id" v-bind:Vegetable="Vegetable"/>
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
      <Edit :editModal="editModal" v-bind:Vegetable="Vegetable" />
      <Add v-bind:Vegetable="Vegetable" />
    </b-container>
  </div>
</template>

<script>
import axios from "axios";
import swal from "sweetalert";
import Edit from "./Edit";
import Add from "./Add";
import Fertilizer from './fertilizer/Table'
import { Validator } from "vee-validate";
const dictionary = {
  th: {
    attributes: {
      v_name: "ชื่อผัก",
      v_wide: "ระยะปลูก(กว้าง)",
      v_long: "ระยะปลูก(ยาว)",
      v_nfv: "น้ำหนัก/ต้น",
      v_d1: "จำนวนวันที่เพาะ",
      v_d2: "จำนวนวันที่ปลูก",
      v_d3: "จำนวนวันที่เก็บ",
    },
  },
};

Validator.localize(dictionary);

export default {
  components: { Edit, Add, Fertilizer },
  metaInfo: {
    title: "Vegetable",
  },
  data() {
    return {
      items: [],
      isBusy: true,
      fields: [
        {
          key: "v_id",
          label: "ลำดับ",
          sortable: true,
          sortDirection: "desc",
        },
        {
          key: "v_photo",
          label: "รูปภาพ",
          sortable: true,
          class: "text-center",
        },
        {
          key: "v_name",
          label: "ชื่อผัก",
          sortable: true,
          class: "text-center",
        },
        {
          key: "distance",
          label: "ระยะปลูก(กว้าง x ยาว)",
          sortable: true,
          class: "text-center",
        },
        {
          key: "v_nfv",
          label: "น้ำหนัก",
          sortable: true,
          class: "text-center",
        },
        {
          key: "v_d1",
          label: "จำนวนวันที่เพาะ",
          sortable: true,
          class: "text-center",
        },
        {
          key: "v_d2",
          label: "จำนวนวันที่ปลูก",
          sortable: true,
          class: "text-center",
        },
        {
          key: "v_d3",
          label: "จำนวนวันที่เก็บ",
          sortable: true,
          class: "text-center",
        },
        { key: "actions", label: "การดำเนินการ" },
      ],
      totalRows: 1,
      currentPage: 1,
      perPage: 5,
      pageOptions: [5, 10, 15, 30, 50, 100],
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
    this.Vegetable();
  },

  methods: {
    Edit(item, index, button) {
      this.editModal.title = `แก้ไข : ${index}`;
      this.editModal.content = item;
      this.$root.$emit("bv::show::modal", this.editModal.id, button);
    },

    async Vegetable() {
      this.$toasts.warning("กำลังโหลดข้อมูลกรุณารอสักครู่");
      const accessToken = localStorage.getItem("accessToken");
      if (await accessToken) {
        try {
          const response = await axios.get(this.$apiUrl + "vegetable", {
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

    async Delete(id, name) {
      const accessToken = await localStorage.getItem("accessToken");
      swal({
        title: "คุณแน่ใจหรือไม่?",
        text: "คุณแน่ใจหรือไม่ที่จะลบ : " + name,
        icon: "warning",
        buttons: ["ยกเลิก", "ตกลง"],
        dangerMode: true,
      }).then(async (willDelete) => {
        if (willDelete) {
          await axios.delete(this.$apiUrl + "vegetable/" + id, {
            headers: { Authorization: `bearer ${accessToken}` },
          });
          this.Vegetable();
          swal("ลบเสร็จสิ้น!", {
            icon: "success",
            button: "ตกลง",
          });
        } else {
          swal("ยกเลิกแล้ว!", {
            icon: "success",
            button: "ตกลง",
          });
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
