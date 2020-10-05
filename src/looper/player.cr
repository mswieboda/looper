module Looper
  class Player
    NOOB_VEHICLE_CLASS = Car
    ELITE_VEHICLE_CLASS = Motorcycle

    getter vehicle : Vehicle

    delegate :x, :x=, :y, :y=, :collision?, :collisions?, :input, to: vehicle

    def initialize(x, y, difficulty)
      @vehicle = vehicle_class(difficulty).new(
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

    def vehicle_class(difficulty)
      v_class = NOOB_VEHICLE_CLASS
      v_class = ELITE_VEHICLE_CLASS if difficulty == "elite"
      v_class
    end

    def difficulty=(difficulty)
      @vehicle = vehicle_class(difficulty).new(
        x: x,
        y: y,
        player: true
      )
    end
  end
end
