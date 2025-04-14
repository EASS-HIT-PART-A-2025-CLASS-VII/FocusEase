const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

// Simple endpoint to test
app.get('/', (req, res) => {
  res.send('User Service is running!');
});

app.listen(port, () => {
  console.log(`User Service running on port ${port}`);
});
