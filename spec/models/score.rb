require "rails_helper"

RSpec.shared_context "score", shared_context: :metadata do
  let(:zero_user) do
    described_class.create(uid: 1, score: 0)
  end

  let(:high_level_user) do
    described_class.create(uid: 2, score: 1_000_000)
  end
end
