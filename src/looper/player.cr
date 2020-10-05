module Looper
  class Player
    getter vehicle : Vehicle

    delegate :x, :x=, :y, :y=, :collision?, :collisions?, :input, to: vehicle

    def initialize(x, y, vehicle_class = Car)
      puts "Player init vehicle_class: #{vehicle_class}"
      @vehicle = vehicle_class.new(
        x: x,
        y: y,
        player: true
      )
    end

    def update(frame_time)
      vehicle.update(frame_time)
    end

    def draw
      vehicle.draw
    end
  end
end
