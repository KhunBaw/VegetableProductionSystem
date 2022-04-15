const admin = require('firebase-admin')

// Initialize firebase admin SDK
admin.initializeApp({
  credential: admin.credential.cert('./path/serviceAccountKey.json'),
  storageBucket: 'project-end-e92b5.appspot.com',
})
// Cloud storage
exports.bucket = admin.storage().bucket()
exports.db = admin.firestore()

