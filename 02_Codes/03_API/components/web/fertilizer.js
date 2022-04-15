const { db } = require('../../firebase')

exports.get = async function (req, res) {
  const data = []
  const dataunit = await db.collection('unit').get()
  let id = 0

  function units(id) {
    let data = ''
    if (id != '') {
      dataunit.forEach((element) => {
        if (element.id == id) {
          data = element
        }
      })
    }
    return data.data()
  }

  function fertilizer_at(data_) {
    let data = []
    if (data_ === null) return data
    data_.forEach((element) => {
      data.push({
        fertilizer_amount: element.fertilizer_amount,
        time: element.time,
        unit: units(element.unit_id),
      })
    })
    return data
  }

  try {
    await db
      .collection('fertilizer')
      .get()
      .then((fertilizer) => {
        fertilizer.docs.forEach((doc) => {
          data.push({
            id: ++id,
            fertilizer_id: doc.id,
            fertilizer_type: doc.data().fertilizer_type,
            fertilizer_at: fertilizer_at(doc.data().fertilizer_at),
            day_times: doc.data().day_times,
            num_first: doc.data().num_first,
            num_pick: doc.data().num_pick,
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
  try {
    await db
      .collection('fertilizer')
      .doc(req.params.id)
      .get()
      .then((doc) => {
        data = [
          {
            fertilizer_id: doc.data().fertilizer_id,
            fertilizer_type: doc.data().fertilizer_type,
            fertilizer_amount: doc.data().fertilizer_amount,
            day_times: doc.data().day_times,
            time: doc.data().time,
            times_day: doc.data().times_day,
            num_first: doc.data().num_first,
            num_pick: doc.data().num_pick,
            unit_id: doc.data().unit_id,
          },
        ]
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
    fertilizer_id: dataid,
    fertilizer_type: req.body.fertilizer_type,
    fertilizer_at: req.body.fertilizer_at,
    day_times: Number(req.body.day_times),
    num_first: Number(req.body.num_first),
    num_pick: Number(req.body.num_pick),
  }
  try {
    await db
      .collection('fertilizer')
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
    fertilizer_type: req.body.fertilizer_type,
    fertilizer_at: fertilizer_at(req.body.fertilizer_at),
    day_times: Number(req.body.day_times),
    num_first: Number(req.body.num_first),
    num_pick: Number(req.body.num_pick),
  }

  function fertilizer_at(data) {
    let data_ = []
    data.forEach((element) => {
      data_.push({
        fertilizer_amount: element.fertilizer_amount,
        time: element.time,
        unit_id: element.unit.unit_id,
      })
    })
    return data_
  }

  try {
    await db
      .collection('fertilizer')
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
    await db.collection('fertilizer').doc(req.params.id).delete().then(() => {
      return res.status(204).end()
    })
    .catch(() => {
      return res.status(502).send(err)
    })
  } catch (err) {
    return res.status(500).send(err)
  }
}
