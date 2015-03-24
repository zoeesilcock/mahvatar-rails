class RoomsController < ApplicationController
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

  private

  def room_params
    params.require(:room).permit(:title)
  end
end
