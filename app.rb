require 'sinatra'
require_relative 'bot'

configure do
  set :bind, '0.0.0.0'
  set :port, ENV.fetch('PORT', 4567)
  set :environment, :production
  set :host_authorization, { permitted_hosts: [] }

  Thread.new do
    sleep 1
    puts "✅ Sinatra running at http://0.0.0.0:#{settings.port}"
    $bot.run
  end
end

get '/' do
  "Hello, world from Render!"
end
