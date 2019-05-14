# frozen_string_literal: true

class API::V1::Sigma::Stats < Grape::API
  class StringArray
    def self.parse(val)
      val.split(",")
    end

    def self.parsed?(val)
      val.is_a?(Array)
    end
  end

  helpers do
    def stats
      commands_filter = params.dig(:filter, :command).to_h.symbolize_keys
      events_filter = params.dig(:filter, :event).to_h.symbolize_keys

      commands = CommandStatistic.filtered(**commands_filter)
      events = EventStatistic.filtered(**events_filter)

      {
        commands: commands,
        events: events,
        general: GeneralStatistic.collect_stats,
        special: SpecialStatistic.all
      }
    end
  end

  namespace :stats do
    params do
      optional :filter, type: Hash, allow_blank: false
      given :filter do
        optional :filter, type: Hash do
          optional :command, type: Hash, allow_blank: false do
            optional :only, type: StringArray, allow_blank: false
            optional :except, type: StringArray, allow_blank: false
            mutually_exclusive :only, :except
          end
          optional :event, type: Hash, allow_blank: false do
            optional :only, type: StringArray, allow_blank: false
            optional :except, type: StringArray, allow_blank: false
            mutually_exclusive :only, :except
          end
          at_least_one_of :command, :event
        end
      end
    end

    get do
      present stats, with: ::Entities::Stats
    end
  end
end
