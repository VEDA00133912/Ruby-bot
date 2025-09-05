# commands/gosenchoyen.rb
require 'uri'

module Commands
  module Gosenchoyen
    API_URL = 'https://gsapi.cbrx.io/image'

    def self.register(bot)
      bot.application_command(:gosenchoyen) do |event|
        top = event.options['top']
        bottom = event.options['bottom']

        # API の画像 URL を組み立て
        image_url = "#{API_URL}?top=#{URI.encode_www_form_component(top)}&bottom=#{URI.encode_www_form_component(bottom)}&type=png"

        # Embed を作成
        embed = Discordrb::Webhooks::Embed.new(
          image: { url: image_url },
          color: 0x1ABC9C
        )

        event.respond(embeds: [embed])
      end
    end
  end
end
