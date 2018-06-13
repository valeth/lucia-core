module Sigma
  class VersionController < ApplicationController
    def show
      @version = BotVersion.first
    end
  end
end
