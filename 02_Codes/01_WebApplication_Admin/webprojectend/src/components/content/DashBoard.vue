<template>
  <div>
    <div class="row justify-content-md-center" >
      <div class="col-md-5 col-xl-3" style="min-width: 300px;">
        <div class="card bg-c-blue order-card">
          <div class="card-block">
            <h4 class="m-b-20 text-center">ผักปัจจุบัน</h4>
            <h2 class="text-right">
              <i class="fas fa-seedling f-left" style="font-size: 60px;"></i
              ><span>{{items.current_vegetables}}</span>
            </h2>
            <p class="m-b-0 text-center">เสร็จไปแล้ว<span class="f-right">{{items.current_vegetables_finish}}</span></p>
          </div>
        </div>
      </div>

      <div class="col-md-5 col-xl-3" style="min-width: 300px;">
        <div class="card bg-c-green order-card">
          <div class="card-block">
            <h4 class="m-b-20 text-center">พื้นที่ปลูก</h4>
            <h2 class="text-right">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="60"
                height="60"
                fill="currentColor"
                class="bi bi-bounding-box f-left"
                viewBox="0 0 16 16"
              >
                <path
                  d="M5 2V0H0v5h2v6H0v5h5v-2h6v2h5v-5h-2V5h2V0h-5v2H5zm6 1v2h2v6h-2v2H5v-2H3V5h2V3h6zm1-2h3v3h-3V1zm3 11v3h-3v-3h3zM4 15H1v-3h3v3zM1 4V1h3v3H1z"
                /></svg
              ><span>{{items.area}}</span>
            </h2>
            <p class="m-b-0 text-center">พื้นที่คงเหลือ<span class="f-right">{{items.area_balance}}</span></p>
          </div>
        </div>
      </div>

      <div class="col-md-5 col-xl-3" style="min-width: 300px;">
        <div class="card bg-c-yellow order-card">
          <div class="card-block">
            <h4 class="m-b-20 text-center">คำสั่งซื้อ</h4>
            <h2 class="text-right">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="60"
                height="60"
                fill="currentColor"
                class="bi bi-shop f-left"
                viewBox="0 0 16 16"
              >
                <path
                  d="M2.97 1.35A1 1 0 0 1 3.73 1h8.54a1 1 0 0 1 .76.35l2.609 3.044A1.5 1.5 0 0 1 16 5.37v.255a2.375 2.375 0 0 1-4.25 1.458A2.371 2.371 0 0 1 9.875 8 2.37 2.37 0 0 1 8 7.083 2.37 2.37 0 0 1 6.125 8a2.37 2.37 0 0 1-1.875-.917A2.375 2.375 0 0 1 0 5.625V5.37a1.5 1.5 0 0 1 .361-.976l2.61-3.045zm1.78 4.275a1.375 1.375 0 0 0 2.75 0 .5.5 0 0 1 1 0 1.375 1.375 0 0 0 2.75 0 .5.5 0 0 1 1 0 1.375 1.375 0 1 0 2.75 0V5.37a.5.5 0 0 0-.12-.325L12.27 2H3.73L1.12 5.045A.5.5 0 0 0 1 5.37v.255a1.375 1.375 0 0 0 2.75 0 .5.5 0 0 1 1 0zM1.5 8.5A.5.5 0 0 1 2 9v6h1v-5a1 1 0 0 1 1-1h3a1 1 0 0 1 1 1v5h6V9a.5.5 0 0 1 1 0v6h.5a.5.5 0 0 1 0 1H.5a.5.5 0 0 1 0-1H1V9a.5.5 0 0 1 .5-.5zM4 15h3v-5H4v5zm5-5a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1v3a1 1 0 0 1-1 1h-2a1 1 0 0 1-1-1v-3zm3 0h-2v3h2v-3z"
                /></svg
              ><span>{{items.order}}</span>
            </h2>
            <p class="m-b-0 text-center">
              คำสั่งซื้อที่เสร็จสิ้น<span class="f-right">{{items.order_finish}}</span>
            </p>
          </div>
        </div>
      </div>

      <div class="col-md-5 col-xl-3" style="min-width: 300px;">
        <div class="card bg-c-pink order-card">
          <div class="card-block">
            <h4 class="m-b-20 text-center">การสูญเสีย</h4>
            <h2 class="text-right">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="60"
                height="60"
                fill="currentColor"
                class="bi bi-exclamation-diamond-fill f-left"
                viewBox="0 0 16 16"
              >
                <path
                  d="M9.05.435c-.58-.58-1.52-.58-2.1 0L.436 6.95c-.58.58-.58 1.519 0 2.098l6.516 6.516c.58.58 1.519.58 2.098 0l6.516-6.516c.58-.58.58-1.519 0-2.098L9.05.435zM8 4c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995A.905.905 0 0 1 8 4zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"
                /></svg
              ><span>{{items.loss}}</span>
            </h2>
            <p class="m-b-0 text-center">
              การสูญเสียทั้งหมด<span class="f-right">{{items.loss_all}}</span>
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
export default {
  name: "DashBoard",
  metaInfo: {
    title: "DashBoard",
  },
  components: {},
  data() {
    return {
      items:Object
    };
  },

  mounted(){
    this.DashBoard();
  },

  methods: {
    async DashBoard() {
      this.$toasts.warning("กำลังโหลดข้อมูลกรุณารอสักครู่");
      const accessToken = localStorage.getItem("accessToken");
      if (await accessToken) {
        try {
          const response = await axios.get(this.$apiUrl + "dashboard", {
            headers: { Authorization: `bearer ${accessToken}` },
          });
          this.items = response.data;
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
  }
};
</script>

<style scoped>
@media (max-width: 768px) {
  i,
  svg {
    margin-top: 10px;
  }
}

body {
  margin-top: 20px;
  background: #fafafa;
}
.order-card {
  color: #fff;
}

.bg-c-blue {
  background: linear-gradient(45deg, #4099ff, #73b4ff);
}

.bg-c-green {
  background: linear-gradient(45deg, #2ed8b6, #59e0c5);
}

.bg-c-yellow {
  background: linear-gradient(45deg, #ffb64d, #ffcb80);
}

.bg-c-pink {
  background: linear-gradient(45deg, #ff5370, #ff869a);
}

.card {
  border-radius: 5px;
  -webkit-box-shadow: 0 1px 2.94px 0.06px rgba(4, 26, 55, 0.16);
  box-shadow: 0 1px 2.94px 0.06px rgba(4, 26, 55, 0.16);
  border: none;
  margin-bottom: 30px;
  -webkit-transition: all 0.3s ease-in-out;
  transition: all 0.3s ease-in-out;
}

.card .card-block {
  padding: 15px;
}

.f-left {
  float: left;
}

.f-right {
  float: right;
}
</style>
