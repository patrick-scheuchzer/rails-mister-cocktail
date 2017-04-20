class Dose < ApplicationRecord
  belongs_to :cocktail
  belongs_to :ingredient

  validates :ingredient_id, uniqueness: { scope: [:cocktail_id] }
  # validates :description, presence: true
  # breaks seed
  validates :cocktail_id, presence: true
  validates :ingredient_id, presence: true
end
