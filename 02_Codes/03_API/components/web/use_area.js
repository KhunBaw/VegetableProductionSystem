const { db } = require('../../firebase')

exports.get = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const data = []
  const vegetable = await db.collection('vegetable').get()
  const area = await db.collection('area').get()

  function dataput(id, dataitem) {
    let datat = []
    if (id != '') {
      dataitem.forEach((element) => {
        if (element.id == id) {
          datat.push(element.data())
        }
      })
    }
    return datat
  }

  try {
    await db
      .collection('use_area')
      .get()
      .then((use_area) => {
        use_area.docs.forEach((doc) => {
          data.push({
            use_id: doc.id,
            pd_id: doc.data().pd_id,
            planted_number: doc.data().planted_number,
            area: dataput(doc.data().area_id, area),
            vegetable: dataput(doc.data().v_id, vegetable),
          })
        })
        return res.status(200).json(data)
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
  const data = []
  const doc = await db.collection('use_area').doc(id).get()
  const id = req.params.id

  try {
    if (!doc.exists) {
      await db
        .collection('use_area')
        .where('pd_id', '==', id)
        .get()
        .then((Data) => {
          Data.docs.forEach((doc) => {
            data.push(doc.data())
          })
        })
        .catch((err) => {
          return res.status(502).send(err)
        })

    } else {
      data.push(doc.data())
    }

  } catch (err) {
    return res.status(500).send(err)
  }
}

exports.post = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const dataid = Date.now().toString()
  const data = {
    use_id: req.body.dataid,
    area_id: req.body.area_id,
    pd_id: req.body.pd_id,
    planted_number: req.body.planted_number,
    v_id: req.body.v_id,
  }

  try {

    await db
      .collection('use_area')
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
    area_id: req.body.area_id,
    pd_id: req.body.pd_id,
    planted_number: req.body.planted_number,
    pd_d3: req.body.pd_d3,
    v_id: req.body.v_id,
  }

  try {
    await db
      .collection('use_area')
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
    await db
      .collection('use_area')
      .doc(req.params.id)
      .delete()
      .then(() => {
        return res.status(204).end()
      })
      .catch(() => {
        return res.status(502).send(err)
      })
  } catch (err) {
    return res.status(500).send(err)
  }
}
