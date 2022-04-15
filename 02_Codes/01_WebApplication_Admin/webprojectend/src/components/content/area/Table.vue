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
            v-b-modal.AddArea
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
            <strong> กำลังโหลด...</strong>
          </div>
        </template>
        <template #cell(area_id)="row"> {{ row.item.id }}</template>
        <template #cell(area_long)="row"> {{ row.value }} ซม. </template>
        <template #cell(area_wide)="row"> {{ row.value }} ซม. </template>
        <template #cell(area_rest_period)="row"> {{ row.value }} วัน </template>
        <template #cell(area_lv)="row"> {{ row.value == '' ? '-' : row.value}}</template>
        <template #cell(area_detail)="row"> {{ row.value == '' ? '-' : row.value}}</template>
        <template #cell(area_photo)="row"><img :src="row.value" style="width: auto; height: 100px;"></template>
        <template #cell(actions)="row">
          <b-button
            @click="Edit(row.item, row.item.area_name, $event.target)"
            :disabled=row.item.status
            class="btn btn-warning btn-sm ml-1 mt-1 actions"
            style="height: 35px;"
            v-b-popover.hover.top="'แก้ไขพื้นที่ : ' + row.item.area_name"
          >
            <i class="material-icons">
              edit
            </i>
          </b-button>
          <b-button
            @click="Delete(row.item.area_id, row.item.area_name)"
            :disabled=row.item.status
            class="btn btn-danger btn-sm ml-1 mt-1 actions"
            style="height: 35px;"
            v-b-popover.hover.top="'ลบพื้นที่ : ' + row.item.area_name"
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
      <Edit :editModal="editModal" v-bind:Area="Area" />
      <Add v-bind:Area="Area" />
    </b-container>
  </div>
</template>

<script>
import axios from "axios";
import swal from "sweetalert";
import Edit from './Edit';
import Add from './Add';
import { Validator } from 'vee-validate';
const dictionary = {
  th: {
    attributes: {
      area_name: 'ชื่อแปลงผัก',
      area_long: 'ความยาว',
      area_wide: 'ความกว้าง',
      area_detail : 'รายละเอียด',
      area_rest_period : 'พักพื้นที่',
    }
  },
};

Validator.localize(dictionary);


export default {
  components: { Edit, Add },
  metaInfo: {
    title: "Area",
  },
  data() {
    return {
      items: [],
      isBusy: true,
      fields: [
        {
          key: "area_id",
          label: "ลำดับ",
          sortable: true,
          sortDirection: "desc",
        },
        {
          key: "area_photo",
          label: "รูปภาพ",
          sortable: true,
          class: "text-center",
        },
        {
          key: "area_name",
          label: "ชื่อแปลงผัก",
          sortable: true,
          class: "text-center",
        },
        {
          key: "area_long",
          label: "ความยาว",
          sortable: true,
          class: "text-center",
        },
        {
          key: "area_wide",
          label: "ความกว้าง",
          sortable: true,
          class: "text-center",
        },
        {
          key: "area_rest_period",
          label: "พักแปลงผัก",
          sortable: true,
          class: "text-center",
        },
        {
          key: "area_lv",
          label: "ผักล่าสุด",
          sortable: true,
          class: "text-center",
        },
        {
          key: "area_detail",
          label: "รายละเอียด",
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
    this.Area();
  },

  methods: {
    Edit(item, index, button) {
      this.editModal.title = `แก้ไข : ${index}`;
      this.editModal.content = item;
      this.$root.$emit("bv::show::modal", this.editModal.id, button);
    },

    async Area() {
      this.$toasts.warning('กำลังโหลดข้อมูลกรุณารอสักครู่')
      const accessToken = localStorage.getItem("accessToken");
      if (await accessToken) {
        try {
          const response = await axios.get(this.$apiUrl + "area", {
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

    async Photo(name){
      const accessToken = localStorage.getItem("accessToken");
      if (await accessToken) {
        try {
          const response = await axios.get(this.$apiUrl + "img/"+name, {
            headers: { Authorization: `bearer ${accessToken}` },
          });
          console.log(response.config.url);
          return response.config.url;

        } catch {
          alert('1')
          // this.$router.push("/");
          // localStorage.removeItem("username");
          // this.Loading.isloaded = true;
        }
      } else {
        alert('2')
        // this.$router.push("/");
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
          await axios.delete(this.$apiUrl + "area/" + id, {
            headers: { Authorization: `bearer ${accessToken}` },
          });
          this.Area();
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
