module Commands
  module Infouser
    def self.register(bot)
      bot.register_application_command(:infouser, 'Get information about a user') do |cmd|
        cmd.user('user', 'The user to get info for', required: false)
      end

      bot.application_command(:infouser) do |event|
          # d.jsでいうDeferReply()
          event.defer()

          user = event.options['user'] ? event.server.member(event.options['user']) : event.user
          join_date = user.joined_at ? user.joined_at.strftime("%Y-%m-%d %H:%M:%S") : "Unknown"
          created_at = user.creation_time.strftime("%Y-%m-%d %H:%M:%S")
          
          # ユーザーの一番上のロールカラーをembedに適用する
          color = if user.roles.any?
                    user.roles.max_by(&:position).color
                  else
                    0x1ABC9C # デフォルトカラー
                  end

          roles = if user.roles.empty?
                    "None"
                  else
                    user.roles.sort_by(&:position).map { |r| "<@&#{r.id}>" }.join(" ")
                  end

          embed = Discordrb::Webhooks::Embed.new(
            title: "#{user.username}##{user.discriminator} Information",
            color: color
          )
          embed.add_field(name: 'Nickname', value: user.display_name)
          embed.add_field(name: 'ID', value: user.id)
          embed.add_field(name: 'Created At', value: created_at)
          embed.add_field(name: 'Joined At', value: join_date)
          embed.add_field(name: 'Roles', value: roles)
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: user.avatar_url)

          event.send_message(embeds: [embed]) # deferのを返すときはrespondじゃなくてsend_messageになるらしい
      end
    end
  end
end
