module Looper
  class Player
    NOOB_VEHICLE_CLASS = Car
    ELITE_VEHICLE_CLASS = Motorcycle

    getter vehicle : Vehicle

    delegate :x, :x=, :y, :y=, :collision?, :collisions?, :input, to: vehicle

    def initialize(x, y, vehicle_class = NOOB_VEHICLE_CLASS)
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

    def difficulty=(difficulty)
      vehicle_class = NOOB_VEHICLE_CLASS
      vehicle_class = ELITE_VEHICLE_CLASS if difficulty == "elite"

      if vehicle_class != @vehicle.class
        @vehicle = vehicle_class.new(
          x: x,
          y: y,
          player: true
        )
      end
    end
  end
end
