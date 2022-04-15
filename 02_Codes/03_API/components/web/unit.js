const { db } = require('../../firebase')

exports.get = async function (req, res) {
  const data = []

  try {
    await db
      .collection('unit')
      .get()
      .then((unit) => {
        unit.docs.forEach((doc) => {
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
