class GameController < ApplicationController
    before_action :require_login
    
    def index
      game = Game.find_by(status: "playing")
      if game.present?
        redirect_to action: :play, id: game.id and return
      end
    end
    
    def create
      # Game 作成
      game = Game.create!(
        user_id: current_user.id,
        status: "playing"
      )
      
      # GameDetital 作成
      formation = Array.new(8).map{Array.new(8, nil)}
      formation[3][3] = 1
      formation[3][4] = 2
      formation[4][3] = 2
      formation[4][4] = 1
      game_detail = GameDetail.new(game_id: game.id, formation: formation.to_json)
      game_detail.save
      redirect_to action: :play, id: game.id and return
    end
    
    def play
      @game_detail = GameDetail.find_by(game_id: params[:id])
      if @game_detail.blank?
        redirect_to action: :index and return
      end
    end
end
