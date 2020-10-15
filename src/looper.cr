require "game"

require "./looper/**"

module Looper
  def self.run
    G.new.run
  end
end

Looper.run
