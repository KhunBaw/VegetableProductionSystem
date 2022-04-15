const { db } = require('../../firebase')

exports.get = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const data = []
    let id = 0
    await db
      .collection('problems')
      .get()
      .then((problems) => {
        problems.docs.forEach((doc) => {
          data.push({
            problems_id: doc.data().problems_id,
            problems_name: doc.data().problems_name,
            solving: doc.data().solving,
            id: ++id,
          })
        })
      })

    res.status(200).json(data)
  } catch (err) {
    return res.send(err)
  }
}
