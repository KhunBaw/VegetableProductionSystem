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
            v-b-modal.AddFertilizer
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

        <template #cell(fertilizer_id)="row"> {{ row.item.id }} </template>
        <template #cell(fertilizer_type)="row">
          {{
            row.value != "" ? row.value : row.item.fertilizer.fertilizer_type
          }}</template
        >
        <template #cell(fertilizer_at)="row">
          <span v-for="time in row.value" :key="time.time"
            >{{ time.time }} น. จำนวน {{ time.fertilizer_amount }}
            {{ time.unit.unit_th }}<br
          /></span>
        </template>
        <template #cell(day_times)="row">
          {{
            row.value != 0 ? row.value : row.item.fertilizer.day_times
          }}
          วัน</template
        >
        <template #cell(num_first)="row">
          {{
            row.value != 0 ? row.value : row.item.fertilizer.num_first
          }}
          วัน</template
        >
        <template #cell(num_pick)="row">
          {{
            row.value != 0 ? row.value : row.item.fertilizer.num_pick
          }}
          วัน</template
        >

        <template #cell(actions)="row">
          <b-button
            @click="Edit(row.index, $event.target, row.item)"
            class="btn btn-warning btn-sm ml-1 mt-1 actions"
            style="height: 35px;"
            v-b-popover.hover.top="'แก้ไขพื้นที่ : '"
          >
            <i class="material-icons">
              edit
            </i>
          </b-button>
          <b-button
            @click="Delete(row.index)"
            class="btn btn-danger btn-sm ml-1 mt-1 actions"
            style="height: 35px;"
            v-b-popover.hover.top="'ลบพื้นที่ : '"
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
      <Edit :editModal="editModal" :items="items" />
      <Add :id="v_id" v-bind:Vegetable="Vegetable" />
    </b-container>
  </div>
</template>

<script>
import axios from "axios";
import swal from "sweetalert";
import Edit from "./Edit.vue";
import Add from "./Add.vue";
import { Validator } from "vee-validate";
const dictionary = {
  th: {
    attributes: {
      fertilizer_type: "ชนิดปุ๋ย",
      fertilizer_at: "เวลาและปริมาณปุ๋ย",
      day_times: "จำนวนวัน/ครั้ง",
      num_first: "จำนวนวันก่อนใส่ปุ๋ยครั้งแรก",
      num_pick: "จำนวนวันหยุดใส่ปุ๋ยก่อนเก็บ",
      unit_id: "หน่วย",
      fertilizer_amount: "ปริมาณปุ๋ย",
      time: "เวลา",
    },
  },
};

Validator.localize(dictionary);

export default {
  components: { Edit, Add },
  props: {
    items: Array,
    v_id: String,
    Vegetable: Function,
  },
  metaInfo: {
    title: "Fertilizer",
  },
  data() {
    return {
      isBusy: false,
      fields: [
        {
          key: "fertilizer_id",
          label: "ลำดับ",
          sortable: true,
          sortDirection: "desc",
        },
        {
          key: "fertilizer_type",
          label: "ชนิดปุ๋ย",
          sortable: true,
          class: "text-center",
        },
        {
          key: "fertilizer_at",
          label: "เวลาและปริมาณปุ๋ย",
          sortable: true,
          class: "text-center",
        },
        {
          key: "day_times",
          label: "จำนวนวัน/ครั้ง",
          sortable: true,
          class: "text-center",
        },
        {
          key: "num_first",
          label: "จำนวนวันก่อนใส่ปุ๋ยครั้งแรก",
          sortable: true,
          class: "text-center",
        },
        {
          key: "num_pick",
          label: "จำนวนวันหยุดใส่ปุ๋ยก่อนเก็บ",
          sortable: true,
          class: "text-center",

          sortByFormatted: true,
          filterByFormatted: true,
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
        id: "indexf",
        v_id: "",
        title: "",
        content: "",
      },
    };
  },
  async mounted() {
    this.editModal.content = this.items[0];
  },

  methods: {
    Edit(index, button, content) {
      this.editModal.v_id = this.v_id;
      this.editModal.title = `แก้ไข : ${index + 1}`;
      this.editModal.content = content;
      this.editModal.content.fertilizer_type = content.fertilizer.fertilizer_type;
      this.$root.$emit("bv::show::modal", this.editModal.id, button);
    },

    async Delete(id) {
      const accessToken = await localStorage.getItem("accessToken");
      swal({
        title: "คุณแน่ใจหรือไม่?",
        text: "คุณแน่ใจหรือไม่ที่จะลบไอดี : " + (id+1),
        icon: "warning",
        buttons: ["ยกเลิก", "ตกลง"],
        dangerMode: true,
      }).then(async (willDelete) => {
        if (willDelete) {
          await axios.put(
            this.$apiUrl + "vegetable/vfertilizer/" + id,
            { v_id: this.v_id },
            {
              headers: { Authorization: `bearer ${accessToken}` },
            }
          ).then(()=>{

            this.Vegetable();
          swal("ลบเสร็จสิ้น!", {
            icon: "success",
            button: "ตกลง",
          });

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
