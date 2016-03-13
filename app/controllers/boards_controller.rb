class BoardsController < ApplicationController
  def index
    @boards = Board.all
  end

  def show
    @board  = Board.find(params[:id])
  end

  def new
  end

  def create
    @board = Board.new(params.require(:board).permit(:year, :start))

    @board.save
    redirect_to boards_path
  end

  def destroy
    terms = Term.where(board_id: params[:id])
    board = Board.find(params[:id])
    board.destroy

    # Destroy associated terms.
    terms.each do |t|
      # Destroy associated role.
      Role.find(t.role_id).destroy
      t.destroy
    end

    redirect_to boards_path
  end
end
