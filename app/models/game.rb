class Game < ApplicationRecord
  enum status: { playing: 0, finished: 1 }
end
