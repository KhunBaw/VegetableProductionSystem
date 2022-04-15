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
            v-b-modal.AddProblems
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
        <template #cell(problems_id)="row"> {{ row.item.id }}</template>

        <template #cell(solving)="row"
          ><span v-for="(solving, i) in row.value" :key="i"
            >{{ solving.name }} {{ solving.amount == '' ? '': 'จำนวน '+solving.amount+' '+solving.unit.unit_th}}<br /></span
        ></template>

        <template #cell(cycle)="row"> {{ row.value == '' ? '-': row.value+' วันครั้ง' }}</template>
        <template #cell(phase)="row"> {{ row.value == '' ? '-': row.value+' ครั้ง' }}</template>

        <template #cell(actions)="row">
          <b-button
            @click="Edit(row.item, row.item.problems_id, $event.target)"
            class="btn btn-warning btn-sm ml-1 mt-1 actions"
            style="height: 35px;"
            v-b-popover.hover.top="'แก้ไข : ' + row.item.problems_name"
          >
            <i class="material-icons">
              edit
            </i>
          </b-button>
          <b-button
            @click="Delete(row.item.problems_id)"
            class="btn btn-danger btn-sm ml-1 mt-1 actions"
            style="height: 35px;"
            v-b-popover.hover.top="'ลบ : ' + row.item.problems_name"
          >
            <i class="material-icons">
              delete_forever
            </i>
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
      <Edit :editModal="editModal" :Problems="Problems" :sizes="sizes"/>
      <Add :Problems="Problems" :sizes="sizes"/>
    </b-container>
  </div>
</template>

<script>
import axios from "axios";
import swal from "sweetalert";
import Edit from './Edit';
import Add from "./Add";
import { Validator } from "vee-validate";
const dictionary = {
  th: {
    attributes: {
      problems_name: "รายการปัญหา",
      solving: "แก้ปัญหา",
    },
  },
};

Validator.localize(dictionary);

export default {
  components: { Add ,Edit},
  metaInfo: {
    title: "Problems",
  },
  data() {
    return {
      items: [],
      isBusy: true,
      fields: [
        {
          key: "problems_id",
          label: "ลำดับ",
          sortable: true,
          sortDirection: "desc",
        },
        {
          key: "problems_name",
          label: "รายการปัญหา",
          sortable: true,
          class: "text-center",
        },
        {
          key: "solving",
          label: "แก้ปัญหา",
          sortable: true,
          class: "text-center",
        },
        {
          key: "cycle",
          label: "รอบการใส่",
          sortable: true,
          class: "text-center",
        },
        {
          key: "phase",
          label: "ระยะการใส่",
          sortable: true,
          class: "text-center",
        },
        { key: "actions", label: "การดำเนินการ" },
      ],
      totalRows: 1,
      currentPage: 1,
      perPage: 5,
      pageOptions: [5, 10, 15, { value: 100, text: "100" }],
      filter: "",
      filterOn: [],
      sizes: [],
      editModal: {
        id: "edit-modalp",
        title: "",
        content: "",
      },
    };
  },
  async mounted() {
    this.Problems();
  },

  methods: {
    Edit(item, index, button) {
      this.editModal.title = `แก้ไข : ${index}`;
      this.editModal.content = item;
      this.$root.$emit("bv::show::modal", this.editModal.id, button);
    },

    async Problems() {
      this.sizes = [];
      this.$toasts.warning("กำลังโหลดข้อมูลกรุณารอสักครู่");
      const accessToken = localStorage.getItem("accessToken");
      if (await accessToken) {
        try {
          var response = await axios.get(this.$apiUrl + "problems", {
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

        response.data.forEach((element) => {
          element.solving.forEach((element2) => {
            if (!
              this.sizes.find((data) => {
                return element2 == data;
              })
            ) {
              this.sizes.push(element2);
            }
          });
        });
        
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
        buttons: true,
        dangerMode: true,
      }).then(async (willDelete) => {
        if (willDelete) {
          await axios.delete(this.$apiUrl + "problems/" + id, {
            headers: { Authorization: `bearer ${accessToken}` },
          });
          this.Problems();
          swal("ลบเสร็จสิ้น!", {
            icon: "success",
          });
        } else {
          swal("ยกเลิกแล้ว!");
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
