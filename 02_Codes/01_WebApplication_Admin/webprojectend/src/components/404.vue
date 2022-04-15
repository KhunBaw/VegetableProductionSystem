<template>
<div class="body">
  <div class="error-page">
    <div class="cont">
      <h1 data-text="404">404</h1>
      <h4 data-text="Oop! Page not found">Oop! Page not found</h4>
      <p>Sorry, the page you're looking for doesn't exist. If you think something is broken, report a problem.</p>
    <div class="btns">
      <button @click="$router.push({ name: 'Home' })">return home</button>
      <button @click="$router.go(-1)">Return to the previous page</button>
    </div>
    </div>
  </div>
</div>
</template>

<script>
export default {
    metaInfo: {
    titleTemplate: "404",
  },
};
</script>

<style scoped>
@import url("https://fonts.googleapis.com/css?family=Numans");
*{
  margin: 0;
  padding: 0;
  outline: none;
  box-sizing: border-box;
  font-family: "Numans", sans-serif;
}
.body{
  background: -webkit-repeating-linear-gradient(-45deg, #71b7e6, #69a6ce, #b98acc, #ee8176, #b98acc, #69a6ce, #9b59b6);
  height: 100vh;
  background-size: 400%;
}

.error-page{
  position: absolute;
  top: 10%;
  left: 17%;
  right: 17%;
  bottom: 10%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fff;
  box-shadow: 0px 5px 10px rgba(0, 0, 0,0,5);
}
.error-page .cont{
  max-width: 600px;
  text-align: center;
}
.cont h1{
  font-size: 18vw;
  line-height: 1em;
  position: relative;
}
.cont h1:after{
  position: absolute;
  content: attr(data-text);
  top: 0;
  left: 0;
  right: 0;
  background: -webkit-repeating-linear-gradient(-45deg, #71b7e6, #69a6ce, #b98acc, #ee8176, #b98acc, #69a6ce, #9b59b6);
  background-size: 400%;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  text-shadow: 1px 1px 2px rgba(255, 255, 255, 0.25);
  animation: animate 20s ease-in-out infinite;
}
@keyframes animate{
  0%{
    background-position: 0 0;
  }
  25%{
    background-position: 100% 0;
  }
  50%{
    background-position: 100% 100%;
  }
  75%{
    background-position: 0 100%;
  }
  100%{
    background-position: 0 0;
  }
}
.cont h4{
  font-size: 1.5em;
  margin-bottom: 20px;
  text-transform: uppercase;
  color: #000;
  max-width: 600px;
  font-size: 2em;
  position: relative;
}
.cont h4:after{
  position: absolute;
  content: attr(data-text);
  top: 0;
  left: 0;
  right: 0;
  text-shadow: 1px 1px 2px rgba(255, 255, 255, 0.4);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}
.cont p{
  font-size: 1.2em;
  color: #0d0d0d;
}
.cont .btns{
  margin: 25px 0;
  display: inline-flex;
}
.cont .btns button{
  display: inline-block;
  margin: 0 10px;
  text-decoration: none;
  border: 2px solid #69a6ce;
  color: #69a6ce;
  font-weight: 500;
  padding: 10px 25px;
  border-radius: 25px;
  text-transform: uppercase;
  transition: all 0.3s ease;
}
.cont .btns button:hover{
  color: #fff;
  background: #69a6ce;
}
</style>
