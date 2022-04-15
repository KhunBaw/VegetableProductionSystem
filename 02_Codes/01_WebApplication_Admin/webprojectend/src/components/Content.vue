<template>
<div class="content">
  <div class="card" shadow="hover">
    <div class="card-body"> 
      <router-view />
    </div>
  </div>
</div>
  
</template>

<script>
export default {
  name: "Content",
    metaInfo: {
    titleTemplate: "%s | Vegetable Plots",
  },
};
</script>

<style scoped>
.card {
  padding: 20px 10px 10px 10px;
  min-height: 89vh;
  /* height: 100%; */
  border-radius: 50px 50px 5px 5px;
}
.content {
  padding-bottom: 5px;
}
</style>
