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
    # "description": "Distance between the printed infill lines. This setting is calculated by the infill density and the infill line width.",
    # "unit": "mm",
    # "type": "float",
    # "default_value": 2,
    # "minimum_value": "0",
    # "minimum_value_warning": "infill_line_width",
    # "value": "0 if infill_sparse_density == 0 else (infill_line_width * 100) / infill_sparse_density * (2 if infill_pattern == 'grid' else (3 if infill_pattern == 'triangles' or infill_pattern == 'cubic' or infill_pattern == 'cubicsubdiv' else (2 if infill_pattern == 'tetrahedral' or infill_pattern == 'quarter_cubic' else (1 if infill_pattern == 'cross' or infill_pattern == 'cross_3d' else 1))))",
    # "limit_to_extruder": "infill_extruder_nr",
    # "settable_per_mesh": true
    return 0.0 if infill_sparse_density == 0.0
    (infill_line_width * 100.0) / infill_sparse_density * infill_multiplier[infill_pattern]
  end
end
