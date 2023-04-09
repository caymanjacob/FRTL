# FRTL.ai
Farming Responsibly Through Limitation
A gpt-based predictor to evaluate how much fertilizer needs to go on a piece of land, to point out overfertilization

To integrate the GPT-4 API and FRTL's 2 servers follow these steps:

Make an HTML page based on the FRTL.ai website to host

```
htmlCopy code
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fertilizer Recommendation</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Fertilizer Recommendation for Farmers</h1>
    <form id="fertilizer-form">
        <label for="crop-type">Crop Type:</label>
        <input type="text" id="crop-type" name="crop-type" required>

        <label for="soil-type">Soil Type:</label>
        <input type="text" id="soil-type" name="soil-type" required>

        <label for="location">Location:</label>
        <input type="text" id="location" name="location" required>

        <button type="submit">Get Recommendation</button>
    </form>
    <div id="result"></div>
    <script src="script.js"></script>
</body>
</html>

```

1. Connect to the GPT-4 API: To interact with the GPT-4 API, you'll need to make a POST request from your JavaScript code. To ensure security and avoid exposing your API key on the client-side, you should create a backend server to handle the API request. You can use Node.js with Express, for example.

Install the required packages for your backend server:

```
bashCopy code
npm init
npm install express body-parser axios cors

```

Create a file named **`server.js`** and add the following code:

```
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

```

[data:image/svg+xml,%3csvg%20xmlns=%27http://www.w3.org/2000/svg%27%20version=%271.1%27%20width=%2730%27%20height=%2730%27/%3e](data:image/svg+xml,%3csvg%20xmlns=%27http://www.w3.org/2000/svg%27%20version=%271.1%27%20width=%2730%27%20height=%2730%27/%3e)

[https://chat.openai.com/_next/image?url=https%3A%2F%2Fs.gravatar.com%2Favatar%2Fe7eabee59c108633065a66aa013876a4%3Fs%3D480%26r%3Dpg%26d%3Dhttps%253A%252F%252Fcdn.auth0.com%252Favatars%252Fin.png&w=64&q=75](https://chat.openai.com/_next/image?url=https%3A%2F%2Fs.gravatar.com%2Favatar%2Fe7eabee59c108633065a66aa013876a4%3Fs%3D480%26r%3Dpg%26d%3Dhttps%253A%252F%252Fcdn.auth0.com%252Favatars%252Fin.png&w=64&q=75)

do this in julia instead of java, using as much julia as possible

To implement the same functionality in Julia, you can use the **`HTTP.jl`** and **`JSON3.jl`** packages. First, you'll need to install them:

```
bashCopy code
julia -e 'using Pkg; Pkg.add(["HTTP", "JSON3"])'

```

Next, create a file named **`server.jl`** and add the following code:

```
juliaCopy code
using HTTP
using JSON3

const API_KEY = "your_openai_api_key"
const API_URL = "https://api.openai.com/v1/engines/davinci-codex/completions"

function fetch_gpt4_recommendation(cropType, soilType, location)
    prompt = "How much fertilizer should be applied for crop \"$(cropType)\" in soil type \"$(soilType)\" and location \"$(location)\" to prevent overfertilization?"

    headers = [
        "Authorization" => "Bearer $(API_KEY)",
        "Content-Type" => "application/json"
    ]

    body = JSON3.write(Dict(
        "prompt" => prompt,
        "max_tokens" => 50,
        "n" => 1,
        "stop" => nothing,
        "temperature" => 0.5
    ))

    response = HTTP.post(API_URL, headers, body)
    parsed_response = JSON3.read(response.body, Dict)

    recommendation = strip(parsed_response["choices"][1]["text"])
    return recommendation
end

router = HTTP.Router()

HTTP.@register(router, "POST", "/api/gpt-4") do request::HTTP.Request
    request_data = JSON3.read(IOBuffer(request.body), Dict)
    cropType = request_data["cropType"]
    soilType = request_data["soilType"]
    location = request_data["location"]

    try
        recommendation = fetch_gpt4_recommendation(cropType, soilType, location)
        return HTTP.Response(200, JSON3.write(Dict("recommendation" => recommendation)))
    catch e
        return HTTP.Response(500, JSON3.write(Dict("error" => "Error retrieving data from GPT-4 API")))
    end
end

server = HTTP.Server(router)

HTTP.serve(server, "0.0.0.0", 8000)

```

To run the server, execute the following command:

```
bashCopy code
julia server.jl

```

Now, the server will be listening for requests at **`http://localhost:8000`**. You can adapt the previous HTML and JavaScript code to make a request to this new Julia server. Change the **`fetch`** function call in the **`script.js`** file:

```
javascriptCopy code
fetch('/api/gpt-4', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json'
    },
    body: JSON.stringify({ cropType, soilType, location })
})

```

By following these steps, you will have implemented a simple website that connects to a GPT-4 API using a Julia backend server to prevent overfertilization for specific crops.
