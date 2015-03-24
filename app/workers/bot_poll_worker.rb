require 'slack'

class BotPollWorker
  include Sidekiq::Worker

  def perform(*args)
    Room.active.each do |room|
      Slack.configure do |config|
        config.token = ENV['SLACK_API_TOKEN']
      end

      channels_data = Slack.channels_list

      channels_data['channels'].each do |channel|
        if channel['name'] == room.channel
          channel_data = Slack.channels_info channel: channel['id']

          channel_data['channel']['members'].each do |user_id|
            user_data = Slack.users_info user: user_id
            presence_data = Slack.users_getPresence user: user_id

            Rails.logger.info user_id
            Rails.logger.info user_data['user']['name']
            Rails.logger.info presence_data['presence']
          end
        end
      end
    end
  end
end
