import Vue from 'vue'
import App from './App.vue'
import router from './router'
import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
import VueHtml2pdf from 'vue-html2pdf'
Vue.use(VueHtml2pdf)
// Import Bootstrap an BootstrapVue CSS files (order is important)
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

// Make BootstrapVue available throughout your project
Vue.use(BootstrapVue)
// Optionally install the BootstrapVue icon components plugin
Vue.use(IconsPlugin)

import Vuelidate from 'vuelidate'
Vue.use(Vuelidate)

import VueMeta from 'vue-meta'
Vue.use(VueMeta)

import VueMyToasts from 'vue-my-toasts'
import 'vue-my-toasts/dist/vue-my-toasts.css'
import BootstrapComponent from "vue-my-toasts/src/components/toasts/BootstrapComponent";

import th from 'vee-validate/dist/locale/th';
import VeeValidate, { Validator } from 'vee-validate';

// Install the Plugin.
Vue.use(VeeValidate, {
  inject: true,
  fieldsBagName: 'veeFields'
});

// Localize takes the locale object as the second argument (optional) and merges it.
Validator.localize('th', th);

Vue.use(VueMyToasts, {
  component: BootstrapComponent,
  options: {
    width: '400px',
    position: 'bottom-right',
    padding: '2rem'
  }
})

Vue.config.productionTip = false
Vue.prototype.$apiUrl = "https://vegetable-api.herokuapp.com/api/v1/";
// Vue.prototype.$apiUrl = "http://192.168.1.7:3000/api/v1/";
// Vue.prototype.$QrUrl = "http://192.168.1.7:8080/QR/";
 Vue.prototype.$QrUrl = "https://vegetable-webs.herokuapp.com/QR/";

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')