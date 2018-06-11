# frozen_string_literal: true

class CurrencySystem
  include Mongoid::Document
  include Score

  store_in client: "sigma", collection: "CurrencySystem"

  field :UserID, as: :uid, type: Integer
  field :global, as: :score, type: Integer

private

  def prefixes
    @prefixes ||= %w[
      Regular Iron Bronze Silver Gold
      Platinum Diamond Opal Sapphire Musgravite
    ].freeze
  end

  def suffixes
    @suffixes ||= %w[
      Pickpocket Worker Professional Collector Capitalist
      Entrepreneur Executive Banker Royal Illuminati
    ].freeze
  end

  def leveler
    @leveler ||= 1133.55
  end
end
