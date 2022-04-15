const getTokenFrom = (request) => {
  const authorization = request.get('Authorization')
  if (authorization && authorization.toLowerCase().startsWith('bearer ')) {
    return authorization.substring(7)
  }
  return null
}

exports.sign = function (user, secretkey,expiresIn) {
  const jwt = require('jsonwebtoken')
  try {
    return jwt.sign(
      {
        username: user.username,
        fm_name: user.fm_name,
        fm_lname: user.fm_lname,
        role: user.role,
      },
      secretkey,
      { expiresIn: expiresIn }
    )
  } catch (e) {
    return res.status(401).send()
  }
}

exports.verify = function (req, res, next) {
  const jwt = require('jsonwebtoken')
  const secretkey = process.env.ENV_SECRET

  let accessToken = getTokenFrom(req)

  if (!accessToken) return res.status(403).send('กรุณา Login ครับ')

  try {
    jwt.verify(accessToken, secretkey, (err, authData) => {
      if (err) return res.status(401).send('กรุณา Login ครับ')
      next()
    })
  } catch (e) {
    return res.status(401).send()
  }
}
