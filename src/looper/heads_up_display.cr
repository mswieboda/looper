module Looper
  class HeadsUpDisplay
    property laps : UInt16
    property lap_time : Float32
    property lap_times : Array(Float32)
    property speed : Int32 | Float32

    PADDING = 15
    LAP_TEXT_SIZE = 21
    TEXT_COLOR = Game::Color::White

    def initialize
      @laps = 0
      @lap_time = 0.0
      @lap_times = [] of Float32
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
      draw_speedometer
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
        size: LAP_TEXT_SIZE,
        spacing: 1,
        color: TEXT_COLOR
      )
      text.draw

      pos.y += text.height + PADDING

      # lap time
      draw_lap_time(pos)

      # laps
      text = Game::Text.new(
        text: "laps:",
        x: pos.x,
        y: pos.y,
        size: LAP_TEXT_SIZE,
        spacing: 1,
        color: TEXT_COLOR
      )
      text.draw

      lap_times.each do |lap_time|
        pos.y += text.height

        text = Game::Text.new(
          text: "#{lap_time.round(2)} sec",
          x: pos.x,
          y: pos.y,
          size: LAP_TEXT_SIZE,
          spacing: 1,
          color: TEXT_COLOR
        )
        text.draw
      end

      pos.y += text.height + PADDING
    end

    def draw_lap_time(pos)
      # lap time: label
      text = Game::Text.new(
        text: "lap time: ",
        x: pos.x,
        y: pos.y,
        size: LAP_TEXT_SIZE,
        spacing: 1,
        color: TEXT_COLOR
      )
      text.draw

      lap_time_x = pos.x + text.width

      # lap time number text
      text = Game::Text.new(
        text: "#{lap_time.round(2)}",
        x: lap_time_x,
        y: pos.y,
        size: LAP_TEXT_SIZE,
        spacing: 1,
        color: TEXT_COLOR
      )
      text.draw

      digit_chars = ((lap_time < 1 ? 0.99_f32 + lap_time : lap_time).round(2) * 100).to_i.to_s.chars.size
      text_full = Game::Text.new(text: "." + "9" * digit_chars, size: LAP_TEXT_SIZE, spacing: 1)

      # seconds label
      Game::Text.new(
        text: " sec",
        x: lap_time_x + text_full.width,
        y: pos.y,
        size: LAP_TEXT_SIZE,
        spacing: 1,
        color: TEXT_COLOR
      ).draw

      pos.y += text.height + PADDING
    end

    def draw_speedometer
      pos = Game::Vector.new
      pos.x = PADDING
      pos.y = G.screen_height - PADDING

      radius = 75

      # background circle
      Game::Circle.new(
        center_x: pos.x + radius,
        center_y: pos.y - radius,
        radius: radius,
        color: Game::Color::Black.alpha(0.69_f32)
      ).draw

      # speed text
      text = Game::Text.new(
        text: "#{(speed * 3).round(1)} mph",
        size: 18,
        spacing: 1,
        color: TEXT_COLOR
      )
      text.x = pos.x + radius - text.width / 2_f32
      text.y = pos.y - radius + text.height
      text.draw

      # speedometer arm
      thickness = 10
      length = radius * 0.83_f32
      rotation = scale(speed, 0, 33, 135, 315).to_f32

      r = thickness / 2_f32
      tri_rotation = 90 + rotation
      data = [
        {r: -r, t: tri_rotation},
        {r: -length, t: 90 + tri_rotation},
        {r: r, t: tri_rotation}
      ]

      # rotate
      points = data.map do |p|
        {
          x: Trig.rotate_x(p[:r], p[:t]),
          y: Trig.rotate_y(p[:r], p[:t])
        }
      end

      # position
      points = points.map do |p|
        {
          x: pos.x + radius + p[:x],
          y: pos.y - radius + p[:y]
        }
      end

      Game::Triangle.new(
        x1: points[0][:x].to_f32, y1: points[0][:y].to_f32,
        x2: points[1][:x].to_f32, y2: points[1][:y].to_f32,
        x3: points[2][:x].to_f32, y3: points[2][:y].to_f32,
      ).draw

      # speedometer arm center half circle cover
      Game::Circle.new(
        center_x: pos.x + radius,
        center_y: pos.y - radius,
        radius: thickness / 2_f32,
      ).draw
    end

    def scale(num, rmin, rmax, tmin, tmax)
      (num - rmin) / (rmax - rmin) * (tmax - tmin) + tmin
    end
  end
end
