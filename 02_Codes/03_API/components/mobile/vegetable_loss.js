const { db } = require('../../firebase')

exports.get = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const production = await db.collection('production').get()

    const loss = () => {
      let num = 0
      production.docs.forEach((element) => {
        let num2 = 0
        element.data().keep_problem.forEach((element2) => {
          num2 += element2.number
        })
        num += (num2 * 100) / element.data().number
      })
      return Math.ceil(num / production.docs.length)
    }

    res.status(200).json({
      loss: loss(),
    })
  } catch (err) {
    return res.send(err)
  }
}
