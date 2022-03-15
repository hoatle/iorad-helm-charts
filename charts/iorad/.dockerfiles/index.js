const express = require('express')
const app = express()
const port = 8080

app.get('/healthz', (req, res) => {
  res.send('working!')
})

app.listen(port, () => {
  console.log(`iorad app listening on port ${port}`)
})