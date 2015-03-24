require 'slack'
require 'slack_bot'

class BotPollWorker
  include Sidekiq::Worker

  def perform(*args)
    Room.active.each do |room|
      SlackBot.new.update_users(room)
    end
  end
end
