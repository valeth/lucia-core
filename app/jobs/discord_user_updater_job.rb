# frozen_string_literal: true

# Schedules the Discord users cache to be updated periodically.
class DiscordUserUpdaterJob < ApplicationJob
  def perform(*args)
    ids = all_ids

    logger.info { "Updating user information for #{ids.size} users" }

    ids.each do |id|
      DiscordUserFetcherJob.perform_later(id)
    end
  end

private

  def all_ids
    Donor.all_user_ids | Leaderboard.all_user_ids
  end
end
