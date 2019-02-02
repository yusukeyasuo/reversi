class GameController < ApplicationController
    def index
    end
    
    def play
      @game_detail = GameDetail.find_by(game_id: params[:id])
      pp @game_detail
    end
end
