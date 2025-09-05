require 'discordrb'
require 'dotenv/load'
require 'json'

intents = [:servers, :server_messages, :server_members]
$bot = Discordrb::Bot.new(
  token: ENV['DISCORD_BOT_TOKEN'],
  intents: intents
)

$bot.message(content: 'hello') do |event|
  event.channel.start_typing   # ◯◯が入力中...を表示するやつ
  member = event.server.member(event.user.id)
  display_name = member.display_name
  sleep 2
  event.respond "Hello, #{display_name}!!"
end

module Commands; end
Dir[File.join(__dir__, 'commands', '*.rb')].sort.each { |f| require f }

commands_data = JSON.parse(File.read(File.join(__dir__, 'commands.json')), symbolize_names: true)

def camelize(str)
  str.split('_').map(&:capitalize).join
end

$bot.ready do |_event|
  puts "Available handlers: #{Commands.constants}"
  puts "Ready! Logged in as #{$bot.profile.username}##{$bot.profile.discriminator}"

  token   = "Bot #{ENV['DISCORD_BOT_TOKEN']}"
  app_id  = ENV['DISCORD_APP_ID']
  guild_id = ENV['DISCORD_GUILD_ID']

  begin
    Discordrb::API::Application.bulk_overwrite_guild_commands(token, app_id, guild_id, commands_data)
    puts "Bulk registered #{commands_data.size} commands."
  rescue => e
    puts "Bulk registration failed: #{e.message}"
  end

  commands_data.each do |cmd|
    mod_name = camelize(cmd[:name])
    if Commands.const_defined?(mod_name)
      Commands.const_get(mod_name).register($bot)
      puts "Loaded handler for #{cmd[:name]}"
    else
      puts "Warning: No handler found for #{cmd[:name]}"
    end
  end
end
