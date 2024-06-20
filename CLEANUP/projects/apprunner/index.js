const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('AppRunner is great!');
});

app.listen(port, () => {
  console.log(`NodeJS Application is listening at http://localhost:${port}`);
});
