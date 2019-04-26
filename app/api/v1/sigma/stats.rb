# frozen_string_literal: true

class V1::Sigma::Stats < Grape::API
  helpers do
    def stats
      {
        commands: CommandStatistic.all,
        events: EventStatistic.all,
        general: GeneralStatistic.collect_stats,
        special: SpecialStatistic.all
      }
    end
  end

  namespace :stats do
    get do
      present stats, with: ::Entities::Stats
    end
  end
end
