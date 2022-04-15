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

  function solving(data) {
    let valu = []
    data.forEach(element => {
      valu.push({
        name: element.name,
        amount: Number(element.amount),
        unit: units(element.unit_id),
      })
    });
    return valu;
  }

  try {
    await db
      .collection('problems')
      .get()
      .then((problems) => {
        problems.docs.forEach((doc) => {
          data.push({
            problems_id: doc.data().problems_id,
            problems_name: doc.data().problems_name,
            solving: solving(doc.data().solving),
            cycle: doc.data().cycle,
            phase: doc.data().phase,
            id: ++id,
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
      .collection('problems')
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
    problems_id: dataid,
    problems_name: req.body.problems_name,
    solving: req.body.solving,
    cycle: req.body.cycle,
    phase: req.body.phase,
  }

  try {
    await db
      .collection('problems')
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

  const solving_f = () => {
    let sol = []
    req.body.solving.forEach(element => {
      sol.push({
        amount: Number(element.amount),
        name: element.name,
        unit_id : element.unit.unit_id
      })
      

    });

    return sol;
  }

  const data = {
    problems_name: req.body.problems_name,
    solving: solving_f(),
    cycle: req.body.cycle,
    phase: req.body.phase,
  }

  try {
    await db
      .collection('problems')
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
    .collection('problems')
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
