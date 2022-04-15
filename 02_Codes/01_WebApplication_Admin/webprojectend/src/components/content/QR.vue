<template>
  <div id="appB">
    <!-- <div>ID {{ id }}</div> -->
    <div class="container text-center">
      <img src="../.././assets/img/1.png" class="rounded" />
    </div>
    <div class="container">
      <div id="nav1">
        <div class="row justify-content-md-center">
          <div class="col-4">
            <a href="#2">
              <img src="../.././assets/img/2.png" class="rounded float-right" />
            </a>
          </div>
          <div class="col-4">
            <a href="#3">
              <img src="../.././assets/img/3.png" />
            </a>
          </div>
          <div class="col-4">
            <a href="#4">
              <img src="../.././assets/img/4.png" class="rounded float-left" />
            </a>
          </div>
        </div>
      </div>
    </div>

    <div class="container">
      <div id="nav2">
        <div class="row justify-content-md-center">
          <div class="col-4 text-right">ประโยชน์</div>
          <div class="col-4">กระบวนการผลิต</div>
          <div class="col-4 text-left">สถานที่ผลิต</div>
        </div>
      </div>
    </div>

    <div class="container" id="3">
      <div id="nav3">
        <div class="row justify-content-md-center">
          <div class="col-sm">
            <img src="../.././assets/img/3.png" class="rounded" />
          </div>
        </div>
      </div>
    </div>

    <div class="container">
      <div id="nav4">
        <!-- <div class="row justify-content-md-center">
          <div class="col-sm">
            <img
              src="https://raw.githubusercontent.com/DuangruthaiAnuto/Pic/main/5.png"
              class="rounded float-right"
            />
          </div>
          <div class="col-sm text-left">
            {{ data[0].state }}<br />{{ data[0].date1 }}
          </div>
        </div>

        <div class="row justify-content-md-center">
          <div class="col-sm">
            <img src="https://raw.githubusercontent.com/DuangruthaiAnuto/Pic/main/5.png" class="rounded float-right" />
          </div>
          <div class="col-sm text-left">
            {{ data[0].state2 }}<br />{{ data[0].date2 }}
          </div>
        </div>


        <div class="row justify-content-md-center">
          <div class="col-sm">
            <img src="https://raw.githubusercontent.com/DuangruthaiAnuto/Pic/main/5.png" class="rounded float-right" />
          </div>
          <div class="col-sm text-left">
            {{ data[0].state3 }}<br />{{ data[0].date3 }}
          </div>
        </div> -->

        <div class="">
          <ul class="timeline">
            <li class="timeline-blocks">
              <figure class="timeline-icon">
                <img
                  :src="
                    data[0].photo1 == ''
                      ? 'https://raw.githubusercontent.com/DuangruthaiAnuto/Pic/main/5.png'
                      : data[0].photo1
                  "
                  alt="timeline"
                />
              </figure>
              <div class="dir-r radius-3">
                <h1>{{ data[0].state }}</h1>
              </div>
              <div class="date-l">{{ data[0].date1 }}</div>
            </li>

            <li class="timeline-blocks">
              <figure class="timeline-icon">
                <img
                  :src="
                    data[0].photo2 == ''
                      ? 'https://raw.githubusercontent.com/DuangruthaiAnuto/Pic/main/5.png'
                      : data[0].photo2
                  "
                  alt="timeline"
                />
              </figure>
              <div class="dir-l radius-3">
                <h1>{{ data[0].state2 }}</h1>
              </div>
              <div class="date-r">{{ data[0].date2 }}</div>
            </li>

            <div v-for="(data, index) in data[0].take" :key="index">
              <li class="timeline-blocksB" v-if="index % 2 == 0">
                <figure class="timeline-iconB">
                  <img
                    src="https://raw.githubusercontent.com/DuangruthaiAnuto/Pic/main/5.png"
                    alt="timelineB"
                  />
                </figure>
                <div class="dir-r radius-3">
                  <h6>{{ data.fertilizer_name }}</h6>
                </div>
              </li>

              <li class="timeline-blocksB" v-if="index % 2 != 0">
                <figure class="timeline-iconB">
                  <img
                    src="https://raw.githubusercontent.com/DuangruthaiAnuto/Pic/main/5.png"
                    alt="timelineB"
                  />
                </figure>
                <div class="dir-l radius-3">
                  <h6>{{ data.fertilizer_name }}</h6>
                </div>
              </li>
            </div>

            <li class="timeline-blocks">
              <figure class="timeline-icon">
                <img
                  :src="
                    data[0].photo3 == ''
                      ? 'https://raw.githubusercontent.com/DuangruthaiAnuto/Pic/main/5.png'
                      : data[0].photo3
                  "
                  alt="course"
                />
              </figure>
              <div class="dir-r radius-3">
                <h1>{{ data[0].state3 }}</h1>
              </div>
              <div class="date-l">{{ data[0].date3 }}</div>
            </li>
          </ul>
        </div>
      </div>
    </div>

    <div class="container" id="2">
      <div id="nav3">
        <div class="row justify-content-md-center">
          <div class="col-sm">
            <img src="../.././assets/img/2.png" class="rounded" />
          </div>
        </div>
      </div>
    </div>

    <div class="container">
      <div id="nav5">
        <div class="row justify-content-md-center">
          <div class="col-sm">
            <img src="../.././assets/img/6.png" class="rounded" />
          </div>
        </div>
      </div>
    </div>

    <div class="container" id="4">
      <div id="nav3">
        <div class="row justify-content-md-center">
          <div class="col-sm">
            <img src="../.././assets/img/4.png" class="rounded" />
          </div>
        </div>
      </div>
    </div>
    <div class="container">
      <div class="video-responsive">
        <iframe
          width="910"
          height="510"
          src="https://www.youtube.com/embed/-KKwaxm_OR4"
          frameborder="0"
          allowfullscreen
        ></iframe>
      </div>
    </div>
    <div class="container">
      <div class="video-responsive">
        <iframe
          width="910"
          height="510"
          src="https://cutt.ly/eQvRxHb"
          frameborder="0"
          allowfullscreen
        ></iframe>
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
      errored: false,
      id: this.$route.params.id,
    };
  },

  async mounted() {
    //this.pd = await axios.get(this.$apiUrl + "QR");
    console.log(this.id);


    axios
      .get(this.$apiUrl + "QR/" + this.id)
      .then((response) => {
        this.data = response.data;
      })
      .catch((error) => {
        console.log(error);
        this.errored = true;
      });
  },

  methods: {},
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css2?family=Sarabun:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800&display=swap");

body {
  font-family: "Sarabun", sans-serif;
}

#appB {
  height: auto;
  background: #79d0f2;
}

.container {
  text-align: center;
}
.video-responsive {
  overflow: hidden;
  padding-bottom: 56.25%;
  position: relative;
  height: 0;
}
.video-responsive iframe {
  background-color: #fdfdfc;
  left: 0;
  top: 0;
  padding: 30px;
  height: 100%;
  width: 100%;
  position: absolute;
}

.heig {
  height: 100px;
}

#nav1 img {
  padding: 7px;
  margin-top: 10px;
  margin-bottom: 10px;
  width: 100px;
}
.text-center img {
  width: 100%;
}
#nav1 {
  background-color: #729d00;
}
#nav2 {
  background-color: #fdfdfc;
  padding-bottom: 0px;
  color: #729d00;
}
#nav3 {
  background-color: #ededed;
  height: 120px;
}

#nav10 {
  background-color: #fdfdfc;
  padding: 90px;
  display: flex;
}
#nav3 img {
  height: 120px;
  padding: 10px;
}

#nav4,
#nav {
  background-color: #fdfdfc;
  padding-top: 30px;
  padding-bottom: 30px;
}
#test {
  padding: 5px;
  width: 50px;
}
#nav5 {
  background-color: #fdfdfc;
  padding: 30px;
}
#nav5 img {
  width: 100%;
}

#nav4 {
  color: #7f8c97;
  max-width: 1224px;
  height: 100%;
  text-align: center;
  margin: 0 auto;
  padding: 2em;
  position: relative;
}

.main-title {
  color: #4e4e4e;
  font-weight: 600;
  font-size: 4em;
  margin-bottom: 0.3em;
}

.timeline {
  position: relative;
  width: auto;
  margin: 0 auto;
  /* margin-top: 5em; */
  padding-bottom: 2em;
  padding-left: 0;
}

.timeline:before {
  position: absolute;
  left: 50%;
  top: 0;
  content: " ";
  display: block;
  width: 4px;
  height: 90%;
  margin-left: -3px;
  background: #d7e4ed;
  z-index: 5;
}

.dir-l,
.dir-r {
  position: relative;
  width: 38%;
  padding: 1.5em 1em;
  background: #e9ecef;
  box-shadow: 0 3px 0 #167ac6;
  margin-top: 0;
  margin-bottom: 1.5em;
}

.timeline h1 {
  font-size: 1.6em;
  color: #167ac6;
  width: 90%;
  margin-top: 8px;
}

.timeline h6 {
  font-size: 1.1em;
  color: #167ac6;
  width: 90%;
  margin-top: 8px;
}

/* .timeline p {
  letter-spacing: 0.5px;
  font-size: 1.1em;
  line-height: 1.5em;
  margin: 0.5em;
  margin-top: 1.5em;
} */

.timeline img {
  border-radius: 50%;
}

.timeline-icon {
  position: absolute;
  border-radius: 50%;
  z-index: 10;
  top: 5px;
  margin-left: -75px;
  box-shadow: 0 0 0 4px white, inset 0 2px 0 rgba(0, 0, 0, 0),
    0 0 0 5px rgba(0, 0, 0, 0.15);
}

.timeline-iconB {
  position: absolute;
  top: 1em;
  right: 0;
  border-radius: 50%;
  z-index: 10;
}

.timeline a {
  color: #38666a;
  margin-left: 0.4em;
}

.dir-l {
  float: left;
}

.dir-l:before {
  content: "";
  display: inline-block;
  vertical-align: middle;
  width: 0;
  height: 0;
  position: absolute;
  right: -0.95em;
  top: 1em;
  border-top: 17px solid transparent;
  border-bottom: 17px solid transparent;
  border-left: 16px solid #e9ecef;
}

.dir-r {
  float: right;
}

.dir-r:before {
  content: "";
  display: inline-block;
  vertical-align: middle;
  width: 0;
  height: 0;
  position: absolute;
  left: -0.9em;
  top: 1em;
  border-top: 17px solid transparent;
  border-bottom: 17px solid transparent;
  border-right: 15px solid #e9ecef;
}

.timeline-blocks {
  display: block;
  height: 200px;
  padding: 1em 0;
  position: relative;
  overflow: hidden;
}

.timeline-blocksB {
  display: block;
  height: 100px;
  top: -20px;
  padding: 1em 0;
  position: relative;
  overflow: hidden;
}

.timeline img {
  border-radius: 50%;
  width: 100%;
  height: 100%;
}

.timelineB img {
  border-radius: 50%;
  width: 100%;
  height: 100%;
}

.timeline-iconB {
  position: absolute;
  top: 25px;
  width: 40px;
  height: 40px;
  left: 48.5%;
  margin-left: -5px;
  box-shadow: 0 0 0 4px white, inset 0 2px 0 rgba(0, 0, 0, 0),
    0 0 0 5px rgba(0, 0, 0, 0.15);
}

.timeline-blocks .date-l,
.timeline-blocks .date-r {
  position: absolute;
  top: 4em;
  right: 60%;
  font-size: 1em;
}

.timeline-blocks .date-r {
  left: 60%;
  right: auto;
}

/* Extra small devices (phones, 600px and down) */
@media only screen and (max-width: 600px) {
  .timeline-icon {
    width: 80px;
    height: 80px;
    left: 61%;
    margin-left: -75px;
  }

  .timeline-iconB {
    top: 25px;
    width: 30px;
    height: 30px;
    left: 46.5%;
    margin-left: -5px;
  }

  .timeline h1 {
    font-size: 1em;
  }

  .timeline h6 {
    font-size: 0.9em;
  }

  .timeline-blocks .date-l,
  .timeline-blocks .date-r {
    top: 40px;
    right: 70%;
    font-size: 0.9 em;
  }

  .timeline-blocks .date-r {
    left: 70%;
  }

  .timeline-blocks {
    height: 130px;
  }

  .timeline-blocksB {
    height: 100px;
  }

  .dir-l:before {
    border-top: 15px solid transparent;
    border-bottom: 15px solid transparent;
    border-left: 16px solid #e9ecef;
  }

  .dir-r:before {
    border-top: 15px solid transparent;
    border-bottom: 15px solid transparent;
    border-right: 15px solid #e9ecef;
  }

  .timeline:before {
    left: 50%;
    width: 4px;
    height: 86%;
  }

  .dir-l,
  .dir-r {
    width: 29%;
  }
}

/* Medium devices (landscape tablets, 600px and up) */
@media only screen and (min-width: 600px) {
  .timeline-icon {
    width: 80px;
    height: 80px;
    left: 58%;
    margin-left: -75px;
  }

  .timeline-iconB {
    top: 25px;
    width: 30px;
    height: 30px;
    left: 47%;
    margin-left: -5px;
  }

  .timeline h1 {
    font-size: 1em;
  }

  .timeline h6 {
    font-size: 0.9em;
  }

  .timeline-blocks .date-l,
  .timeline-blocks .date-r {
    top: 40px;
    right: 70%;
    font-size: 0.9 em;
  }

  .timeline-blocks .date-r {
    left: 70%;
  }

  .timeline-blocks {
    height: 130px;
  }

  .timeline-blocksB {
    height: 100px;
  }

  .dir-l:before {
    border-top: 15px solid transparent;
    border-bottom: 15px solid transparent;
    border-left: 16px solid #e9ecef;
  }

  .dir-r:before {
    border-top: 15px solid transparent;
    border-bottom: 15px solid transparent;
    border-right: 15px solid #e9ecef;
  }

  .timeline:before {
    left: 50%;
    width: 4px;
    height: 86%;
  }

  .dir-l,
  .dir-r {
    width: 34%;
  }
}

/* Medium devices (landscape tablets, 768px and up) */
@media only screen and (min-width: 768px) {
  .timeline-icon {
    width: 85px;
    height: 85px;
    left: 55%;
    margin-left: -75px;
  }

  .timeline-iconB {
    top: 25px;
    width: 35px;
    height: 35px;
    left: 48%;
    margin-left: -5px;
  }

  .timeline h1 {
    font-size: 1em;
  }

  .timeline h6 {
    font-size: 0.9em;
  }

  .timeline-blocks .date-l,
  .timeline-blocks .date-r {
    top: 40px;
    right: 70%;
    font-size: 0.9 em;
  }

  .timeline-blocks .date-r {
    left: 70%;
  }

  .timeline-blocks {
    height: 130px;
  }

  .timeline-blocksB {
    height: 100px;
  }

  .dir-l:before {
    border-top: 15px solid transparent;
    border-bottom: 15px solid transparent;
    border-left: 16px solid #e9ecef;
  }

  .dir-r:before {
    border-top: 15px solid transparent;
    border-bottom: 15px solid transparent;
    border-right: 15px solid #e9ecef;
  }

  .timeline:before {
    left: 50%;
    width: 4px;
    height: 86%;
  }

  .dir-l,
  .dir-r {
    width: 34%;
  }
}

/* Large devices (laptops/desktops, 992px and up) */
@media only screen and (min-width: 992px) {
  .timeline-icon {
    width: 90px;
    height: 90px;
    left: 54%;
  }

  .timeline-iconB {
    top: 25px;
    width: 40px;
    height: 40px;
    left: 48.2%;
  }

  .timeline h1 {
    font-size: 1.1em;
  }

  .timeline h6 {
    font-size: 1.0em;
  }

  .timeline-blocks .date-l,
  .timeline-blocks .date-r {
    top: 40px;
    right: 65%;
    font-size: 0.9 em;
  }

  .timeline-blocks .date-r {
    left: 65%;
  }

  .timeline-blocks {
    height: 140px;
  }

  .timeline-blocksB {
    height: 110px;
  }

  .dir-l:before {
    border-top: 16px solid transparent;
    border-bottom: 16px solid transparent;
    border-left: 16px solid #e9ecef;
  }

  .dir-r:before {
    border-top: 16px solid transparent;
    border-bottom: 16px solid transparent;
    border-right: 15px solid #e9ecef;
  }

  .timeline:before {
    left: 50%;
    top: 0;
    width: 4px;
    height: 86%;
    margin-left: -3px;
  }

  .dir-l,
  .dir-r {
    width: 36%;
  }
}

/* Extra large devices (large laptops and desktops, 1200px and up) */
@media only screen and (min-width: 1200px){
  .timeline-icon {
    width: 150px;
    height: 150px;
    left: 50%;
  }

  .timeline-iconB {
    top: 25px;
    width: 40px;
    height: 40px;
    left: 48.5%;
  }

  .timeline h1 {
    font-size: 1.3em;
  }

  .timeline h6 {
    font-size: 1.1em;
  }

  .timeline-blocks .date-l,
  .timeline-blocks .date-r {
    top: 40px;
    right: 68%;
    font-size: 1.0 em;
  }

  .timeline-blocks .date-r {
    left: 68%;
  }

  .timeline-blocks {
    height: 200px;
  }

  .timeline-blocksB {
    height: 100px;
  }

  .dir-l:before {
    border-top: 17px solid transparent;
    border-bottom: 17px solid transparent;
    border-left: 16px solid #e9ecef;
  }

  .dir-r:before {
    border-top: 17px solid transparent;
    border-bottom: 17px solid transparent;
    border-right: 15px solid #e9ecef;
  }

  .timeline:before {
    left: 50%;
    top: 0;
    width: 4px;
    height: 88%;
    margin-left: -3px;
  }

  .dir-l,
  .dir-r {
    width: 38%;
  }
} 
</style>
