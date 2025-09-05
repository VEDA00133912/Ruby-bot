module Commands
  module Shutdown
    def self.register(bot)
      bot.application_command(:shutdown) do |event|
        owner_id = ENV['BOT_OWNER_ID']

        if event.user.id.to_s == owner_id
          event.respond(content: "Shutting down...", ephemeral: true)
          puts "Shutdown command executed by #{event.user.distinct}"
          bot.stop
        else
          event.respond(content: "You don't have permission to shut me down.", ephemeral: true)
        end
      end
    end
  end
end
