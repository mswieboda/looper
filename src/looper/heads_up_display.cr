module Looper
  class HeadsUpDisplay
    property laps : UInt16
    property lap_time : Float64
    property lap_times : Array(Float64)

    PADDING = 15
    TEXT_COLOR = Game::Color::White

    def initialize
      @laps = 0
      @lap_time = 0.0
      @lap_times = [] of Float64
    end

    def update(frame_time)
    end

    def draw
      x = 0
      y = 0

      if G.edit_mode?
        Game::Text.new(
          text: "edit mode",
          x: x,
          y: y,
          size: 18,
          spacing: 1,
          color: TEXT_COLOR
        ).draw
      end

      x += PADDING
      y += PADDING

      # laps
      text = Game::Text.new(
        text: "laps: #{laps}",
        x: x,
        y: y,
        size: 18,
        spacing: 1,
        color: TEXT_COLOR
      )
      text.draw

      y += text.height + PADDING

      # lap time
      text = Game::Text.new(
        text: "lap_time: #{lap_time.round(3)}",
        x: x,
        y: y,
        size: 18,
        spacing: 1,
        color: TEXT_COLOR
      )
      text.draw

      y += text.height + PADDING

      # laps
      text = Game::Text.new(
        text: "laps:",
        x: x,
        y: y,
        size: 18,
        spacing: 1,
        color: TEXT_COLOR
      )
      text.draw

      lap_times.each do |lap_time|
        y += text.height

        text = Game::Text.new(
          text: "#{lap_time.round(3)} sec",
          x: x,
          y: y,
          size: 18,
          spacing: 1,
          color: TEXT_COLOR
        )
        text.draw
      end
    end
  end
end
