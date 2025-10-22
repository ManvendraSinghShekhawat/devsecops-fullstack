const express = require('express');
const fetch = require('node-fetch');
const app = express();
const API_URL = process.env.API_URL || 'http://api:5000';

app.get('/', async (req, res) => {
  try {
    const r = await fetch(API_URL);
    const j = await r.json();
    res.send(`<h1>Frontend</h1><p>API says: ${j.message}</p>`);
  } catch (e) {
    res.send('<h1>Frontend</h1><p>API unreachable</p>');
  }
});

app.listen(80, () => console.log('Frontend listening on 80'));

