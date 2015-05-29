require 'slack'

class SlackBot
  def initialize(room)
    @room = room

    Slack.configure do |config|
      config.token = ENV['SLACK_API_TOKEN']
    end
  end

  def firebase
    firebase = Firebase::Client.new(ENV['FIREBASE_URL'])
  end

  def start
    Rails.logger.info 'start bot'

    find_channel_id

    Slack.users_setPresence presence: 'auto'
    # Slack.chat_postMessage channel: @room.channel_id, text: "At your service."
  end

  def stop
    Rails.logger.info 'stop bot'

    Slack.users_setPresence presence: 'away'
  end

  def find_channel_id
    channels_data = Slack.channels_list

    channels_data['channels'].each do |channel|
      if channel['name'] == @room.channel
        Rails.logger.info 'found channel!'
        @room.channel_id = channel['id']
        @room.save
      end
    end
  end

  def update_users
    channel_data = Slack.channels_info channel: @room.channel_id

    channel_data['channel']['members'].each do |user_id|
      user_data = Slack.users_info user: user_id
      presence_data = Slack.users_getPresence user: user_id

      user = create_or_find_user(user_data)
      result = firebase.set "users/#{user_id}", {
        name: user.name,
        status: presence_data['presence'],
        head: user.head.url == 'default_head.png' ? '' : user.head.url
      }
    end
  end

  def create_or_find_user(user_data)
    user = User.find_by_identifier(user_data['user']['id'])

    unless user
      user = User.create(identifier: user_data['user']['id'], name: user_data['user']['name'])
      user.save
    end

    user
  end
end
