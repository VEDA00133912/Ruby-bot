require 'discordrb'
require 'dotenv/load'

Dir[File.join(__dir__, 'commands', '*.rb')].each do |file|
  require file
end

intents = [:servers, :server_messages]
bot = Discordrb::Bot.new(
  token: ENV['DISCORD_BOT_TOKEN'],
  intents: intents
)

bot.message(content: 'hello') do |event|
  member = event.server.member(event.user.id)
  display_name = member.display_name
  event.respond "Hello, #{display_name}!!"
end

bot.ready do |_event|
  puts "Ready! Logged in as #{bot.profile.username}##{bot.profile.discriminator}"

  Commands.constants.each do |const|
    mod = Commands.const_get(const)
    next unless mod.respond_to?(:register)

    mod.register(bot)
    puts "Registered command module: #{const}"
  end
end

bot.run