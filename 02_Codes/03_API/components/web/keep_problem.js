const { db } = require('../../firebase')

exports.get = async function (req, res) {
  const data = []

  try {
    await db
      .collection('keep_problem')
      .get()
      .then((keep_problem) => {
        keep_problem.docs.forEach((doc) => {
          data.push(doc.data())
        })
        res.status(200).json(data)
      })
      //console.log(data);
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

  try {
    const data = []
    const doc = await db.collection('keep_problem').doc(id).get()
    if (!doc.exists) {
      await db
        .collection('keep_problem')
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

    res.status(200).json(data)
  } catch (err) {
    return res.status(500).send(err)
  }
}

exports.post = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  const dataid = Date.now().toString()
  const data = {
    keep_id: dataid,
    additional_troubleshooting: req.body.additional_troubleshooting,
    fm_id: req.body.fm_id,
    other_problems: req.body.other_problems,
    pd_id: req.body.pd_id,
    problem_date: req.body.problem_date,
    problems_id: req.body.problems_id,
    solving_id: req.body.solving_id,
  }

  try {
    await db.collection('keep_problem').doc(dataid).set(data)
    res
      .send(doc.id)
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
    additional_troubleshooting: req.body.additional_troubleshooting,
    fm_id: req.body.fm_id,
    other_problems: req.body.other_problems,
    pd_id: req.body.pd_id,
    problem_date: req.body.problem_date,
    problems_id: req.body.problems_id,
    solving_id: req.body.solving_id,
  }

  try {
    await db
      .collection('keep_problem')
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
      .collection('keep_problem')
      .doc(req.params.id)
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
