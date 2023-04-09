juliaCopy code
using HTTP
using JSON3

const API_KEY = "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"
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
