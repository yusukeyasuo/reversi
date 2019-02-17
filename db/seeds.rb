# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# テストデータ
if Game.find_by(id: 1).nil?
  game = Game.new(id: 1, user_id: 1)
  game.save
end

# テストデータ
formation = Array.new(8).map{Array.new(8, nil)}
formation[3][3] = 1
formation[3][4] = 2
formation[4][3] = 2
formation[4][4] = 1
if GameDetail.find_by(game_id: 1).nil?
  game_detail = GameDetail.new(game_id: 1, formation: formation.to_json)
  game_detail.save
else
  game_detail = GameDetail.find_by(game_id: 1)
  game_detail.formation = formation.to_json
  game_detail.save
end