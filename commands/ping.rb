module Commands
  module Ping
    def self.register(bot)
      bot.application_command(:ping) do |event|
        event.respond(content: 'pong!')
      end
    end
  end
end
