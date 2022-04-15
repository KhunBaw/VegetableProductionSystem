const { db,bucket } = require('../../firebase')

exports.post = async function (req, res) {
  try {
    if (!req.file) {
      return res.status(400).send('Error: No files found')
    }

    const fileName = `${req.file.originalname}`
    const blob = bucket.file(fileName)

    const blobWriter = blob.createWriteStream({
      metadata: {
        contentType: req.file.mimetype,
      },
    })

    blobWriter.on('error', (err) => {
      console.log(err)
    })

    blobWriter.on('finish', (finish) => {
      const date1 = new Date()
      date1.setDate(date1.getDate() + 365)

      blob
        .getSignedUrl({
          action: 'read',
          expires: date1.toLocaleDateString('en-US'),
        })
        .then((signedUrls) => {
          res.status(200).send(signedUrls[0])
        })
        .catch((err) => {
          res.status(404).send(err)
        })
    })

    blobWriter.end(req.file.buffer)
  } catch (err) {
    return res.send(err)
  }
}

// exports.get = async function (req, res) {
//   try {
//     const file = bucket.file(req.params.id)

//     const date1 = new Date()
//     date1.setDate(date1.getDate() + 90)

//     file
//       .getSignedUrl({
//         action: 'read',
//         expires: date1.toLocaleDateString('en-US'),
//       })
//       .then((signedUrls) => {
//         res.status(200).send(signedUrls[0])
//       })
//       .catch((err) => {
//         res.status(404).send(err)
//       })
//   } catch (err) {
//     return res.status(404).send(err)
//   }
// }

// exports.getps = async function (req, res) {
//   res.setHeader('Content-Type', 'application/json')
//   const id = req.params.id

//   try {
//     //const data = [];
//     const doc = await db.collection('photo').doc(id).get()
//     if (!doc.exists) {
//       console.log('No such document!')
//     } else {
//       res.status(200).json(doc.data())
//     }
//   } catch (err) {
//     return res.send(err)
//   }
// }

// exports.put = async function (req, res) {
//   res.setHeader('Content-Type', 'application/json')
//   const id = req.params.id

//   try {
//     await db.collection('problems').doc(id).update({
//       ph_d1: req.body.ph_d1,
//       ph_d2: req.body.ph_d2,
//       ph_d3: req.body.ph_d3,
//     })

//     res.send(id)
//   } catch (err) {
//     return res.send(err)
//   }
// }
