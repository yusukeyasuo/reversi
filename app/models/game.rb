class Game < ApplicationRecord
  has_many :game_details, -> { order(id: :desc) }, class_name: 'GameDetail'
  
  enum status: { playing: 0, finished: 1 }
  
  def calc_score
    score = { senko: 0, kouko: 0 }
    return score if game_details.blank?
    formation_array = JSON.parse(game_details.first.formation)
    formation_array.each do |rows|
      rows.each do |square|
        score[:senko] += 1 if square == 1
        score[:kouko] += 1 if square == 2
      end
    end
    score
  end
end
