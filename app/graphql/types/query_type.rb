module Types
  class QueryType < Types::BaseObject
    field :sigma, Types::SigmaType, null: true

    field :donors, [Types::Sigma::DonorType], null: false

    def donors
      Donor.all.desc(:tier)
    end

    def sigma
      {}
    end
  end
end
