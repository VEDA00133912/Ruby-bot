require 'discordrb'
require 'dotenv/load'

intents = [:servers, :server_messages]

bot = Discordrb::Bot.new token: ENV['DISCORD_BOT_TOKEN'], intents: intents

bot.message(content: 'hello') do |event|
  member = event.server.member(event.user.id)
  display_name = member.display_name
  event.respond "Hello, #{display_name}!!" # 文字列リテラルとかは"を使うらしい。'だと想定通りに動かん
end

bot.ready do |event|
  puts "Ready! Logged in as #{bot.profile.username}##{bot.profile.discriminator}"
end

bot.run
