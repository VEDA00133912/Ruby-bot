module Commands
  module GosenChoyen
    API_URL = 'https://gsapi.cbrx.io/image'

    def self.register(bot)
      bot.register_application_command(:gosenchoyen, 'Generate a 5000 trillion yen meme image') do |cmd|
        cmd.string('top', 'Text to display at the top', required: true)
        cmd.string('bottom', 'Text to display at the bottom', required: true)
      end

      bot.application_command(:gosenchoyen) do |event|
        top = event.options['top']
        bottom = event.options['bottom']

        image_url = "#{API_URL}?top=#{URI.encode_www_form_component(top)}&bottom=#{URI.encode_www_form_component(bottom)}&type=png"

        embed = Discordrb::Webhooks::Embed.new(
          image: { url: image_url },
          color: 0x1ABC9C
        )

        event.respond(embeds: [embed])
      end
    end
  end
end
