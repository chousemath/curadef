require "curadef/version"

module Curadef
  # Your code goes here...

  INFILL_PATTERNS = {
    cross: 1.0,
    cross_3d: 1.0,
    grid: 2.0,
    tetrahedral: 2.0,
    quarter_cubic: 2.0,
    triangles: 3.0,
    cubic: 3.0,
    cubicsubdiv: 3.0
  }

  def self.infill_multiplier(pattern)
    INFILL_PATTERNS.key?(pattern) ? INFILL_PATTERNS[pattern] : 1.0
  end

  def self.infill_line_distance(infill_sparse_density, infill_line_width, infill_pattern)
    # "label": "Infill Line Distance",
    # "description": "Distance between the printed infill lines. This setting
    #                is calculated by the infill density and the infill line
    #                width.",
    # "unit": "mm",
    # "type": "float",
    # "default_value": 2,
    # "minimum_value": "0",
    # "minimum_value_warning": "infill_line_width",
    # "value": "0 if infill_sparse_density == 0 else (infill_line_width * 100)
    #          / infill_sparse_density * (2 if infill_pattern == 'grid' else (3
    #          if infill_pattern == 'triangles' or infill_pattern == 'cubic' or
    #          infill_pattern == 'cubicsubdiv' else (2 if infill_pattern ==
    #          'tetrahedral' or infill_pattern == 'quarter_cubic' else (1 if
    #          infill_pattern == 'cross' or infill_pattern == 'cross_3d' else
    #          1))))",
    # "limit_to_extruder": "infill_extruder_nr",
    # "settable_per_mesh": true
    return 0.0 if infill_sparse_density == 0.0
    value = (infill_line_width * 100.0) / infill_sparse_density * infill_multiplier(infill_pattern)
    # truncate that value to 3 decimal points
    truncated_value = truncate_num(value)
    puts "At or below minimum value (#{infill_line_width})" if truncated_value < infill_line_width
    [0, truncated_value].max
  end

  def self.wall_line_count(magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
    # "label": "Wall Line Count",
    # "description": "The number of walls. When calculated by the wall thickness, this value is rounded to a whole number.",
    # "default_value": 2,
    # "minimum_value": "0",
    # "minimum_value_warning": "1",
    # "maximum_value_warning": "10",
    # "type": "int",
    # "value": "1 if magic_spiralize else max(1, round((wall_thickness - wall_line_width_0) / wall_line_width_x) + 1) if wall_thickness != 0 else 0",
    # "limit_to_extruder": "wall_x_extruder_nr",
    # "settable_per_mesh": true
    return 1 if magic_spiralize
    return 0 if wall_thickness <= 0.0
    if wall_line_width_x <= 0
      puts "Invalid value for wall_line_width_x, expected: greater than 0, "\
           "got: #{wall_line_width_x}"
      return 0
    end
    value = ((wall_thickness - wall_line_width_0).round / wall_line_width_x) + 1
    puts "At or below minimum value (1)" if value <= 1
    puts "At or above maximum value (10)" if value >= 10
    [1, truncate_num(value)].max
  end

  def self.truncate_num(value)
    (value * 1000).floor / 1000.0
  end
end
