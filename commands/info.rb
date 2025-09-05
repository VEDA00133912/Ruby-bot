module Commands
  module Info
    def self.register(bot)
      # /info のイベントハンドラ
      bot.application_command(:info) do |event|
        subcommand = event.subcommand_name
        case subcommand
        when 'user'
          event.defer(ephemeral: false)

          user = event.options['user'] ? bot.user(event.options['user']) : event.user
          member = event.server ? event.server.member(user.id) : nil
          join_date = member&.joined_at ? member.joined_at.strftime("%Y-%m-%d %H:%M:%S") : "Not in this server"
          created_at = user.creation_time.strftime("%Y-%m-%d %H:%M:%S")

          color = member&.roles&.any? ? member.roles.max_by(&:position).color : 0x1ABC9C
          roles = member&.roles&.empty? == false ? member.roles.sort_by(&:position).map { |r| "<@&#{r.id}>" }.join(" ") : "None"
          avatar_url = user.avatar_url || "https://cdn.discordapp.com/embed/avatars/0.png"

          embed = Discordrb::Webhooks::Embed.new(
            title: "#{member ? member.display_name : user.display_name} Information",
            color: color
          )
          embed.add_field(name: 'Username', value: "#{user.username}##{user.discriminator}")
          embed.add_field(name: 'ID', value: user.id)
          embed.add_field(name: 'Created At', value: created_at)
          embed.add_field(name: 'Joined At', value: join_date)
          embed.add_field(name: 'Roles', value: roles)
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: avatar_url)

          event.send_message(embeds: [embed])

        when 'server'
          event.defer(ephemeral: false)
          server = event.server
          next unless server

          created_at = server.creation_time.strftime("%Y-%m-%d %H:%M:%S")
          member_count = server.members.count
          role_count = server.roles.count
          channel_count = server.channels.count
          owner_mention = "<@#{server.owner.id}>"
          icon_url = server.icon_url || "https://cdn.discordapp.com/embed/avatars/0.png"

          embed = Discordrb::Webhooks::Embed.new(
            title: "#{server.name} Information",
            color: 0x7289DA
          )
          embed.add_field(name: 'Server ID', value: server.id)
          embed.add_field(name: 'Owner', value: owner_mention)
          embed.add_field(name: 'Created At', value: created_at)
          embed.add_field(name: 'Members', value: member_count)
          embed.add_field(name: 'Roles', value: role_count)
          embed.add_field(name: 'Channels', value: channel_count)
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: icon_url)

          event.send_message(embeds: [embed])
        end
      end
    end
  end
end
