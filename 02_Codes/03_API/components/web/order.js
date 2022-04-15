const { db } = require('../../firebase')

exports.get = async function (req, res) {
  const data = []
  let id = 0
  const data_vegetable_order = await db.collection('vegetable_order').get()

  function vegetable_order(od_id) {
    let data = false
    data_vegetable_order.forEach((element) => {
      if (
        element.data().od_id == od_id &&
        (element.data().status == 'progress' ||
          element.data().status == 'problem' ||
          element.data().status == 'final')
      )
        data = true
    })
    return data
  }

  try {
    await db
      .collection('order')
      .get()
      .then((order) => {
        order.docs.forEach((doc) => {
          data.push({
            id: ++id,
            od_id: doc.id,
            od_name: doc.data().od_name,
            od_lname: doc.data().od_lname,
            od_address: doc.data().od_address,
            od_road: doc.data().od_road,
            od_locality: doc.data().od_locality,
            od_district: doc.data().od_district,
            od_province: doc.data().od_province,
            od_phnum: doc.data().od_phnum,
            od_date: new Date(doc.data().od_date).toLocaleDateString('th-TH'),
            status: vegetable_order(doc.id),
          })
        })
        res.status(200).json(data)
      })
      .catch((err) => {
        return res.status(502).send(err)
      })
  } catch (err) {
    return res.status(500).send(err)
  }
}

exports.getid = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    //const data = [];
    await db
      .collection('order')
      .doc(req.params.id)
      .get()
      .then((doc) => {
        if (doc.exists) {
          return res.status(204).send(doc)
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

exports.post = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const dataid = Date.now().toString()
  const data = {
    od_id: dataid,
    od_name: req.body.od_name,
    od_lname: req.body.od_lname,
    od_address: req.body.od_address,
    od_road: req.body.od_road,
    od_locality: req.body.od_locality,
    od_district: req.body.od_district,
    od_province: req.body.od_province,
    od_phnum: req.body.od_phnum,
    od_date: new Date().toLocaleDateString('en-US'),
  }

  try {
    await db
      .collection('order')
      .doc(dataid)
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
  const data = {
    od_name: req.body.od_name,
    od_lname: req.body.od_lname,
    od_address: req.body.od_address,
    od_road: req.body.od_road,
    od_locality: req.body.od_locality,
    od_district: req.body.od_district,
    od_province: req.body.od_province,
    od_phnum: req.body.od_phnum,
  }

  try {
    await db
      .collection('order')
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

exports.delete = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    await db.collection('order').doc(req.params.id).delete().then(() => {
      return res.status(204).end()
    })
    .catch(() => {
      return res.status(502).send(err)
    })
  } catch (err) {
    return res.status(500).send(err)
  }
}
