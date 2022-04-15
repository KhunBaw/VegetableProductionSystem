const { db } = require('../../firebase')

exports.getid = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  try {
    const data = []
    const fertilizer = await db.collection('fertilizer').get()

    const take = (data) => {
      const fertilizer_name = []

      const F_fertilizer_name = (data1) => {
        let name = ''

        fertilizer.forEach((element) => {
          if (element.id == data1) {
            name = element.data().fertilizer_type
          }
        })

        return name
      }

      data.forEach((element) => {
        if (
          !fertilizer_name.includes(
            F_fertilizer_name(element.fertilizer.fertilizer_id)
          )
        ) {
          fertilizer_name.push({
            fertilizer_name: F_fertilizer_name(
              element.fertilizer.fertilizer_id
            ),
          })
        }
      })

      return fertilizer_name
    }

    await db
      .collection('production')
      .doc(req.params.id)
      .get()
      .then((data_body) => {
        data.push({
          state: 'เพาะเมล็ด',
          date1: new Date(data_body.data().pd_d1).toLocaleDateString('th-TH'),
          photo1: data_body.data().photo.ph_d1,

          state2: 'ย้ายผักลงแปลง',
          date2: new Date(data_body.data().pd_d2).toLocaleDateString('th-TH'),
          photo2: data_body.data().photo.ph_d2,

          take: take(data_body.data().take),

          state3: 'เก็บผัก',
          date3: new Date(data_body.data().pd_d3).toLocaleDateString('th-TH'),
          photo3: data_body.data().photo.ph_d3,
        })

        res.status(200).json(data)
      })
      .catch((err) => {
        res.status(400).json(err)
      })
    //console.log(data);
  } catch (err) {
    return res.status(500).send(err)
  }
}
