<template>
  <div class="container">
    <div class="row mt-3">
      <div class="col text-center">
        <h3>วิสาหกิจหม่อนผลแปรรูปกลุ่มใต้ร่มบุญ</h3>
        <h5>รหัสทะเบียน : 5-90-11-18/1-0012</h5>
        <h6>เลขที่ 124/1 หมู่ที่ 6 ถนน ตำบลพะตง อำเภอหาดใหญ่ จังหวัดสงขลา</h6>
      </div>
    </div>

    <!-- <div class="row">
      <div class="col  mt-3">
        <h5 class="float-left mb-2">ผังฟาร์ม</h5>
        <div class="w-25">
          
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col  mt-3">
        <h5 class="float-left mb-2">พิกัดแปลง</h5>
        <div class="w-25">
          
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col  mt-3">
        <h5 class="float-left mb-2">ผังฟาร์ม</h5>
        <div class="w-25">
          
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col  mt-3">
        <h5 class="float-left mb-2">ที่มาแหล่งน้ำ</h5>
        <div class="w-25">
          
        </div>
      </div>
    </div> -->

    <div class="row">
      <div class="col  mt-3">
        <h5 class="float-left mb-2">รายชื่อผัก</h5>
        <div class="w-25">
          <table class="table ">
            <!-- <thead class="thead-light">
              <tr>
                <th scope="col" >ลำดับที่</th>
                <th scope="col" >รายชื่อ</th>
              </tr>
            </thead> -->
            <tbody>
              <tr v-for="(vegetable, index) in data.vegetable" :key="index">
                <th scope="row" class="text-center">{{ vegetable.id }}</th>
                <td >{{ vegetable.v_name }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col mt-3">
        <h5 class="float-left mb-2">รายการปลูก</h5>
        <div>
          <table class="table ">
            <thead>
              <tr>
                <th scope="col" class="text-center">ที่</th>
                <th scope="col">หมายเลขการปลูก</th>
                <th scope="col">เริ่มเพาะ</th>
                <th scope="col">ย้ายลงถาดหลุม</th>
                <th scope="col">เก็บผลผลิต</th>
                <th scope="col">ชื่อผักและจำนวน</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(production, index) in data.production" :key="index">
                <th scope="row" class="text-center">{{ production.id }}</th>
                <td>{{ production.pd_id }}</td>
                <td>{{ production.pd_d1 }}</td>
                <td>{{ production.pd_d2 }}</td>
                <td>{{ production.pd_d3 }}</td>
                <td>
                  {{ production.v_name }} จำนวน {{ production.number }} ต้น
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col mt-2">
        <h5 class="float-left">ประวัติการใช้ปุ๋ย</h5>
        <div>
          <table class="table ">
            <thead>
              <tr>
                <th scope="col" class="text-center">ที่</th>
                <th scope="col">วันที่</th>
                <th scope="col">หมายเลขการปลูก</th>
                <th scope="col">ชื่อปุ๋ย</th>
                <th scope="col">จำนวน</th>
                <th scope="col">พื้นที่</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(take, index) in data.take" :key="index">
                <th scope="row" class="text-center">{{ index+1 }}</th>
                <td>{{ take.take_date}}</td>
                <td> {{ take.pd_id }}</td>
                <td> {{take.fertilizer.fertilizer_type}}</td>
                <td> {{take.fertilizer.take_volume}} {{take.fertilizer.unit.unit_eng}} ({{take.fertilizer.unit.unit_th}})</td>
                <td>
                  <label v-for="(area, i) in take.area" :key="i">{{
                    i + 1 > take.area.length - 1 ? area : area + ","
                  }}</label>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col  mt-3">
        <h5 class="float-left mb-2">ยารักษาโรคพืช</h5>
        <div class="">

          <table class="table ">
            <thead>
              <tr>
                <th scope="col" class="text-center">ที่</th>
                <th scope="col">วันที่</th>
                <th scope="col">หมายเลขการปลูก</th>
                <th scope="col">ปัญหา</th>
                <th scope="col">การแก้ไข</th>
                <th scope="col">พื้นที่</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(keep_problem, index) in data.keep_problem" :key="index">
                <th scope="row" class="text-center">{{ index+1 }}</th>
                <td>{{ keep_problem.date}}</td>
                <td> {{ keep_problem.pd_id }}</td>
                <td> {{keep_problem.problems_data}}</td>
                <td> {{keep_problem.solving_data}}</td>
                <td> {{keep_problem.area}}</td>
              </tr>
            </tbody>
          </table>

        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  data() {
    return {
      data: Object,
    };
  },

  async mounted() {
    const accessToken = localStorage.getItem("accessToken");
    if (await accessToken) {
      try {
        const response = await axios.get(this.$apiUrl + "PGS", {
          headers: { Authorization: `bearer ${accessToken}` },
        });

        this.data = response.data;
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

  methods: {

  },
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Sarabun:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800&display=swap");

body {
  font-family: "Sarabun", sans-serif;
}
</style>
