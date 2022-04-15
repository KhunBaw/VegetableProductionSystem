const { db } = require('../../firebase')

exports.get = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const production = await db.collection('production').get()
    const vegetable = await db.collection('vegetable').get()
    const area = await db.collection('area').get()
    const fertilizer = await db.collection('fertilizer').get()
    const unit = await db.collection('unit').get()

    function f_vegetable() {
      let id = 0
      let f_data = []

      vegetable.forEach((element) => {
        f_data.push({
          id: ++id,
          v_name: element.data().v_name,
        })
      })
      return f_data
    }

    function f_production() {
      let id = 0
      let f_data = []
      const v_name = (data) => {
        let af_data = ''
        vegetable.forEach((element) => {
          if (data == element.id) {
            af_data = element.data().v_name
          }
        })
        return af_data
      }

      production.forEach((element) => {
        f_data.push({
          id: ++id,
          pd_id: element.data().pd_id,
          pd_d1: new Date(element.data().pd_d1).toLocaleDateString('th-TH'),
          pd_d2:
            element.data().pd_d2 != ''
              ? new Date(element.data().pd_d2).toLocaleDateString('th-TH')
              : '',
          pd_d3:
            element.data().pd_d3 != ''
              ? new Date(element.data().pd_d3).toLocaleDateString('th-TH')
              : '',
          number: element.data().number,
          v_name: v_name(element.data().v_id),
        })
      })

      return f_data
    }

    const f_area = (data) => {
      let af_data = []
      if (data === null) return af_data
      data.forEach((element) => {
        area.forEach((element2) => {
          if (element == element2.id) {
            af_data.push(element2.data().area_name)
          }
        })
      })

      return af_data
    }

    const f_area2 = (data1) => {
      let af_data = ''
      area.forEach((element2) => {
        if (data1 == element2.id) {
          af_data = element2.data().area_name
        }
      })

      return af_data
    }

    function f_take() {
      let id = 0
      let f_data = []

      const f_fertilizer = (data) => {
        let af_data = {}
        if (data === null) return af_data

        const fertilizer_id = (data1) => {
          let af_data = ''
          fertilizer.forEach((element) => {
            if (data1 == element.id) {
              af_data = element.data().fertilizer_type
            }
          })
          return af_data
        }

        const units = (id) => {
          let data1 = ''
          if (id === null) return data1
          if (id != '') {
            unit.forEach((element) => {
              if (element.id == id) {
                data1 = element
              }
            })
          }

          return data1.data()
        }

        af_data = {
          fertilizer_type:
            data.fertilizer_type != ''
              ? data.fertilizer_type
              : fertilizer_id(data.fertilizer_id),
          take_volume: data.take_volume,
          unit: units(data.unit_id),
        }

        return af_data
      }

      const units = (id) => {
        let data1
        if (id === null) return data1

        if (id != '') {
          unit.forEach((element) => {
            if (element.id == id) {
              data1 = element.data()
            }
          })
        }

        return data1
      }

      production.forEach((element) => {
        element.data().take.forEach((element2) => {
          f_data.push({
            area: f_area(element.data().area_id),
            fertilizer: f_fertilizer(element2.fertilizer),
            pd_id: element.data().pd_id,
            take_date: new Date(element2.take_date),
            take_volume: element2.take_volume,
            unit: units(element2.unit_id),
          })
        })
      })

      f_data.sort(function (a, b) {
        if (new Date(a.take_date) < new Date(b.take_date)) return -1
        else if (new Date(a.take_date) > new Date(b.take_date)) return 1
        else return 0
      })

      for (let index = 0; index < f_data.length; index++) {
        f_data[index].take_date = new Date(
          f_data[index].take_date
        ).toLocaleDateString('th-TH')
      }

      return f_data
    }

    function f_keep_problem() {
      let data1 = []
      production.forEach((element) => {
        element.data().keep_problem.forEach((element2) => {
          data1.push({
            pd_id: element.id,
            area: f_area2(element2.area_id),
            date: new Date(element2.problem_date),
            problems_data: element2.problems_data,
            solving_data: element2.solving_data,
          })
        })
      })

      data1.sort(function (a, b) {
        if (new Date(a.date) < new Date(b.date)) return -1
        else if (new Date(a.date) > new Date(b.date)) return 1
        else return 0
      })
      for (let index = 0; index < data1.length; index++) {
        data1[index].date = new Date(data1[index].date).toLocaleDateString(
          'th-TH'
        )
      }
      return data1
    }

    var data = {
      vegetable: f_vegetable(),
      production: f_production(),
      take: f_take(),
      keep_problem: f_keep_problem(),
    }

    res.status(200).json(data)
  } catch (err) {
    return res.send(err)
  }
}
