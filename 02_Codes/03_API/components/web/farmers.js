const { db } = require('../../firebase')
const secretkey = process.env.ENV_SECRET
const bcrypt = require('bcryptjs')
const { sign } = require('../../middleware.js')

exports.get = async function (req, res) {
  try {
    const data = []
    let id = 0
    await db
      .collection('farmers')
      .where('role', '==', 'user')
      .get()
      .then((datat) => {
        datat.docs.forEach((doc) => {
          data.push({
            id: ++id,
            username: doc.id,
            fm_name: doc.data().fm_name,
            fm_lname: doc.data().fm_lname,
            fm_address: doc.data().fm_address,
            fm_phnum: doc.data().fm_phnum,
            position: doc.data().position,
            photo: doc.data().photo,
          })
        })
        return res.status(200).json(data)
      })
      .catch((err) => {
        return res.status(502).send(err)
      })
  } catch (err) {
     return res.status(500).send(err);
  }
}

exports.getid = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')

  const id = req.params.id
  if (!id) return res.status(400).end()

  try {
    await db
      .collection('farmers')
      .doc(id)
      .get()
      .then((doc) => {
        if (doc.exists) {
          return res.status(200).json(doc.data())
        } else {
          return res.status(403).end()
        }
      })
      .catch((err) => {
        return res.status(502).send(err)
      })
  } catch (err) {
    return res.status(500).send(err)
  }
}

exports.delete = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const id = req.params.id
    await db
      .collection('farmers')
      .doc(id)
      .delete()
      .then(() => {
        return res.status(204).end()
      })
      .catch((err) => {
        return res.status(502).send(err)
      })
  } catch (err) {
    return res.status(500).send(err)
  }
}

exports.postsing = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  try {
    await db
      .collection('farmers')
      .doc(req.body.username)
      .get()
      .then((doc) => {
        if (!doc.exists) {
          return res.status(401).send('ไม่พบ username ในระบบ')
        } else {
          const correct = bcrypt.compareSync(
            req.body.password,
            doc.data().password
          )
          if (correct) {
            let user = {
              username: req.body.username,
              fm_name: doc.data().fm_name,
              fm_lname: doc.data().fm_lname,
              role: doc.data().role,
              photo: doc.data().photo,
            }

            return res.status(201).send({
              error: false,
              message: 'ยินดีต้อนรับ ' + user.fm_name + ' ' + user.fm_lname,
              accessToken: sign(user, secretkey,"1d"),
              user: user,
            })
          } else {
            return res.status(401).send('Password ผิดพลาด')
          }
        }
      })
      .catch((err) => {
        return res.status(502).send(err)
      })
  } catch (err) {
    return res.status(500).send(err)
  }
}

exports.post = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  let data = {
    password: bcrypt.hashSync('123456789', 10),
    fm_name: req.body.fm_name,
    fm_lname: req.body.fm_lname,
    fm_address: req.body.fm_address,
    fm_phnum: req.body.fm_phnum,
    position: req.body.position,
    role: 'user',
    photo: req.body.photo != '' ? req.body.photo :
      'https://firebasestorage.googleapis.com/v0/b/project-end-e92b5.appspot.com/o/no-image.png?alt=media&token=dcc723f4-2f63-4b64-8b23-d22cd6f9b45c',
  }

  try {
    await db
      .collection('farmers')
      .doc(req.body.username)
      .set(data)
      .then(() => {
        return res.status(201).json(data)
      })
      .catch((err) => {
        return res.status(502).send(err)
      })
  } catch (err) {
    return res.status(500).send(err)
  }
}

exports.put = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  try {
    await db
      .collection('farmers')
      .doc(req.params.id)
      .update({ password: bcrypt.hashSync('123456789', 10) })
      .then(() => {
        return res.status(201).send('เปลียนรหัสเสร็จสิ้น')
      })
      .catch((err) => {
        return res.status(502).send(err)
      })
  } catch (err) {
    return res.status(500).send('ไม่สามารถเปลียนรหัสได้')
  }
}

exports.putData = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const data = {
    fm_name: req.body.fm_name,
    fm_lname: req.body.fm_lname,
    fm_address: req.body.fm_address,
    fm_phnum: req.body.fm_phnum,
    position: req.body.position,
    photo: req.body.photo,
  }
  try {
    await db
      .collection('farmers')
      .doc(req.params.id)
      .update(data)
      .then(() => {
        return res.status(201).json(data)
      })
      .catch((err) => {
        return res.status(502).send(err)
      })
  } catch (err) {
    return res.status(500).send(err)
  }
}

exports.putreset = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const id = req.params.id;
  if (req.body.newPassword != req.body.confirmPassword) {
    return res.status(400).send('Password ไม่ตรงกัน')
  } else if (req.body.newPassword.length <= 6) {
    return res.status(400).send('Password สั้นเกินไป')
  }

  try {
    await db
      .collection('farmers')
      .doc(id)
      .get()
      .then(async (doc) => {
        if (!doc.exists) {
          return res.status(401).send('ผิดพลาด')
        } else {
          const correct = bcrypt.compareSync(req.body.password, doc.data().password)
          if (correct) {
            try {
              await db
                .collection('farmers')
                .doc(id)
                .update({ password: bcrypt.hashSync(req.body.newPassword, 10) })
              return res.status(200).send('เปลียนรหัสเสร็จสิ้น')
            } catch (err) {
              return res.status(500).send('ไม่สามารถเปลียนรหัสได้')
            }
          } else {
            return res.status(401).send('Password ผิดพลาด')
          }
        }
      })
      .catch((err) => {
        return res.status(502).send(err)
      })
  } catch (err) {
    return res.status(500).send(err)
  }
}
