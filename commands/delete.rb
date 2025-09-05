module Commands
  module Delete
    def self.register(bot)
      bot.application_command(:delete) do |event|
        begin
          event.defer

          amount = [[(event.options['amount'] || 1).to_i, 1].max, 100].min
          channel = event.options['channel'] ? bot.channel(event.options['channel']) : event.channel
          target_user_id = event.options['user']

          # 権限確認
          if event.server
            member = event.server.member(event.user.id)
            unless member&.permission?(:manage_messages)
              event.send_message(content: 'You do not have the Manage Messages permission.', ephemeral: true)
              next
            end
          end

          if event.server
            bot_member = event.server.member(bot.profile.id)
            unless bot_member&.permission?(:manage_messages)
              event.send_message(content: 'I do not have the Manage Messages permission.', ephemeral: true)
              next
            end
            unless bot_member&.permission?(:read_messages)
              event.send_message(content: 'I do not have the View Channel permission.', ephemeral: true)
              next
            end
            unless bot_member&.permission?(:read_message_history)
              event.send_message(content: 'I do not have the Read Message History permission.', ephemeral: true)
              next
            end
          end

          messages = channel.history(100).to_a
          messages.select! { |m| m.author&.id.to_s == target_user_id.to_s } if target_user_id
          to_delete = messages.first(amount)

          if to_delete.empty?
            event.send_message(content: 'No messages found to delete.', ephemeral: true)
            next
          end

          deleted_count = 0
          to_delete.each do |m|
            begin
              m.delete
              deleted_count += 1
              sleep 1
            rescue => e
              puts "Failed to delete message #{m.id}: #{e.message}"
            end
          end

          msg = "Deleted #{deleted_count} messages from #{channel.mention}."
          msg << " Some messages could not be deleted (probably older than 14 days)." if deleted_count < to_delete.size
          event.send_message(content: msg, ephemeral: true)

        rescue => e
          event.send_message(content: "An error occurred: #{e.message}", ephemeral: true)
        end
      end
    end
  end
end
