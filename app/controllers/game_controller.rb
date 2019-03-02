class GameController < ApplicationController
    before_action :require_login
    
    def index
      game = Game.find_by(user_id: current_user.id, status: "playing")
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
      formation[3][3] = 2
      formation[3][4] = 1
      formation[4][3] = 1
      formation[4][4] = 2
      game_detail = GameDetail.new(game_id: game.id, formation: formation.to_json)
      game_detail.save
      redirect_to action: :play, id: game.id and return
    end
    
    def play
      @game = Game.find_by(id: params[:id])
      @score = @game.calc_score
      @result = if @score[:senko] > @score[:kouko]
                  "あなたの勝ちです"
                elsif @score[:senko] < @score[:kouko]
                  "CPUの勝ちです"
                else
                  "引き分けです"
                end
      @game_detail = GameDetail.find_by(game_id: params[:id])
      pp @game_detail
      if @game_detail.blank?
        redirect_to action: :index and return
      end
    end
end
