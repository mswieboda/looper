require "game"

require "./looper/**"

module Looper
  def self.run
    Game.new.run
  end
end

Looper.run
