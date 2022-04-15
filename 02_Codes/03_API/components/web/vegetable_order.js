const { db } = require('../../firebase')

exports.get = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const data = []
  const order = await db.collection('order').get()
  const vegetable = await db.collection('vegetable').get()
  const unit = await db.collection('unit').get()
  const production = await db.collection('production').get()

  function dataput(id, dataitem) {
    let datat = []
    if (id != '') {
      dataitem.forEach((element) => {
        if (element.id == id) {
          datat.push(element.data())
        }
      })
    }
    return datat != [] ? datat[0] : []
  }

  function f_production(id) {
    let datat = []
    if (id != '') {
      production.forEach((element) => {
        element.data().order_id.forEach((element2) => {
          if (element2 === id) {
            datat.push({
              pd_id: element.data().pd_id,
              v_name: dataput(element.data().v_id, vegetable).v_name,
            })
          }
        })
      })
    }
    return datat
  }

  try {
    await db
      .collection('vegetable_order')
      .where('status', '!=', 'success')
      .get()
      .then((vegetable_order) => {
        vegetable_order.docs.forEach((doc) => {
          const datav = []
          doc.data().vegetable.forEach((element) => {
            datav.push({
              unit_id: element.unit_id,
              v_id: element.v_id,
              weight: element.weight,
              unit: dataput(element.unit_id, unit),
              vegetable: dataput(element.v_id, vegetable),
            })
          })

          data.push({
            order_id: doc.id,
            date: new Date(doc.data().date).toLocaleDateString('th-TH'),
            date_final: new Date(doc.data().date_final).toLocaleDateString(
              'th-TH'
            ),
            status: doc.data().status,
            order: dataput(doc.data().od_id, order),
            vegetable: datav,
            production: f_production(doc.id),
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
  const id = req.params.id
  const data = []
  const doc = await db.collection('vegetable_order').doc(id).get()
  const vegetable = await db.collection('vegetable').get()
  const unit = await db.collection('unit').get()
  const production = await db.collection('production').get()

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

    if (!doc.exists) {
      await db
        .collection('vegetable_order')
        .where('od_id', '==', req.params.id)
        .get()
        .then((Data) => {
          Data.docs.forEach((doc) => {
            const datav = []
            doc.data().vegetable.forEach((element) => {
              datav.push({
                unit_id: element.unit_id,
                v_id: element.v_id,
                weight: element.weight,
                unit: dataput(element.unit_id, unit)[0],
                vegetable: dataput(element.v_id, vegetable)[0],
              })
            })
            if (doc.data().status != 'success')
              data.push({
                order_id: doc.id,
                date: new Date(doc.data().date).toLocaleDateString('th-TH'),
                date_final: new Date(doc.data().date_final).toLocaleDateString(
                  'th-TH'
                ),
                status: doc.data().status,
                vegetable: datav,
                production: f_production(doc.id),
              })
          })
          res.status(200).json(data)
        })
        .catch((err) => {
          return res.status(502).send(err)
        })

      function f_production(id) {
        let datat = []
        if (id != '') {
          production.forEach((element) => {
            element.data().order_id.forEach((element2) => {
              if (element2 === id) {
                datat.push({
                  pd_id: element.data().pd_id,
                  v_name: dataput(element.data().v_id, vegetable)[0].v_name,
                })
              }
            })
          })
        }
        return datat
      }
    } else {
      data.push(doc.data())
    }

  } catch (err) {
    return res.status(500).send(err)
  }
}

exports.post = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const dataid = Date.now()
  const data = {
    order_id: dataid.toString(),
    od_id: req.body.od_id,
    vegetable: req.body.vegetable,
    date: new Date().toLocaleDateString('en-US'),
    date_final: new Date(req.body.date_final).toLocaleDateString('en-US'),
    status: 'start',
  }

  try {
    await db
      .collection('vegetable_order')
      .doc(dataid.toString())
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

exports.putstatus = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const data = {
    status: 'success',
  }

  try {
    await db
      .collection('vegetable_order')
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
  const id = req.params.id

  try {
    await db
      .collection('vegetable_order')
      .doc(id)
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
