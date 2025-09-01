module Commands
  module Hello
    def self.register(bot)
      bot.register_application_command(:hello, 'hello!') do |cmd|
      end

      bot.application_command(:hello) do |event|
        member = event.server.member(event.user.id)
        display_name = member.display_name
        event.respond(content: "Hello, #{display_name}!!")
      end
    end
  end
end
