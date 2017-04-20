class Dose < ApplicationRecord
  belongs_to :cocktail
  belongs_to :ingredient

  validates :ingredient_id, uniqueness: { scope: [:cocktail_id] }
end
