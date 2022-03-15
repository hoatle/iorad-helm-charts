const express = require('express')
const app = express()
const port = 3001

app.get('/healthz', (req, res) => {
  res.send('working!')
})

app.listen(port, () => {
  console.log(`iorad-dev webpack listening on port ${port}`)
})