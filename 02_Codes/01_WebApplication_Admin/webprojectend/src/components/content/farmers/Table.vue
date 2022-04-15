<template>
  <div>
    <b-container fluid>
      <b-row align-h="between">
        <b-col
          sm="9"
          md="6"
          lg="5"
          xl="4"
          class="my-1"
        >
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
                <b-button
                  :disabled="!filter"
                  @click="filter = ''"
                >ล้างการค้นหา</b-button>
              </b-input-group-append>
            </b-input-group>
          </b-form-group>
        </b-col>
        <b-col
          sm="7"
          md="5"
          lg="4"
          xl="4"
          class="my-1 text-right"
        >
          <b-button
            v-b-modal.AddFarmers
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
        :borderless="false"
        stacked="sm"
        empty-text="ไม่มีข้อมูล"
        empty-filtered-text="ไม่มีข้อมูล"
        show-empty
        class="table"
      >
        <template #table-busy>
          <div class="text-center text-danger my-2">
            <b-spinner class="align-middle"></b-spinner>
            <strong> กำลังโหลด...</strong>
          </div>
        </template>

        <template #cell(name)="row">
          {{
            row.item.fm_name === "" && row.item.fm_lname === ""
              ? "-"
              : row.item.fm_name
          }}
          {{ row.item.fm_lname === "" ? "" : row.item.fm_lname }}</template>
        <template #cell(fm_address)="row">
          {{ row.item.fm_address === "" ? "-" : row.item.fm_address }}</template>
        <template #cell(fm_phnum)="row">
          {{ row.item.fm_phnum === "" ? "-" : row.item.fm_phnum }}</template>
        <template #cell(position)="row">
          {{ row.item.position === "" ? "-" : row.item.position }}</template>
          <template #cell(photo)="row"><img :src="row.value" style="width: auto; height: 100px;"></template>

        <template #cell(actions)="row">
          <b-button
            @click="Edit(row.item, row.item.username, $event.target)"
            class="btn btn-warning btn-sm ml-1 mt-1 actions"
            style="height: 35px;"
            v-b-popover.hover.top="'แก้ไข : ' + row.item.username"
          >
            <i class="material-icons">
              edit
            </i>
          </b-button>
          <b-button
            @click="Reset(row.item.username)"
            class="btn btn-secondary btn-sm ml-1 mt-1 actions"
            style="height: 35px;"
            v-b-popover.hover.top="
              'รีเซ็ตรหัสผ่านผู้ใช้ : ' + row.item.username
            "
          >
            <i class="material-icons">
              autorenew
            </i>
          </b-button>
          <b-button
            @click="Delete(row.item.username)"
            class="btn btn-danger btn-sm ml-1 mt-1 actions"
            style="height: 35px;"
            v-b-popover.hover.top="'ลบผู้ใช้ : ' + row.item.username"
          >
            <i class="material-icons">
              delete_forever
            </i>
          </b-button>
        </template>
      </b-table>

      <!-- User Interface controls -->
      <b-row align-h="between">
        <b-col
          sm="6"
          md="6"
          lg="5"
          xl="4"
          class="my-1"
        >
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
        <b-col
          sm="6"
          md="6"
          class="my-1"
        >
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
      <Edit :editModal="editModal" v-bind:Farmers="Farmers" />
      <Add v-bind:Farmers="Farmers" />
    </b-container>
  </div>
</template>

<script>
import axios from "axios";
import swal from "sweetalert";
import Add from "./Add.vue";
import Edit from "./Edit.vue";
import { Validator } from 'vee-validate';
const dictionary = {
  th: {
    attributes: {
      username: 'ชื่อผู้ใช้',
    }
  },
};

Validator.localize(dictionary);

export default {
  components: { Add ,Edit},
  metaInfo: {
    title: "Farmers",
  },
  data() {
    return {
      items: [],
      isBusy: true,
      fields: [
        {
          key: "id",
          label: "ลำดับ",
          sortable: true,
          sortDirection: "desc",
        },
        {
          key: "photo",
          label: "รูปภาพ",
          sortable: true,
          class: "text-center",
        },
        {
          key: "username",
          label: "ชื่อผู้ใช้",
          sortable: true,
          class: "text-center",
        },
        {
          key: "name",
          label: "ชื่อ",
          sortable: true,
          class: "text-center",
        },
        {
          key: "fm_address",
          label: "ที่อยู่",
          sortable: true,
          class: "text-center",
        },
        {
          key: "fm_phnum",
          label: "เบอร์โทรศัพท์",
          sortable: true,
          class: "text-center",
        },
        {
          key: "position",
          label: "ตำแหน่ง",
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
    this.Farmers();
  },

  methods: {
    Edit(item, index, button) {
      this.editModal.title = `แก้ไข : ${index}`;
      this.editModal.content = item;
      this.$root.$emit("bv::show::modal", this.editModal.id, button);
    },

    async Farmers() {
      this.$toasts.warning("กำลังโหลดข้อมูลกรุณารอสักครู่");
      const accessToken = localStorage.getItem("accessToken");
      if (await accessToken) {
        try {
          const response = await axios.get(this.$apiUrl + "farmers", {
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
          await axios.delete(this.$apiUrl + "farmers/" + id, {
            headers: { Authorization: `bearer ${accessToken}` },
          });
          this.Farmers();
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

    async Reset(id) {
      const accessToken = await localStorage.getItem("accessToken");
      swal({
        title: "คุณแน่ใจหรือไม่?",
        text: "คุณแน่ใจหรือไม่ที่จะรีเซ็ตรหัสผ่าน : " + id,
        icon: "warning",
        buttons: ["ยกเลิก", "ตกลง"],
        dangerMode: true,
      }).then(async (willReset) => {
        if (willReset) {
          await axios.put(this.$apiUrl + "resetpass/" + id, {
            headers: { Authorization: `bearer ${accessToken}` },
          });
          this.Farmers();
          swal("รีเซ็ตเสร็จสิ้น!", {
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
