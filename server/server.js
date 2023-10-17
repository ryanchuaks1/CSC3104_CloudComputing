'use strict';

const express = require('express');

const PORT = 8080;
const HOST = '0.0.0.0';

const app = express();
app.get('/', (request, response) => {
    response.send('Hello, World!');
});

app.listen(PORT, HOST, () => {
    console.log('Server is running on http://${HOST}:${port}');
});