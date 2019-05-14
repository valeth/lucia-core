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

      {
        commands: command_stats(commands_filter),
        events: event_stats(events_filter),
        general: general_stats,
        special: SpecialStatistic.all
      }
    end

    def general_stats
      GeneralStatistic.collect_stats
    end

    def command_stats(**filter)
      CommandStatistic.filtered(**filter)
    end

    def event_stats(**filter)
      EventStatistic.filtered(**filter)
    end
  end

  # rubocop:disable Metrics/BlockLength
  namespace :stats do
    # /general

    get "general" do
      present general_stats, with: ::Entities::GeneralStats
    end

    # /events

    params do
      optional :filter, type: Hash do
        optional :only, type: StringArray, allow_blank: false
        optional :except, type: StringArray, allow_blank: false
        mutually_exclusive :only, :except
      end
    end

    get "events" do
      filter = params.dig(:filter).to_h.symbolize_keys
      present ::Entities.list_formatter(event_stats(filter))
    end

    # /commands

    params do
      optional :filter, type: Hash do
        optional :only, type: StringArray, allow_blank: false
        optional :except, type: StringArray, allow_blank: false
        mutually_exclusive :only, :except
      end
    end

    get "commands" do
      filter = params.dig(:filter).to_h.symbolize_keys
      present ::Entities.list_formatter(command_stats(filter))
    end

    # /

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
    # rubocop:enable Metrics/BlockLength

    get do
      present stats, with: ::Entities::Stats
    end
  end
end
