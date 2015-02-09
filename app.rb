require 'bundler'
Bundler.require

require 'json'

Faye::WebSocket.load_adapter('thin')

get '/' do
  if Faye::WebSocket.websocket?(request.env)
    ws = Faye::WebSocket.new(request.env)

    ws.on(:open) do |event|
      puts 'On Open'
    end

    ws.on(:message) do |msg|
      parsed = JSON.parse(msg.data)
      p parsed
      ws.send(JSON.unparse parsed.reverse)
    end

    ws.on(:close) do |event|
      puts 'On Close'
    end

    ws.rack_response
  else
    erb :index
  end
end

