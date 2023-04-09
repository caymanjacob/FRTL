javascriptCopy code
const express = require('express');
const bodyParser = require('body-parser');
const axios = require('axios');
const cors = require('cors');

const app = express();
app.use(bodyParser.json());
app.use(cors());

const API_KEY = 'your_openai_api_key';
const API_URL = 'https://api.openai.com/v1/engines/davinci-codex/completions';

app.post('/api/gpt-4', async (req, res) => {
    const { cropType, soilType, location } = req.body;
    const prompt = `How much fertilizer should be applied for crop "${cropType}" in soil type "${soilType}" and location "${location}" to prevent overfertilization?`;

    try {
        const response = await axios.post(API_URL, {
            prompt,
            max_tokens: 50,
            n: 1,
            stop: null,
            temperature: 0.5,
        }, {
            headers: {
                'Authorization': `Bearer ${API_KEY}`,
                'Content-Type': 'application/json',
            }
        });

        const recommendation = response.data.choices[0].text.trim();
        res.json({ recommendation });
    } catch (error) {
        res.status(500).json({ error: 'Error retrieving data from GPT-4 API' });
    }
});

const PORT = process
