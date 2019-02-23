class GameController < ApplicationController
    before_action :require_login
    
    def index
    end
    
    def play
      @game_detail = GameDetail.find_by(game_id: params[:id])
    end
end
