const { db } = require('../../firebase')

exports.get = async function (req, res) {
  try {
    const vegetable = await db.collection('vegetable').get()
    const data = []
    let id = 0

    const f_vegetable = (data) => {
      let f_data = ''
      //if (data) return f_data
      vegetable.forEach((element) => {
        if (element.id == data) f_data = element.data().v_name;
      })
      return f_data
    }

    await db
      .collection('area')
      .get()
      .then((area) => {
        area.docs.forEach((doc) => {
          data.push({
            id: ++id,
            area_id: doc.data().area_id,
            area_name: doc.data().area_name,
            area_long: doc.data().area_long,
            area_wide: doc.data().area_wide,
            area_photo: doc.data().area_photo,
            area_detail: doc.data().area_detail,
            area_rest_period: doc.data().area_rest_period,
            area_lv: f_vegetable(doc.data().area_lv),
            status: doc.data().status,
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


exports.post = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')

  const dataid = Date.now().toString()
  const data = {
    area_id: dataid,
    area_name: req.body.area_name,
    area_long: req.body.area_long,
    area_wide: req.body.area_wide,
    area_photo: req.body.area_photo,
    area_detail: req.body.area_detail,
    area_rest_period: req.body.area_rest_period,
    area_lv: '',
    status: false,
  }

  try {
    await db
      .collection('area')
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
    area_name: req.body.area_name,
    area_long: req.body.area_long,
    area_wide: req.body.area_wide,
    area_photo: req.body.area_photo,
    area_detail: req.body.area_detail,
    area_rest_period: req.body.area_rest_period,
  }
  try {
    await db
      .collection('area')
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
      .collection('area')
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
