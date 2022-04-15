import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../components/Home'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Login',
    component: () => import('../components/Login.vue')
  },
  {
    path: "*",
    name: "404",
    component: () => import("../components/404.vue"),
  },
  {
    path: "/PGS",
    name: "PGS",
    component: () => import("../components/content/PGS.vue"),
  },
  {
    path: "/QR/:id",
    name: "QR",
    component: () => import("../components/content/QR.vue"),
  },
  {
    path: "/Home",
    name: "Home",
    component: Home,
    redirect: {
      name: "Dashboard",
    },
    children: [
      {
        path: "/Home/Dashboard",
        name: "Dashboard",
        component: () => import("../components/content/DashBoard"),
      },
      {
        path: "/Home/Fertilizer",
        name: "Fertilizer",
        component: () => import("../components/content/fertilizer/Table"),
      },
      {
        path: "/Home/Area",
        name: "Area",
        component: () => import("../components/content/area/Table"),
      },
      {
        path: "/Home/Farmers",
        name: "Farmers",
        component: () => import("../components/content/farmers/Table"),
      },
      {
        path: "/Home/Vegetable",
        name: "Vegetable",
        component: () => import("../components/content/vegetable/Table"),
      },
      {
        path: "/Home/Order",
        name: "Order",
        component: () => import("../components/content/order/Table"),
      },
      {
        path: "/Home/V_order",
        name: "V_order",
        component: () => import("../components/content/v_order/Table"),
      },
      {
        path: "/Home/Problems",
        name: "Problems",
        component: () => import("../components/content/problems/Table"),
      },
    ],
  },
]

const router = new VueRouter({
  mode: 'history',
  routes
})

export default router
