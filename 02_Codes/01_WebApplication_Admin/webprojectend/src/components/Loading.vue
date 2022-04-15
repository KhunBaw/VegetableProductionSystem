<template>
  <div class="page-loader" v-if="!isloaded">
    <scaling-squares-spinner
      :animation-duration="1250"
      :size="65"
      color="#ff1d5e"
    />
  </div>
</template>

<script>
import { ScalingSquaresSpinner } from "epic-spinners";
export default {
  components: {
    ScalingSquaresSpinner,
  },
  props: {
    isloaded: Boolean,
  },
  
};
</script>

<style>
.page-loader {
  display: flex;
  justify-content: center;
  align-items: center;
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  background-color: #dddddd;
  z-index: 999;
}
</style>
