module Commands
  module Ping
    def self.register(bot)
      bot.register_application_command(:ping, 'ping!') do |cmd|
      end

      bot.application_command(:ping) do |event|
        event.respond(content: 'pong!')
      end
    end
  end
end
