const { db } = require('../../firebase')

exports.get = async function (req, res) {
  const data = []

  try {
    await db
      .collection('production')
      .get()
      .then((production) => {
        production.docs.forEach((doc) => {
          data.push(doc.data())
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

  try {

    await db
      .collection('production')
      .doc(req.params.id)
      .get()
    if (!production.exists) {
      res.status(404).send()
    } else {
      res.status(200).json(production)
    }
  } catch (err) {
    return res.status(500).send(err)
  }
}

exports.post = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const dataid = Date.now().toString()
  const data1 = {
    pd_id: dataid,
    pd_d1: req.body.pd_d1,
    pd_d2: req.body.pd_d2,
    pd_d3: req.body.pd_d3,
    od_id: req.body.od_id,
  }
  const data2 = {
    pd_id: dataid,
    ph_d1: '',
    ph_d2: '',
    ph_d3: '',
  }

  try {
    await db
      .collection('production')
      .doc(dataid)
      .set(data1)
      .then(() => {
        return res.status(201).json(data)
      })
      .catch((err) => {
        return res.status(502).send(err)
      })

    await db
      .collection('photo')
      .doc(dataid)
      .set(data2)
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
    pd_d1: req.body.pd_d1,
    pd_d2: req.body.pd_d2,
    pd_d3: req.body.pd_d3,
    od_id: req.body.od_id,
  }

  try {
    await db
      .collection('production')
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
      .collection('production')
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
