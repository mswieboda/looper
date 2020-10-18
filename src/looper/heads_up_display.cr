module Looper
  class HeadsUpDisplay
    property laps : UInt16
    property lap_time : Float64
    property lap_times : Array(Float64)
    property speed : Int32 | Float32

    PADDING = 15
    TEXT_COLOR = Game::Color::White

    def initialize
      @laps = 0
      @lap_time = 0.0
      @lap_times = [] of Float64
      @speed = 0
    end

    def update(frame_time)
    end

    def draw
      # top left
      pos = Game::Vector.new

      draw_editable(pos) if G.edit_mode?
      draw_laps(pos)

      # bottom left
      draw_speed
    end

    def draw_editable(pos)
      Game::Text.new(
        text: "edit mode",
        x: pos.x,
        y: pos.y,
        size: 18,
        spacing: 1,
        color: TEXT_COLOR
      ).draw
    end

    def draw_laps(pos)
      pos.x += PADDING
      pos.y += PADDING

      text = Game::Text.new(
        text: "laps: #{laps}",
        x: pos.x,
        y: pos.y,
        size: 18,
        spacing: 1,
        color: TEXT_COLOR
      )
      text.draw

      pos.y += text.height + PADDING

      # lap time
      text = Game::Text.new(
        text: "lap_time: #{lap_time.round(3)}",
        x: pos.x,
        y: pos.y,
        size: 18,
        spacing: 1,
        color: TEXT_COLOR
      )
      text.draw

      pos.y += text.height + PADDING

      # laps
      text = Game::Text.new(
        text: "laps:",
        x: pos.x,
        y: pos.y,
        size: 18,
        spacing: 1,
        color: TEXT_COLOR
      )
      text.draw

      lap_times.each do |lap_time|
        pos.y += text.height

        text = Game::Text.new(
          text: "#{lap_time.round(3)} sec",
          x: pos.x,
          y: pos.y,
          size: 18,
          spacing: 1,
          color: TEXT_COLOR
        )
        text.draw
      end

      pos.y += text.height + PADDING
    end

    def draw_speed
      pos = Game::Vector.new
      pos.x = PADDING
      pos.y = G.screen_height - PADDING

      text = Game::Text.new(
        text: "speed: #{(speed * 5).round(1)} mph",
        x: pos.x,
        size: 18,
        spacing: 1,
        color: TEXT_COLOR
      )
      pos.y -= text.height
      text.y = pos.y
      text.draw
    end
  end
end
