const { db } = require('../../firebase')

exports.get = async function (req, res) {
  console.log('ข้อมูลแจ้งเตือน')
  res.setHeader('Content-Type', 'application/json')

  const vegetables = await db.collection('vegetable').get()
  const areas = await db.collection('area').get()
  const fertilizers = await db.collection('fertilizer').get()

  const datas = []
  var id_c = 0

  try {
    data_f = (data, id) => {
      let vegetable = vegetables.docs
        .find((element) => element.id == data.v_id)
        .data()
      var date = new Date()

      if (data.pd_d2 == '') {
        let pd_d1 = new Date(data.pd_d1)
        pd_d1.setDate(pd_d1.getDate() + vegetable.v_d1)

        if (pd_d1 < date) {
          pd_d1 = date
        }

        datas.push({
          id: id_c++,
          title: 'ย้ายผักลงแปลง',
          subtitle: 'หมายเลขการปลูก : ' + id,
          date: pd_d1.toLocaleDateString('fr-ca'),
          time: '10:00',
        })
      }

      if (data.pd_d3 == '' && data.pd_d2 != '') {
        let pd_d2
        if (data.pd_d2 == '') {
          let pd_d1 = new Date(data.pd_d1)
          pd_d1.setDate(pd_d1.getDate() + vegetable.v_d1)

          if (pd_d1 < date) {
            pd_d1 = date
          }
          pd_d2 = pd_d1
        } else {
          pd_d2 = new Date(data.pd_d2)
        }

        pd_d2.setDate(pd_d2.getDate() + vegetable.v_d2 + vegetable.v_d3)

        if (pd_d2 < date) {
          pd_d2 = date
        }

        datas.push({
          id: id_c++,
          title: 'พร้อมเก็บ',
          subtitle: 'หมายเลขการปลูก : ' + id,
          date: pd_d2.toLocaleDateString('fr-ca'),
          time: '10:00',
        })
      }

      if (data.pd_d2 != '') {
        var p = new Date(data.pd_d2)
        p.setDate(p.getDate() + vegetable.v_d2 + vegetable.v_d3)

        fertilizers.docs.forEach((element) => {
          var f = new Date(data.pd_d2)
          f.setDate(f.getDate() + element.data().num_first)

          let data_v_f = vegetable.v_fertilizer.find(
            (v_ferilizer) => v_ferilizer.fertilizer_id == element.id
          )
          let data_take = data.take.filter(
            (take) => take.fertilizer.fertilizer_id == element.id
          )
          data_take.sort(function (a, b) {
            return new Date(a.take_date) - new Date(b.take_date)
          })

          if (data_take.length == 0 && !data_v_f) {
            let fd = new Date(data.pd_d2)
            fd.setDate(
              fd.getDate() +
                vegetable.v_d2 +
                vegetable.v_d3 -
                element.data().num_pick
            )

            if (f < date) {
              f = date
            }

            if (fd >= f)
              element.data().fertilizer_at.forEach((fertilizer_at) => {
                datas.push({
                  id: id_c++,
                  title: 'ปุ๋ย: ' + element.data().fertilizer_type,
                  subtitle: 'หมายเลขการปลูก : ' + id,
                  date: f.toLocaleDateString('fr-ca'),
                  time: fertilizer_at.time,
                })
              })
          } else if (data_take.length > 0 && !data_v_f) {
            var d = new Date(data_take[data_take.length - 1].take_date)
            d.setDate(d.getDate() + element.data().day_times)

            let fd = new Date(data.pd_d2)
            fd.setDate(
              fd.getDate() +
                vegetable.v_d2 +
                vegetable.v_d3 -
                element.data().num_pick
            )

            if (d < date) {
              d = date
            }
            if (fd >= d)
              element.data().fertilizer_at.forEach((fertilizer_at) => {
                datas.push({
                  id: id_c++,
                  title: 'ปุ๋ย: ' + element.data().fertilizer_type,
                  subtitle: 'หมายเลขการปลูก : ' + id,
                  date: d.toLocaleDateString('fr-ca'),
                  time: fertilizer_at.time,
                })
              })
          } else if (data_take.length == 0 && data_v_f) {
            var d = new Date(data.pd_d2)
            d.setDate(d.getDate() + data_v_f.num_first)

            let fd = new Date(data.pd_d2)
            fd.setDate(
              fd.getDate() + vegetable.v_d2 + vegetable.v_d3 - data_v_f.num_pick
            )

            if (d < date) {
              d = date
            }
            if (fd >= d)
              data_v_f.fertilizer_at.forEach((fertilizer_at) => {
                datas.push({
                  id: id_c++,
                  title: 'ปุ๋ย: ' + element.data().fertilizer_type,
                  subtitle: 'หมายเลขการปลูก : ' + id,
                  date: d.toLocaleDateString('fr-ca'),
                  time: fertilizer_at.time,
                })
              })
          } else if (data_take.length > 0 && data_v_f) {
            var d = new Date(data_take[data_take.length - 1].take_date)
            d.setDate(d.getDate() + data_v_f.day_times)
            let fd = new Date(data.pd_d2)
            fd.setDate(
              fd.getDate() + vegetable.v_d2 + vegetable.v_d3 - data_v_f.num_pick
            )

            if (d < date) {
              d = date
            }
            if (fd >= d)
              data_v_f.fertilizer_at.forEach((fertilizer_at) => {
                datas.push({
                  id: id_c++,
                  title: 'ปุ๋ย: ' + element.data().fertilizer_type,
                  subtitle: 'หมายเลขการปลูก : ' + id,
                  date: d.toLocaleDateString('fr-ca'),
                  time: fertilizer_at.time,
                })
              })
          }
        })

        let v_fertilizer = vegetable.v_fertilizer.filter(
          (v_fertilizer) => v_fertilizer.fertilizer_type != ''
        )

        v_fertilizer.forEach((element) => {
          let data_take = data.take.filter(
            (take) => take.fertilizer.fertilizer_type == element.fertilizer_type
          )

          data_take.sort(function (a, b) {
            return new Date(a.take_date) - new Date(b.take_date)
          })

          if (data_take.length == 0) {
            var d = new Date(data.pd_d2)
            d.setDate(d.getDate() + element.num_first)

            let fd = new Date(data.pd_d2)
            fd.setDate(
              fd.getDate() + vegetable.v_d2 + vegetable.v_d3 - element.num_pick
            )

            if (d < date) {
              d = date
            }
            if (fd >= d)
              element.fertilizer_at.forEach((fertilizer_at) => {
                datas.push({
                  id: id_c++,
                  title: 'ปุ๋ย: ' + element.fertilizer_type,
                  subtitle: 'หมายเลขการปลูก : ' + id,
                  date: d.toLocaleDateString('fr-ca'),
                  time: fertilizer_at.time,
                })
              })
          } else if (data_take.length > 0) {
            var d = new Date(data_take[data_take.length - 1].take_date)
            d.setDate(d.getDate() + element.day_times)
            let fd = new Date(data.pd_d2)
            fd.setDate(
              fd.getDate() + vegetable.v_d2 + vegetable.v_d3 - element.num_pick
            )

            if (d < date) {
              d = date
            }
            if (fd >= d)
              element.fertilizer_at.forEach((fertilizer_at) => {
                datas.push({
                  id: id_c++,
                  title: 'ปุ๋ย: ' + element.fertilizer_type,
                  subtitle: 'หมายเลขการปลูก : ' + id,
                  date: d.toLocaleDateString('fr-ca'),
                  time: fertilizer_at.time,
                })
              })
          }
        })
      }
    }

    await db
      .collection('production')
      .where('status', '==', 'success')
      .get()
      .then((datat) => {
        datat.docs.forEach((element) => {
          element.data().area_id.forEach(async (area) => {
            let area_item = areas.docs.find((ar) => ar.data().area_id == area)

            let date = new Date(element.data().pd_d3)
            date.setDate(date.getDate() + area_item.data().area_rest_period)
            if (date <= new Date()) {
              await db
                .collection('area')
                .doc(area)
                .get()
                .then(async (data) => {
                  if (data.data().status != false) {
                    console.log('เปลียนสถานะพื้นที่ ' + area)
                    await db.collection('area').doc(area).update({
                      status: false,
                    })
                  }
                })
            }
          })
        })
      })

    await db
      .collection('production')
      .where('status', '!=', 'success')
      .get()
      .then((datat) => {
        datat.docs.forEach((doc) => {
          data_f(doc.data(), doc.id)
        })

        res.status(200).json(datas)
      })
      .catch((err) => {
        res.status(400).json(err)
      })
    //console.log(data);
  } catch (err) {
    return res.status(500).send(err)
  }
}
