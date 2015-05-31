class BotRealtimeWorker
  include Sidekiq::Worker

  def perform(room_id)
    room = Room.find room_id
    SlackBot.new(room).start_realtime
  end
end
