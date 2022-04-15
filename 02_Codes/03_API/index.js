require('dotenv').config()
const express = require('express')
const app = express()
const cors = require('cors')
const multer = require('multer')
const apiversion = '/api/v1'
const { verify } = require('./middleware.js')

app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

const upload = multer({
  storage: multer.memoryStorage(),
})

const farmers = require('./components/web/farmers')
app.post(apiversion + '/user/register', verify, farmers.post) //ใช้
app.post(apiversion + '/signin', farmers.postsing)  //ใช้
app.get(apiversion + '/farmers', verify, farmers.get)  //ใช้
app.get(apiversion + '/farmers/:id', verify, farmers.getid) //ใช้
app.delete(apiversion + '/farmers/:id', verify, farmers.delete)
app.put(apiversion + '/farmers/:id', verify, farmers.putData) //ใช้
app.put(apiversion + '/resetpass/:id', verify, farmers.put) //ใช้
app.put(apiversion + '/repass/:id', verify, farmers.putreset)

//ผัก vegetable
const vegetable = require('./components/web/vegetable')
//แสดงทั้งหมด
app.get(apiversion + '/vegetable', verify, vegetable.get) //ใช้
//แสดงตาม id
//app.get(apiversion + '/vegetable/:id', verify, vegetable.getid)
//เพิ่ม
app.post(apiversion + '/addvegetable', verify, vegetable.post) //ใช้
//อัพเดท
app.put(apiversion + '/vegetable/:id', verify, vegetable.put) //ใช้
//ลบ
app.delete(apiversion + '/vegetable/:id', verify, vegetable.delete) //ใช้
//อัพเดท
app.post(apiversion + '/vegetable/vfertilizer/:id', verify, vegetable.postvf) //ใช้
//ลบ
app.put(apiversion + '/vegetable/vfertilizer/:id', verify, vegetable.deletevf) //ใช้
//อัพเดท
app.put(apiversion + '/vegetable/evfertilizer/:id', verify, vegetable.putvf) //ใช้
// หมดเขตผัก

//พื้นที่ area
const area = require('./components/web/area')
//แสดงทั้งหมด
app.get(apiversion + '/area', verify, area.get) //ใช้
//เพิ่ม
app.post(apiversion + '/addarea', verify, area.post) //ใช้
//อัพเดท
app.put(apiversion + '/area/:id', verify, area.put) //ใช้
//ลบ
app.delete(apiversion + '/area/:id', verify, area.delete) //ใช้
//หมดเขตพื้นที่

//คำสั่งซื้อ order
const order = require('./components/web/order')
//แสดงทั้งหมด
app.get(apiversion + '/order', verify, order.get) //ใช้
//แสดงตาม id
app.get(apiversion + '/order/:id', verify, order.getid)//ใช้
//เพิ่ม
app.post(apiversion + '/addorder', verify, order.post) //ใช้
//อัพเดท
app.put(apiversion + '/order/:id', verify, order.put) //ใช้
//ลบ
app.delete(apiversion + '/order/:id', verify, order.delete) //ใช้
//หมดเขตคำสั่งซื้อ

//ปุ๋ย fertilizer
const fertilizer = require('./components/web/fertilizer')
//แสดงทั้งหมด
app.get(apiversion + '/fertilizer', verify, fertilizer.get) //ใช้
//แสดงตาม id
//app.get(apiversion + '/fertilizer/:id', verify, fertilizer.getid)
//เพิ่ม
app.post(apiversion + '/addfertilizer', verify, fertilizer.post) //ใช้
//อัพเดท
app.put(apiversion + '/fertilizer/:id', verify, fertilizer.put) //ใช้
//ลบ
app.delete(apiversion + '/fertilizer/:id', verify, fertilizer.delete) //ใช้
//หมดเขตปุ๋ย

//หน่วย unit
const unit = require('./components/web/unit')
//แสดงทั้งหมด
app.get(apiversion + '/unit', verify, unit.get) //ใช้
//หมดเขตหน่วย

//ปัญหา problems
const problems = require('./components/web/problems')
//แสดงทั้งหมด
app.get(apiversion + '/problems', verify, problems.get) //ใช้
//เพิ่ม
app.post(apiversion + '/addproblems', verify, problems.post) //ใช้
//แสดงตาม id
//app.get(apiversion + '/problems/:id', verify, problems.getid)
//อัพเดท
app.put(apiversion + '/problems/:id', verify, problems.put) //ใช้
//ลบ
app.delete(apiversion + '/problems/:id', verify, problems.delete) //ใช้
//หมดเขตปัญหา

//หมดเขตข้อมูลพื้นฐาน

//เก็บปัญหา keep_problem
const keep_problem = require('./components/web/keep_problem')
//แสดงทั้งหมด
app.get(apiversion + '/keep_problem', verify, keep_problem.get)
//เพิ่ม
app.post(apiversion + '/addkeep_problem', verify, keep_problem.post)
//แสดงตาม id pd
app.get(apiversion + '/keep_problem/:id', verify, keep_problem.getid)
//อัพเดท
app.put(apiversion + '/keep_problem/:id', verify, keep_problem.put)
//ลบ
app.delete(apiversion + '/keep_problem/:id', verify, keep_problem.delete)
//หมดเขตการดูแล

//รูปภาพ photo
const photo = require('./components/web/photo')
// อัพรูป
app.post(apiversion + '/upload', verify, upload.single('file'), photo.post)
// app.get(apiversion + '/img/:id', photo.get)
//แสดงตาม id
// app.get(apiversion + '/photo/:id', verify, photo.getps)
//อัพเดท
// app.put(apiversion + '/photo/:id', verify, photo.put)
//หมดเขตรูปภาพ

// //พื้นที่จำนวนผัก use_area
// const use_area = require('./components/web/use_area')
// //แสดงทั้งหมด
// app.get(apiversion + '/use_area', verify, use_area.get)
// //เพิ่ม
// app.post(apiversion + '/adduse_area', verify, use_area.post)
// //แสดงตาม id pd
// app.get(apiversion + '/use_area/:id', verify, use_area.getid)
// //อัพเดท
// app.put(apiversion + '/use_area/:id', verify, use_area.put)
// //ลบ
// app.delete(apiversion + '/use_area/:id', verify, use_area.delete)
// //หมดเขตพื้นที่จำนวนผัก

//พื้นที่ระบุผักในคำสั่งซื้อ vegetable_order
const vegetable_order = require('./components/web/vegetable_order')
//แสดงทั้งหมด
app.get(apiversion + '/vegetable_order', verify, vegetable_order.get) //ใช้
//เพิ่ม
app.post(apiversion + '/addvegetable_order', verify, vegetable_order.post) //ใช้
//แสดงตาม id
app.get(apiversion + '/vegetable_order/:id', verify, vegetable_order.getid) //ใช้
//อัพเดท status
app.get(
  apiversion + '/vegetable_order_status/:id',
  verify,
  vegetable_order.putstatus
) //ใช้
//ลบ
app.delete(apiversion + '/vegetable_order/:id', verify, vegetable_order.delete) //ใช้
//หมดเขตพื้นที่ระบุผักในคำสั่งซื้อ

//DashBoard
const dashboard = require('./components/web/dashboard')
app.get(apiversion + '/dashboard', verify, dashboard.get) //ใช้

//PGS
const pgs = require('./components/web/pgs')
app.get(apiversion + '/pgs', verify, pgs.get)//ใช้

//QR
const qr = require('./components/web/qr')
app.get(apiversion + '/qr/:id', qr.getid)//ใช้

//mobile
const p_login = require('./components/mobile/login')
app.post(apiversion + '/mobile/signin', p_login.postsing)
app.get(apiversion + '/mobile/farmers',verify, p_login.getid)

const p_production = require('./components/mobile/production')
app.get(apiversion + '/mobile/production',verify, p_production.get)
app.get(apiversion + '/mobile/productionH',verify, p_production.getH)
app.post(apiversion + '/mobile/production',verify, p_production.post)
app.post(apiversion + '/mobile/production/problem/:id',verify, p_production.postProblem)
app.put(apiversion + '/mobile/production/problem/:id',verify, p_production.putProblem)
app.get(apiversion + '/mobile/production/pt/:id',verify, p_production.getPT)
app.post(apiversion + '/mobile/production/ph/:id',verify,upload.single('file'), p_production.postPH)
app.post(apiversion + '/mobile/production/take/:id',verify, p_production.postTake)

const p_vegetable_order = require('./components/mobile/vegetable_order')
app.get(apiversion + '/mobile/vegetable_order',verify, p_vegetable_order.get)

const p_area = require('./components/mobile/area')
app.get(apiversion + '/mobile/area',verify, p_area.get)

const p_problems = require('./components/mobile/problems')
app.get(apiversion + '/mobile/problems',verify, p_problems.get)

const p_vegetable_loss = require('./components/mobile/vegetable_loss')
app.get(apiversion + '/mobile/vegetable_loss', p_vegetable_loss.get)

const p_notification = require('./components/mobile/notification')
app.get(apiversion + '/mobile/notification',verify,p_notification.get)

const p_unit = require('./components/mobile/unit')
app.get(apiversion + '/mobile/unit',verify,p_unit.get)

app.listen(process.env.PORT || 3000, function () {
  console.log(
    'Express server listening on port %d in %s mode',
    this.address().port,
    app.settings.env
  )
})
