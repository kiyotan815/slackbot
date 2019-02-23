require 'http'
require 'json'
require 'eventmachine'
require 'faye/websocket'


response = HTTP.post("https://slack.com/api/rtm.start", params: {
    token: ENV['SLACK_API_TOKEN']
  })

rc = JSON.parse(response.body)

url = rc['url']


EM.run do
  # boot Web Socket instance
  ws = Faye::WebSocket::Client.new(url)

  #  success connect process
  ws.on :open do
    p [:open]
  end

  # RTM API from data
  ws.on :message do |event|
    data = JSON.parse(event.data)
    if data['type'] == "message" && data['text'] == "千葉滋賀佐賀"
      ws.send({
        type: "message",
        text: "イバールルルァキィー",
        channel: data['channel']
      }.to_json)
    end
    p data
  end

  # disconnect process
  ws.on :close do
    p [:close, event.code]
    ws = nil
    EM.stop
  end
end
