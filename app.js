const express = require('express');
const path = require('path');
const app = express();
const port = process.env.PORT || 3000;

// Serve static files from public/
app.use(express.static(path.join(__dirname, 'public')));

// /db-config route
app.get('/db-config', (req, res) => {
  res.send({
    host: process.env.DB_ENDPOINT,
    username: "Using securely loaded credentials"
  });
});

app.listen(port, () => {
  console.log(`App listening at http://localhost:${port}`);
});