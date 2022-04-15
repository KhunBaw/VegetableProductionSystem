const { db } = require('../../firebase')
const secretkey = process.env.ENV_SECRET
const bcrypt = require('bcryptjs')
const { sign } = require('../../middleware.js')

exports.postsing = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const doc = await db.collection('farmers').doc(req.body.username).get()

    if (!doc.exists) {
      return res.status(401).send('ไม่พบ username ในระบบ')
    } else {
      let hashedPassword = doc.data().password
      const correct = bcrypt.compareSync(req.body.password, hashedPassword)
      if (correct) {
        let user = {
          username: req.body.username,
          fm_name: doc.data().fm_name,
          fm_lname: doc.data().fm_lname,
          role: doc.data().role,
          photo: doc.data().photo,
        }

        // create a token
        let token = sign(user, secretkey,req.body.key == true ? "7d" : "1d")

        return res.status(201).json({
          error: false,
          message: 'ยินดีต้อนรับ ' + user.fm_name + ' ' + user.fm_lname,
          accessToken: token,
          user: user,
        })
      } else {
        return res.status(401).send('Password ผิดพลาด')
      }
    }
  } catch (err) {
    return res.status(401).send('ข้อมูลไม่ถูกต้อง')
  }
}

exports.getid = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  return res.status(200).send('ผ่าน')
}
