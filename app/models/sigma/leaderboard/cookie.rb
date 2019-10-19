# frozen_string_literal: true

class Cookie
  include Score

  store_in collection: "CookiesResource"

  self.prefixes = %w[
    Starving Picky Nibbling Munching Noming
    Glomping Chomping Inhaling Gobbling Devouring
  ]

  self.suffixes = %w[
    Licker Taster Eater Chef Connoisseur
    Gorger Epicure Glutton Devourer Void
  ]

  self.leveler = 5.15
end
