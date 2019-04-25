# frozen_string_literal: true

class CurrencySystem
  include Mongoid::Document
  include Score

  store_in collection: "CurrencyResource"

  field :user_id, as: :uid, type: Integer
  field :ranked, as: :score, type: Integer, default: 0

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
    @leveler ||= 7537.0
  end
end
