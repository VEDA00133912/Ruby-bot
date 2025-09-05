module Commands
  module Avatar
    def self.register(bot)
      # ハンドラだけ登録（コマンド定義は commands.json 側で一括登録）
      bot.application_command(:avatar) do |event|
        user_id = event.options['user']
        user = user_id ? bot.user(user_id) : event.user

        # URL末尾にサイズ指定
        avatar_url = "#{user.avatar_url}?size=1280"

        embed = Discordrb::Webhooks::Embed.new(
          title: "#{user.username}'s Avatar",
          color: 0x1ABC9C,
          image: Discordrb::Webhooks::EmbedImage.new(url: avatar_url),
          footer: Discordrb::Webhooks::EmbedFooter.new(text: "Requested by #{event.user.username}")
        )

        event.respond(embeds: [embed])
      end
    end
  end
end
