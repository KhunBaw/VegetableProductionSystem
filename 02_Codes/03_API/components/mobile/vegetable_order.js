const { db } = require('../../firebase')

exports.get = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')

  const vegetable = await db.collection('vegetable').get()
  const unit = await db.collection('unit').get()
  const order = await db.collection('order').get()

  const f_vegetable = (data) => {
    let f_data = []

    const ff_data = (v_id, data) => {
      let v = {}
      data.forEach((element) => {
        if (element.id == v_id) v = element.data()
      })
      return v
    }

    data.forEach((element) => {
      f_data.push({
        v_id: element.v_id,
        v_name: ff_data(element.v_id, vegetable).v_name,
        unit_eng: ff_data(element.unit_id, unit).unit_eng,
        weight: element.weight,
      })
    })
    return f_data
  }

  const f_order = (id) => {
    let f_data = {}
    order.forEach((element) => {
      if (element.id == id) {
        f_data = {
          name: element.data().od_name + ' ' + element.data().od_lname,
          address:
            element.data().od_address +
            ' ถ.' +
            element.data().od_road +
            ' ต.' +
            element.data().od_locality +
            ' อ.' +
            element.data().od_district +
            ' จ.' +
            element.data().od_province,
          phnum: element.data().od_phnum,
        }
      }
    })
    return f_data
  }

  try {
    const data = []

    await db
      .collection('vegetable_order')
      .where('status', '!=', 'success')
      .get()
      .then((datat) => {
        datat.docs.forEach((doc) => {
          data.push({
            order_id: doc.id,
            status: doc.data().status,
            date_final: new Date(doc.data().date_final).toLocaleDateString(
              'th-TH'
            ),
            vegetable: f_vegetable(doc.data().vegetable),
            od: f_order(doc.data().od_id),
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
