require "ostruct"

module Types
  class QueryType < Types::BaseObject
    field :sigma, Types::SigmaType, null: true

    field :donors, [Types::Sigma::DonorType], null: false do
      argument :tier, Integer, required: false
    end

    def donors(tier: nil)
      if tier
        Donor.where(tier: tier)
      else
        Donor.all.desc(:tier)
      end
    end

    def sigma
      OpenStruct.new(commands: Command)
    end
  end
end
