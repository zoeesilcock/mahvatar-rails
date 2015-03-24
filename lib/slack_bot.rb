class SlackBot
  def firebase
    firebase = Firebase::Client.new(ENV['FIREBASE_URL'])
  end

  def update_users(room)
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

          result = firebase.set "users/#{user_id}", { name: user_data['user']['name'], status: presence_data['presence'] }
        end
      end
    end
  end
end
