# frozen_string_literal: true

class Cookie
  include Mongoid::Document
  include Score

  store_in client: "sigma", collection: "Cookies"

  field :UserID, as: :uid, type: Integer
  field :Cookies, as: :score, type: Integer

private

  def prefixes
    @prefixes ||= %w[
      Starving Picky Nibbling Munching Noming
      Glomping Chomping Inhaling Gobbling Devouring
    ].freeze
  end

  def suffixes
    @suffixes ||= %w[
      Licker Taster Eater Chef Connoisseur
      Gorger Epicure Glutton Devourer Void
    ].freeze
  end

  def leveler
    @leveler ||= 5.15
  end
end
