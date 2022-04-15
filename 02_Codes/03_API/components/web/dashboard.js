const { db } = require('../../firebase')

exports.get = async function (req, res) {
  res.setHeader('Content-Type', 'application/json')

  try {
    const production = await db.collection("production").get();
    const vegetable_order = await db.collection("vegetable_order").get();
    const area = await db.collection("area").get();

    const order = () => {
      let num = 0 
      vegetable_order.docs.forEach(element => {
        if (element.data().status != 'success') {
          num++;
        }
      });
      return num
    };
    const order_finish = () => {
      let num = 0 
      vegetable_order.docs.forEach(element => {
        if (element.data().status == 'success') {
          num++;
        } 
      });
      return num
    };

    const area_f = () => {
      let num = area.docs.length
      return num
    };
    const area_balance = () => {
      let num = 0 
      area.docs.forEach(element => {
        if (element.data().status == false) {
          num++;
        } 
      });
      return num
    };

    const current_vegetables = () => {
      let num = 0 
      production.docs.forEach(element => {

        if (element.data().status != 'success') {
          num += element.data().number
        }
        
      });
      return num
    };

    const current_vegetables_finish = () => {
      let num = 0 
      production.docs.forEach(element => {
        if (element.data().status=='success') {
          num += element.data().number
        }
        
      });
      return num
    };

    const loss = () => {
      let num = 0
      production.docs.forEach(element => {
        let num2 = 0;
        element.data().keep_problem.forEach(element2 => {
          num2 += element2.number
        });
        num += (num2*100)/element.data().number
      });
       return Math.ceil(num / production.docs.length)
    };

    const loss_all = () => {
      let num = 0 
      production.docs.forEach(element => {
        element.data().keep_problem.forEach(element2 => {
          num += element2.number
        });
      });
      return num
    };

    let data = {
      current_vegetables: current_vegetables(),
      current_vegetables_finish: current_vegetables_finish(),
      area: area_f(),
      area_balance: area_balance(),
      order: order(),
      order_finish: order_finish(),
      loss: loss(),
      loss_all: loss_all(),
    }

    //console.log(data);
    res.status(200).json(data)
  } catch (err) {
    return res.send(err)
  }
}
