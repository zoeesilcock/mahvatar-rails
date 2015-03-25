class RoomsController < ApplicationController
  layout 'game', only: :show

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find params[:id]
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new room_params

    if @room.save
      redirect_to :rooms
    else
      render :new
    end
  end

  def edit
    @room = Room.find params[:id]
  end

  def update
    @room = Room.find params[:id]

    if @room.update_attributes room_params
      redirect_to :rooms
    else
      render :edit
    end
  end

  def destroy
    room = Room.find params[:id]
    room.destroy

    redirect_to :rooms
  end

  def start
    room = Room.find params[:room_id]

    room.active = !room.active
    room.save

    bot = SlackBot.new(room)
    room.active ? bot.start : bot.stop

    redirect_to edit_room_path(room)
  end

  private

  def room_params
    params.require(:room).permit(:title, :channel)
  end
end
