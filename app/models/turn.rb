class Turn < ApplicationRecord
  belongs_to :round
  belongs_to :user
end
