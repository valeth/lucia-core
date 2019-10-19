# frozen_string_literal: true

class CurrencySystem
  include Score

  store_in collection: "CurrencyResource"

  self.prefixes = %w[
    Regular Iron Bronze Silver Gold
    Platinum Diamond Opal Sapphire Musgravite
  ]

  self.suffixes = %w[
    Pickpocket Worker Professional Collector Capitalist
    Entrepreneur Executive Banker Royal Illuminati
  ]

  self.leveler = 7537.0
end
