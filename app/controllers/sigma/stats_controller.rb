module Sigma
  class StatsController < ApplicationController
    def index
      @stats = stats
    end

  private

    def stats
      {
        commands: CommandStatistic.all,
        events: EventStatistic.all,
        general: GeneralStatistic.collect_stats,
        special: SpecialStatistic.all
      }
    end
  end
end
