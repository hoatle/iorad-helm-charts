const express = require('express')
const app = express()
const port = 3000

app.get('/healthz', (req, res) => {
  res.send('working!')
})

app.listen(port, () => {
  console.log(`iorad-dev app listening on port ${port}`)
})