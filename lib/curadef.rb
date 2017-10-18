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

  def self.infill_line_distance(value, *args)
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
    unless value
      infill_sparse_density, infill_line_width, infill_pattern = args
      return 0.0 if infill_sparse_density == 0.0
      value = truncate_num((infill_line_width * 100.0) / infill_sparse_density * infill_multiplier(infill_pattern))
      puts "At or below minimum value (#{infill_line_width})" if value < infill_line_width
    end
    [0, value].max
  end

  def self.ironing_inset(value, *args)
    # "label": "Ironing Inset",
    # "description": "A distance to keep from the edges of the model. Ironing all the way to the edge of the mesh may result in a jagged edge on your print.",
    # "type": "float",
    # "unit": "mm",
    # "default_value": 0.35,
    # "value": "wall_line_width_0 / 2",
    # "minimum_value_warning": "0",
    # "maximum_value_warning": "wall_line_width_0",
    # "enabled": "ironing_enabled",
    # "limit_to_extruder": "top_bottom_extruder_nr",
    # "settable_per_mesh": true
    unless value
      wall_line_width_0 = args[0]
      value = truncate_num(wall_line_width_0 / 2.0)
    end
    [0, value].max
  end

  def self.speed_ironing(value, *args)
    # "label": "Ironing Speed",
    # "description": "The speed at which to pass over the top surface.",
    # "type": "float",
    # "unit": "mm/s",
    # "default_value": 20.0,
    # "value": "speed_topbottom * 20 / 30",
    # "minimum_value": "0.001",
    # "maximum_value": "math.sqrt(machine_max_feedrate_x ** 2 + machine_max_feedrate_y ** 2)",
    # "maximum_value_warning": "100",
    # "enabled": "ironing_enabled",
    # "limit_to_extruder": "top_bottom_extruder_nr",
    # "settable_per_mesh": true
    unless value
      speed_topbottom = args[0]
      value = truncate_num(speed_topbottom * 2 / 3.0)
    end
    [0.001, value].max
  end

  def self.wall_line_count(value, *args)
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
    unless value
      magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x = args
      return 1 if magic_spiralize
      return 0 if wall_thickness <= 0.0
      if wall_line_width_x <= 0
        puts "Invalid value for wall_line_width_x, expected: greater than 0, "\
             "got: #{wall_line_width_x}"
        return 0
      end
      value = truncate_num(((wall_thickness - wall_line_width_0).round / wall_line_width_x) + 1)
      puts "At or below minimum value (1)" if value <= 1
      puts "At or above maximum value (10)" if value >= 10
    end
    [1, value].max
  end

  def self.wall_0_wipe_dist(value, *args)
    # "label": "Outer Wall Wipe Distance",
    # "description": "Distance of a travel move inserted after the outer wall, to hide the Z seam better.",
    # "unit": "mm",
    # "type": "float",
    # "default_value": 0.2,
    # "value": "machine_nozzle_size / 2",
    # "minimum_value": "0",
    # "maximum_value_warning": "machine_nozzle_size * 2",
    # "limit_to_extruder": "wall_0_extruder_nr",
    # "settable_per_mesh": true
    unless value
      machine_nozzle_size = args[0]
      value = truncate_num(machine_nozzle_size / 2.0)
    end
    [0, value].max
  end

  def self.truncate_num(value)
    (value * 1000).floor / 1000.0
  end
end
