const { db } = require('../../firebase')

exports.get = async function (req, res) {
  const data = []
  let id = 0
  const data_fertilizer = await db.collection('fertilizer').get()
  const data_unit = await db.collection('unit').get()
  const data_production = await db.collection('production').get()

  function status(id) {
    let data = false

    data_production.forEach((element) => {
      if (element.data().v_id == id) data = true
    })

    return data
  }

  function v_fertilizer(data_) {
    let data = []
    let num = 0
    if (data_[0] === '') return []
    data_.forEach((element) => {
      if (element.fertilizer_id != '') {
        data.push({
          id: ++num,
          fertilizer: fertilizers(element.fertilizer_id),
          fertilizer_type: '',
          day_times: element.day_times,
          num_first: element.num_first,
          num_pick: element.num_pick,
          fertilizer_at: fertilizer_at(element.fertilizer_at),
        })
      } else {
        data.push({
          id: ++num,
          fertilizer_type: element.fertilizer_type,
          fertilizer_id: '',
          day_times: element.day_times,
          num_first: element.num_first,
          num_pick: element.num_pick,
          fertilizer_at: fertilizer_at(element.fertilizer_at),
        })
      }
    })
    return data
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

  function fertilizers(id) {
    let data = ''
    if (id === null) return data
    if (id != '') {
      data_fertilizer.forEach((element) => {
        if (element.id == id) {
          data = element
        }
      })
    }
    return data.data()
  }

  function units(id) {
    let data = ''
    if (id === null) return data
    if (id != '') {
      data_unit.forEach((element) => {
        if (element.id == id) {
          data = element
        }
      })
    }
    return data.data()
  }

  try {
    await db
      .collection('vegetable')
      .get()
      .then((vegetable) => {
        vegetable.docs.forEach((doc) => {
          data.push({
            id: ++id,
            v_id: doc.data().v_id,
            v_name: doc.data().v_name,
            v_long: doc.data().v_long,
            v_wide: doc.data().v_wide,
            v_nfv: doc.data().v_nfv,
            v_d1: doc.data().v_d1,
            v_d2: doc.data().v_d2,
            v_d3: doc.data().v_d3,
            v_photo: doc.data().v_photo,
            v_fertilizer: v_fertilizer(doc.data().v_fertilizer),
            status: status(doc.data().v_id),
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

  try {
    //const data = [];
    await db
      .collection('vegetable')
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
    v_id: dataid,
    v_name: req.body.v_name,
    v_long: req.body.v_long,
    v_wide: req.body.v_wide,
    v_fertilizer: [],
    v_nfv: req.body.v_nfv,
    v_d1: req.body.v_d1,
    v_d2: req.body.v_d2,
    v_d3: req.body.v_d3,
    v_photo: req.body.v_photo,
  }

  try {

    await db
      .collection('vegetable')
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
    v_name: req.body.v_name,
    v_long: req.body.v_long,
    v_wide: req.body.v_wide,
    v_nfv: req.body.v_nfv,
    v_d1: req.body.v_d1,
    v_d2: req.body.v_d2,
    v_d3: req.body.v_d3,
    v_photo: req.body.v_photo,
  }

  try {
    await db
      .collection('vegetable')
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
    await db.collection('vegetable').doc(req.params.id).delete()
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

exports.postvf = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  let id = req.params.id
  const datav = await db.collection('vegetable').doc(id).get()

  try {
    await db
      .collection('vegetable')
      .doc(id)
      .update({
        v_fertilizer: await fvegetable(),
      }).then(()=>{
        return res.status(204).end()
      }).catch((err) => {
        return res.status(502).send(err)
      })

    async function fvegetable() {
      let data = []
      data = datav.data().v_fertilizer
      data.push({
        fertilizer_type: await (
          await fertilizer_type(req.body.fertilizer_type)
        ).fertilizer_type,
        fertilizer_id: await (
          await fertilizer_type(req.body.fertilizer_type)
        ).fertilizer_id,
        num_first: req.body.num_first,
        day_times: req.body.day_times,
        num_pick: req.body.num_pick,
        fertilizer_at: req.body.fertilizer_at,
      })
      return data
    }

    async function fertilizer_type(data_) {
      let fertilizer = {}
      await db
        .collection('fertilizer')
        .where('fertilizer_type', '==', data_)
        .get()
        .then((dataf) => {
          dataf.docs.forEach((element) => {
            fertilizer = element.data()
          })
        })
        .catch((err) => {
          return res.status(502).send(err)
        })

      if (fertilizer.fertilizer_type != null) {
        return { fertilizer_id: fertilizer.fertilizer_id, fertilizer_type: '' }
      } else {
        return { fertilizer_id: '', fertilizer_type: data_ }
      }
    }

  } catch (err) {
    return res.status(500).send(err)
  }
}

exports.putvf = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  let id = req.params.id
  const datav = await db.collection('vegetable').doc(id).get()

  try {
    let doc = await db
      .collection('vegetable')
      .doc(id)
      .update({
        v_fertilizer: await fvegetable(),
      }).then(()=>{
        return res.status(204).end()
      }).catch((err) => {
        return res.status(502).send(err)
      })

    async function fvegetable() {
      let data = []
      let index = req.body.id - 1
      data = datav.data().v_fertilizer
        ; (data[index].fertilizer_type = await (
          await fertilizer_type(req.body.fertilizer_type)
        ).fertilizer_type),
          (data[index].fertilizer_id = await (
            await fertilizer_type(req.body.fertilizer_type)
          ).fertilizer_id),
          (data[index].num_first = req.body.num_first)
      data[index].day_times = req.body.day_times
      data[index].num_pick = req.body.num_pick
      data[index].fertilizer_at = fertilizer_at(req.body.fertilizer_at)
      return data
    }

    function fertilizer_at(data_) {
      let datad = []
      data_.forEach((element) => {
        datad.push({
          fertilizer_amount: element.fertilizer_amount,
          time: element.time,
          unit_id: element.unit.unit_id,
        })
      })
      return datad
    }

    async function fertilizer_type(data_) {
      let fertilizer = {}
      await db
        .collection('fertilizer')
        .where('fertilizer_type', '==', data_)
        .get()
        .then((dataf) => {
          dataf.docs.forEach((element) => {
            fertilizer = element.data()
          })
        })
        .catch((err) => {
          return res.status(502).send(err)
        })

      if (fertilizer.fertilizer_type != null) {
        return { fertilizer_id: fertilizer.fertilizer_id, fertilizer_type: '' }
      } else {
        return { fertilizer_id: '', fertilizer_type: data_ }
      }
    }

  } catch (err) {
    return res.status(500).send(err)
  }
}

exports.deletevf = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const datav = await db.collection('vegetable').doc(req.body.v_id).get()
    let data = datav.data().v_fertilizer
    data.splice(req.params.id, 1)
    await db.collection('vegetable').doc(req.body.v_id).update({
      v_fertilizer: data,
    }).then(()=>{
      return res.status(204).end()
    })
      .catch((err) => {
        return res.status(502).send(err)
      })
  } catch (err) {
    return res.status(500).send(err)
  }
}
