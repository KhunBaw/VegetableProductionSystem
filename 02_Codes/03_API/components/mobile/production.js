const { db, bucket } = require('../../firebase')

exports.get = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  console.log('ข้อมูลการผลิต')
  const vegetable = await db.collection('vegetable').get()
  const area = await db.collection('area').get()

  const pd_d = (d2, d3) => {
    if (d3 != '') {
      return 3
    } else if (d2 != '') {
      return 2
    } else return 1
  }

  const c_d3 = (d1, v_id) => {
    let day = 0

    vegetable.forEach((element) => {
      if (element.id == v_id) {
        day = element.data().v_d1 + element.data().v_d2 + element.data().v_d3
      }
    })

    const date1 = new Date(d1)
    date1.setDate(date1.getDate() + day)
    return date1.toLocaleDateString('th-TH')
  }

  const v_name = (v_id) => {
    let name = ''
    vegetable.forEach((element) => {
      if (element.id == v_id) {
        name = element.data().v_name
      }
    })
    return name
  }

  const weight = (v_id, number) => {
    let weight = 0
    vegetable.forEach((element) => {
      if (element.id == v_id) {
        weight = element.data().v_nfv * number
      }
    })

    return weight / 1000
  }

  const f_area = (area_id) => {
    let name = []
    area_id.forEach((element) => {
      area.forEach((element2) => {
        if (element2.id == element) {
          name.push({
            area_id: element2.data().area_id,
            area_name: element2.data().area_name,
            area_detail: element2.data().area_detail,
          })
        }
      })
    })

    return name
  }

  const f_vegetable = () => {
    const data = []
    vegetable.forEach((doc) => {
      data.push(doc.data())
    })
    return data
  }

  try {
    const data = []
    await db
      .collection('production')
      .where('status', '!=', 'success')
      .get()
      .then((datat) => {
        datat.docs.forEach((doc) => {
          data.push({
            pd_id: doc.id,
            order_id: doc.data().order_id,
            pd_d: pd_d(doc.data().pd_d2, doc.data().pd_d3),
            pd_d1: new Date(doc.data().pd_d1).toLocaleDateString('th-TH'),
            c_d3: c_d3(doc.data().pd_d1, doc.data().v_id),
            v_name: v_name(doc.data().v_id),
            number: doc.data().number,
            weight: weight(doc.data().v_id, doc.data().number),
            area_id: doc.data().area_id,
            area: f_area(doc.data().area_id),
          })
        })
        res.status(200).json({ data_body: data, vegetable: f_vegetable() })
      })
      .catch((err) => {
        res.status(400).json(err)
      })
    //console.log(data);
  } catch (err) {
    return res.status(500).send(err)
  }
}

exports.post = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  try {
    const dataid = Date.now().toString()
    await db
      .collection('production')
      .doc(dataid)
      .set({
        pd_id: dataid,
        pd_d1: new Date().toLocaleDateString('en-US'),
        pd_d2: '',
        pd_d3: '',
        v_id: req.body.v_id,
        area_id: req.body.area_id,
        order_id: req.body.order_id,
        number: Number(req.body.number),
        status: '',
        photo: {
          ph_d1: '',
          ph_d2: '',
          ph_d3: '',
        },
        keep_problem: [],
        take: [],
      })
      .then(() => {
        req.body.area_id.forEach(async (element) => {
          await db.collection('area').doc(element).update({
            status: true,
            area_lv: req.body.v_id,
          })
        })

        if (req.body.order_id[0] != 'ไม่มีคำสั่งซื้อ') {
          req.body.order_id.forEach(async (element) => {
            await db.collection('vegetable_order').doc(element).update({
              status: 'progress',
            })
          })
        }

        res.status(200).send('สำเร็จ')
      })
      .catch(() => {
        res.status(400)
      })
  } catch (err) {
    return res.send(err)
  }
}

exports.postProblem = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  try {
    const production = await db
      .collection('production')
      .doc(req.params.id)
      .get()

    const f_production = () => {
      const data = production.data().keep_problem
      data.push({
        fm_id: req.body.fm_id,
        problem_date: req.body.problem_date,
        problems_data: req.body.problems_data,
        solving_data: req.body.solving_data,
        area_id: req.body.area_id,
        number: req.body.number,
      })
      return data
    }

    await db
      .collection('production')
      .doc(req.params.id)
      .update({
        keep_problem: f_production(),
      })
      .then(() => {
        res.status(200).send('สำเร็จ')
      })
      .catch(() => {
        res.status(400).send('ผิดพลาด')
      })
  } catch (err) {
    return res.send(err)
  }
}

exports.putProblem = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  try {
    const production = await db
      .collection('production')
      .doc(req.params.id)
      .get()

    const f_production = () => {
      const data = production.data().keep_problem

      data[req.query.index] = {
        fm_id: req.body.fm_id,
        problem_date: req.body.problem_date,
        problems_data: req.body.problems_data,
        solving_data: req.body.solving_data,
        area_id: req.body.area_id,
        number: req.body.number,
      }

      return data
    }

    await db
      .collection('production')
      .doc(req.params.id)
      .update({
        keep_problem: f_production(),
      })
      .then(() => {
        res.status(200).send('สำเร็จ')
      })
      .catch(() => {
        res.status(400).send('ผิดพลาด')
      })

    res.status(200).send('สำเร็จ')
  } catch (err) {
    return res.send(err)
  }
}

exports.getPT = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  console.log('getDataPT')
  try {
    const data = []
    const fertilizers = await db.collection('fertilizer').get()
    const unit = await db.collection('unit').get()
    const vegetables = await db.collection('vegetable').get()

    data_f = (data_f) => {
      let vegetable = vegetables.docs
        .find((element) => element.id == data_f.v_id)
        .data()
      var date = new Date()

      const f_unit = (id) => {
        let data_unit = ''
        unit.forEach((element) => {
          if (element.id == id) {
            data_unit = element.data().unit_eng
          }
        })
        return data_unit
      }

      if (data_f.pd_d2 != '') {
        var p = new Date(data_f.pd_d2)
        p.setDate(p.getDate() + vegetable.v_d2 + vegetable.v_d3)

        fertilizers.docs.forEach((element) => {
          var f = new Date(data_f.pd_d2)
          f.setDate(f.getDate() + element.data().num_first)

          let data_v_f = vegetable.v_fertilizer.find(
            (v_ferilizer) => v_ferilizer.fertilizer_id == element.id
          )
          let data_take = data_f.take.filter(
            (take) => take.fertilizer.fertilizer_id == element.id
          )
          data_take.sort(function (a, b) {
            return new Date(a.take_date) - new Date(b.take_date)
          })
          if (data_take.length == 0 && !data_v_f) {
            let fd = new Date(data_f.pd_d2)
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
                data.push({
                  fertilizer_id: element.data().fertilizer_id,
                  fertilizer_type: element.data().fertilizer_type,
                  type: 'take_a',
                  date: f,
                  time: fertilizer_at.time,
                  amount:
                    fertilizer_at.fertilizer_amount * data_f.area_id.length,
                  unit_id: fertilizer_at.unit_id,
                  unit_eng: f_unit(fertilizer_at.unit_id),
                })
              })
          } else if (data_take.length > 0 && !data_v_f) {
            var d = new Date(data_take[data_take.length - 1].take_date)
            d.setDate(d.getDate() + element.data().day_times)

            let fd = new Date(data_f.pd_d2)
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
                data.push({
                  fertilizer_id: element.data().fertilizer_id,
                  fertilizer_type: element.data().fertilizer_type,
                  type: 'take_a',
                  date: d,
                  time: fertilizer_at.time,
                  amount:
                    fertilizer_at.fertilizer_amount * data_f.area_id.length,
                  unit_id: fertilizer_at.unit_id,
                  unit_eng: f_unit(fertilizer_at.unit_id),
                })
                console.log('asd')
              })
          } else if (data_take.length == 0 && data_v_f) {
            var d = new Date(data_f.pd_d2)
            d.setDate(d.getDate() + data_v_f.num_first)

            let fd = new Date(data_f.pd_d2)
            fd.setDate(
              fd.getDate() + vegetable.v_d2 + vegetable.v_d3 - data_v_f.num_pick
            )

            if (d < date) {
              d = date
            }
            if (fd >= d)
              data_v_f.fertilizer_at.forEach((fertilizer_at) => {
                data.push({
                  fertilizer_id: element.data().fertilizer_id,
                  fertilizer_type: element.data().fertilizer_type,
                  type: 'take_a',
                  date: d,
                  time: fertilizer_at.time,
                  amount:
                    fertilizer_at.fertilizer_amount * data_f.area_id.length,
                  unit_id: fertilizer_at.unit_id,
                  unit_eng: f_unit(fertilizer_at.unit_id),
                })
              })
          } else if (data_take.length > 0 && data_v_f) {
            var d = new Date(data_take[data_take.length - 1].take_date)
            d.setDate(d.getDate() + data_v_f.day_times)
            let fd = new Date(data_f.pd_d2)
            fd.setDate(
              fd.getDate() + vegetable.v_d2 + vegetable.v_d3 - data_v_f.num_pick
            )

            if (d < date) {
              d = date
            }
            if (fd >= d)
              data_v_f.fertilizer_at.forEach((fertilizer_at) => {
                data.push({
                  fertilizer_id: element.data().fertilizer_id,
                  fertilizer_type: element.data().fertilizer_type,
                  type: 'take_a',
                  date: d,
                  time: fertilizer_at.time,
                  amount:
                    fertilizer_at.fertilizer_amount * data_f.area_id.length,
                  unit_id: fertilizer_at.unit_id,
                  unit_eng: f_unit(fertilizer_at.unit_id),
                })
              })
          }
        })

        let v_fertilizer = vegetable.v_fertilizer.filter(
          (v_fertilizer) => v_fertilizer.fertilizer_type != ''
        )

        v_fertilizer.forEach((element) => {
          let data_take = data_f.take.filter(
            (take) => take.fertilizer.fertilizer_type == element.fertilizer_type
          )

          data_take.sort(function (a, b) {
            return new Date(a.take_date) - new Date(b.take_date)
          })

          if (data_take.length == 0) {
            var d = new Date(data_f.pd_d2)
            d.setDate(d.getDate() + element.num_first)

            let fd = new Date(data_f.pd_d2)
            fd.setDate(
              fd.getDate() + vegetable.v_d2 + vegetable.v_d3 - element.num_pick
            )

            if (d < date) {
              d = date
            }
            if (fd >= d)
              element.fertilizer_at.forEach((fertilizer_at) => {
                data.push({
                  fertilizer_id: element.fertilizer_id,
                  fertilizer_type: element.fertilizer_type,
                  type: 'take_a',
                  date: d,
                  time: fertilizer_at.time,
                  amount:
                    fertilizer_at.fertilizer_amount * data_f.area_id.length,
                  unit_id: fertilizer_at.unit_id,
                  unit_eng: f_unit(fertilizer_at.unit_id),
                })
              })
          } else if (data_take.length > 0) {
            var d = new Date(data_take[data_take.length - 1].take_date)
            d.setDate(d.getDate() + element.day_times)
            let fd = new Date(data_f.pd_d2)
            fd.setDate(
              fd.getDate() + vegetable.v_d2 + vegetable.v_d3 - element.num_pick
            )

            if (d < date) {
              d = date
            }
            if (fd >= d)
              element.fertilizer_at.forEach((fertilizer_at) => {
                data.push({
                  fertilizer_id: element.fertilizer_id,
                  fertilizer_type: element.fertilizer_type,
                  type: 'take_a',
                  date: d,
                  time: fertilizer_at.time,
                  amount:
                    fertilizer_at.fertilizer_amount * data_f.area_id.length,
                  unit_id: fertilizer_at.unit_id,
                  unit_eng: f_unit(fertilizer_at.unit_id),
                })
              })
          }
        })
      }
    }

    const pd_f = (v, d, d1, d2) => {
      let date
      vegetables.forEach((element) => {
        if (element.id == v) {
          if (d == 2) {
            date = new Date(d1)
            date.setDate(date.getDate() + element.data().v_d1)
          } else {
            date = new Date(d2)
            date.setDate(
              date.getDate() + element.data().v_d2 + element.data().v_d3
            )
          }
        }
      })

      return date > new Date() ? date : new Date()
    }

    await db
      .collection('production')
      .doc(req.params.id)
      .get()
      .then((data_body) => {
        if (data_body.data().pd_d1 != '')
          data.push({
            data: 'เพาะเมล็ด',
            date: data_body.data().pd_d1,
            type: 'pd1',
            photo: data_body.data().photo.ph_d1,
          })
        if (data_body.data().pd_d2 != '') {
          data.push({
            data: 'ย้ายลงแปลงปลูก',
            date: data_body.data().pd_d2,
            type: 'pd2',
            photo: data_body.data().photo.ph_d2,
          })
        } else {
          data.push({
            data: 'ย้ายลงแปลงปลูก',
            date: pd_f(
              data_body.data().v_id,
              2,
              data_body.data().pd_d1,
              data_body.data().pd_d2
            ),
            type: 'pd2_f',
          })
        }

        if (data_body.data().pd_d3 != '') {
          data.push({
            data: 'เก็บเกียว',
            date: data_body.data().pd_d3,
            type: 'pd3',
            photo: data_body.data().photo.ph_d3,
          })
        } else if (data_body.data().pd_d2 != '') {
          data.push({
            data: 'เก็บเกียว',
            date: pd_f(
              data_body.data().v_id,
              3,
              data_body.data().pd_d1,
              data_body.data().pd_d2
            ),
            type: 'pd3_f',
          })
        }

        const f_fertilizer = (data) => {
          let f_data = {}

          const f_unit = (id) => {
            let data_unit = ''
            unit.forEach((element) => {
              if (element.id == id) {
                data_unit = element.data().unit_eng
              }
            })
            return data_unit
          }

          fertilizers.forEach((element) => {
            if (element.id == data.fertilizer_id) {
              f_data = {
                fertilizer_id: data.fertilizer_id,
                fertilizer_type: element.data().fertilizer_type,
                take_volume: data.take_volume,
                unit_id: data.unit_id,
                unit_eng: f_unit(data.unit_id),
              }
            }
          })

          return f_data
        }

        data_body.data().take.forEach((element) => {
          data.push({
            area_id: element.area_id,
            fertilizer: f_fertilizer(element.fertilizer),
            fm_id: element.fm_id,
            date: element.take_date,
            type: 'take',
          })
        })

        let index = 0
        data_body.data().keep_problem.forEach((element) => {
          data.push({
            area_id: element.area_id,
            fm_id: element.fm_id,
            number: element.number,
            date: element.problem_date,
            problems_data: element.problems_data,
            solving_data: element.solving_data,
            type: 'problem',
            index: index++,
          })
        })

        data_f(data_body.data())

        data.sort(function (a, b) {
          return new Date(a.date) - new Date(b.date)
        })

        for (let index = 0; index < data.length; index++) {
          data[index].date = new Date(data[index].date).toLocaleDateString(
            'th-TH'
          )
        }

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

exports.postPH = async function (req, res) {
  if (
    !req.file &&
    (req.body.type == 'pd1' || req.body.type == 'pd2' || req.body.type == 'pd3')
  ) {
    return res.status(400).send('Error: No files found')
  }

  try {
    if (req.file) {
      const fileName = `${req.file.originalname}`
      var blob = bucket.file(fileName)
      var blobWriter = blob.createWriteStream({
        metadata: {
          contentType: req.file.mimetype,
        },
      })
    }

    if (
      req.body.type == 'pd1' ||
      req.body.type == 'pd2' ||
      req.body.type == 'pd3'
    ) {
      blobWriter.on('finish', (finish) => {
        const date1 = new Date()
        date1.setDate(date1.getDate() + 90)

        blob
          .getSignedUrl({
            action: 'read',
            expires: date1.toLocaleDateString('en-US'),
          })
          .then(async (signedUrls) => {
            let data = {}
            let productiong = await db
              .collection('production')
              .doc(req.params.id)
              .get()

            if (req.body.type == 'pd1') {
              data = {
                ph_d1: signedUrls[0],
                ph_d2: productiong.data().photo.ph_d2,
                ph_d3: productiong.data().photo.ph_d3,
              }
            }
            if (req.body.type == 'pd2') {
              data = {
                ph_d1: productiong.data().photo.ph_d1,
                ph_d2: signedUrls[0],
                ph_d3: productiong.data().photo.ph_d3,
              }
            }
            if (req.body.type == 'pd3') {
              data = {
                ph_d1: productiong.data().photo.ph_d1,
                ph_d2: productiong.data().photo.ph_d2,
                ph_d3: signedUrls[0],
              }
            }

            await db
              .collection('production')
              .doc(req.params.id)
              .update({
                photo: data,
              })
              .then(() => {
                res.status(200).send('สำเร็จ')
              })
              .catch(() => {
                res.status(400)
              })
            // res.status(200).send(signedUrls[0])
          })
          .catch((err) => {
            res.status(404).send(err)
          })
      })
    } else if (req.body.type == 'pd2_f' || req.body.type == 'pd3_f') {
      if (req.file) {
        blobWriter.on('finish', (finish) => {
          const date1 = new Date()
          date1.setDate(date1.getDate() + 90)

          blob
            .getSignedUrl({
              action: 'read',
              expires: date1.toLocaleDateString('en-US'),
            })
            .then(async (signedUrls) => {
              let data = {}
              let data2 = {}
              let productiong = await db
                .collection('production')
                .doc(req.params.id)
                .get()
              if (req.body.type == 'pd2_f') {
                data = {
                  ph_d1: productiong.data().photo.ph_d1,
                  ph_d2: signedUrls[0],
                  ph_d3: productiong.data().photo.ph_d3,
                }
                data2 = {
                  photo: data,
                  pd_d2: new Date().toLocaleDateString('en-US'),
                }
              }
              if (req.body.type == 'pd3_f') {
                data = {
                  ph_d1: productiong.data().photo.ph_d1,
                  ph_d2: productiong.data().photo.ph_d2,
                  ph_d3: signedUrls[0],
                }
                data2 = {
                  photo: data,
                  pd_d3: new Date().toLocaleDateString('en-US'),
                  status: 'success',
                }

                productiong.data().order_id.forEach(async (element) => {
                  await db.collection('vegetable_order').doc(element).update({
                    status: 'final',
                  })
                })
              }

              await db
                .collection('production')
                .doc(req.params.id)
                .update(data2)
                .then(() => {
                  res.status(200).send('สำเร็จ')
                })
                .catch(() => {
                  res.status(400).end
                })
              // res.status(200).send(signedUrls[0])
            })
            .catch((err) => {
              res.status(404).send(err)
            })
        })
      } else {
        const date1 = new Date()
        let data2 = {}
        if (req.body.type == 'pd2_f') {
          data2 = {
            pd_d2: date1.toLocaleDateString('en-US'),
          }
        }
        if (req.body.type == 'pd3_f') {
          data2 = {
            pd_d3: date1.toLocaleDateString('en-US'),
            status: 'success',
          }
          let productiong = await db
            .collection('production')
            .doc(req.params.id)
            .get()

          productiong.data().order_id.forEach(async (element) => {
            await db.collection('vegetable_order').doc(element).update({
              status: 'final',
            })
          })
        }

        await db
          .collection('production')
          .doc(req.params.id)
          .update(data2)
          .then(() => {
            blobWriter.end(req.file.buffer)
            return res.status(200).send('สำเร็จ')
          })
          .catch(() => {
            res.status(400).send('')
          })
      }
    }

    blobWriter.on('error', (err) => {
      console.log(err)
    })

    blobWriter.end(req.file.buffer)
  } catch (err) {
    return res.send(err)
  }
}

exports.getH = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  console.log('ข้อมูลการผลิตที่เสร็จแล้ว')
  const vegetable = await db.collection('vegetable').get()
  const area = await db.collection('area').get()

  const pd_d = (d2, d3) => {
    if (d3 != '') {
      return 3
    } else if (d2 != '') {
      return 2
    } else return 1
  }

  const c_d3 = (d1, v_id) => {
    let day = 0

    vegetable.forEach((element) => {
      if (element.id == v_id) {
        day = element.data().v_d1 + element.data().v_d2 + element.data().v_d3
      }
    })

    const date1 = new Date(d1)
    date1.setDate(date1.getDate() + day)
    return date1.toLocaleDateString('th-TH')
  }

  const v_name = (v_id) => {
    let name = ''
    vegetable.forEach((element) => {
      if (element.id == v_id) {
        name = element.data().v_name
      }
    })
    return name
  }

  const weight = (v_id, number) => {
    let weight = 0
    vegetable.forEach((element) => {
      if (element.id == v_id) {
        weight = element.data().v_nfv * number
      }
    })

    return weight / 1000
  }

  const f_area = (area_id) => {
    let name = []
    area_id.forEach((element) => {
      area.forEach((element2) => {
        if (element2.id == element) {
          name.push({
            area_id: element2.data().area_id,
            area_name: element2.data().area_name,
            area_detail: element2.data().area_detail
          })
        }
      })
    })

    return name
  }

  try {
    const data = []
    await db
      .collection('production')
      .where('status', '==', 'success')
      .get()
      .then((datat) => {
        datat.docs.forEach((doc) => {
          data.push({
            pd_id: doc.id,
            order_id: doc.data().order_id,
            pd_d: pd_d(doc.data().pd_d2, doc.data().pd_d3),
            pd_d1: new Date(doc.data().pd_d1).toLocaleDateString('th-TH'),
            c_d3: c_d3(doc.data().pd_d1, doc.data().v_id),
            v_name: v_name(doc.data().v_id),
            number: doc.data().number,
            weight: weight(doc.data().v_id, doc.data().number),
            area_id: doc.data().area_id,
            area: f_area(doc.data().area_id),
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

exports.postTake = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')
  try {
    const production = await db
      .collection('production')
      .doc(req.params.id)
      .get()

    const f_take = () => {
      const data = production.data().take
      data.push({
        fertilizer: {
          fertilizer_id: req.body.fertilizerId,
          fertilizer_type: req.body.fertilizerType,
          take_volume: req.body.take_volume,
          unit_id: req.body.unit_id
        },
        fm_id:req.body.fm_id,
        take_date: req.body.take_date,
      })
      return data
    }

    await db
      .collection('production')
      .doc(req.params.id)
      .update({
        take: f_take(),
      })
      .then(() => {
        res.status(200).send('สำเร็จ')
      })
      .catch(() => {
        res.status(400).send('ผิดพลาด')
      })
  } catch (err) {
    return res.send(err)
  }
}
