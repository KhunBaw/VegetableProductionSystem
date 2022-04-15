const { db } = require('../../firebase')

exports.get = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')

  const vegetable = await db.collection('vegetable').get()

  const f_vegetable = (id) => {
    let v_name = ''

    vegetable.forEach((element) => {
      if (element.id == id) {
        v_name = element.data().v_name
      }
    })

    return v_name
  }

  try {
    const data = []
    await db
      .collection('area')
      .get()
      .then((datat) => {
        datat.docs.forEach((doc) => {
          data.push({
            area_id: doc.id,
            area_name: doc.data().area_name,
            area_lv: doc.data().area_lv,
            area_v_name: f_vegetable(doc.data().area_lv),
            area_long: doc.data().area_long,
            area_wide: doc.data().area_wide,
            area_photo: doc.data().area_photo,
            status: doc.data().status,
            area_detail: doc.data().area_detail,
          })
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
