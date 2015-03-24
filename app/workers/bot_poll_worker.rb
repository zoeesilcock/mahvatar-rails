require 'slack'
require 'slack_bot'

class BotPollWorker
  include Sidekiq::Worker

  def perform(*args)
    Room.active.each do |room|
      SlackBot.new(room).update_users
    end
  end
end
