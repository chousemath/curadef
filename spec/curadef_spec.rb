require "spec_helper"

describe Curadef do
  it "has a version number" do
    expect(Curadef::VERSION).not_to be nil
  end

  context 'infill_multiplier' do
    it 'returns the correct multiplier for grid' do
      expect(Curadef.infill_multiplier(:cross)).to eq(1.0)
    end
    it 'returns the correct multiplier for grid' do
      expect(Curadef.infill_multiplier(:cross_3d)).to eq(1.0)
    end
    it 'returns the correct multiplier for grid' do
      expect(Curadef.infill_multiplier(:grid)).to eq(2.0)
    end
    it 'returns the correct multiplier for tetrahedral' do
      expect(Curadef.infill_multiplier(:tetrahedral)).to eq(2.0)
    end
    it 'returns the correct multiplier for tetrahedral' do
      expect(Curadef.infill_multiplier(:quarter_cubic)).to eq(2.0)
    end
    it 'returns the correct multiplier for triangles' do
      expect(Curadef.infill_multiplier(:triangles)).to eq(3.0)
    end
    it 'returns the correct multiplier for cubic' do
      expect(Curadef.infill_multiplier(:cubic)).to eq(3.0)
    end
    it 'returns the correct multiplier for cubicsubdiv' do
      expect(Curadef.infill_multiplier(:cubicsubdiv)).to eq(3.0)
    end
    it 'returns the correct multiplier for random' do
      expect(Curadef.infill_multiplier(:random)).to eq(1.0)
    end
  end

  context 'infill_line_distance' do
    it 'returns a value if given one' do
      actual = Curadef.infill_line_distance(2)
      expect(actual).to eq(2)
    end
    it 'returns a value if given one, regardless of the following values' do
      infill_line_width = 123.321
      infill_sparse_density = 75.432
      infill_pattern = :cubic
      actual = Curadef.infill_line_distance(2, infill_sparse_density, infill_line_width, infill_pattern)
      expect(actual).to eq(2)
    end
    it 'returns the correct infill_line_distance (trial 1)' do
      infill_line_width = 123.321
      infill_sparse_density = 75.432
      infill_pattern = :cubic
      actual = Curadef.infill_line_distance(nil, infill_sparse_density, infill_line_width, infill_pattern)
      expect(actual).to eq(490.458)
    end
    it 'returns the correct infill_line_distance (trial 2)' do
      infill_line_width = 2.32155
      infill_sparse_density = 15.333
      infill_pattern = :cross
      actual = Curadef.infill_line_distance(nil, infill_sparse_density, infill_line_width, infill_pattern)
      expect(actual).to eq(15.140)
    end
    it 'returns the minimum value (0) trial 1' do
      infill_line_width = -2.32155
      infill_sparse_density = 15.333
      infill_pattern = :cross
      actual = Curadef.infill_line_distance(nil, infill_sparse_density, infill_line_width, infill_pattern)
      expect(actual).to eq(0)
    end
    it 'returns the minimum value (0) trial 2' do
      infill_line_width = 2.32155
      infill_sparse_density = -15.333
      infill_pattern = :cross
      actual = Curadef.infill_line_distance(nil, infill_sparse_density, infill_line_width, infill_pattern)
      expect(actual).to eq(0)
    end
  end

  context 'wall_line_count' do
    it 'should return a value if given one' do
      actual = Curadef.wall_line_count(5)
      expect(actual).to eq(5)
    end
    it 'should return a value if given one, regardless of following values' do
      magic_spiralize = true
      wall_thickness = 0.5
      wall_line_width_0 = 0.3
      wall_line_width_x = 0.7
      actual = Curadef.wall_line_count(5, magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
      expect(actual).to eq(5)
    end
    it 'should return 1 if magic_spiralize is set to true' do
      magic_spiralize = true
      wall_thickness = 0.5
      wall_line_width_0 = 0.3
      wall_line_width_x = 0.7
      actual = Curadef.wall_line_count(nil, magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
      expect(actual).to eq(1)
    end
    it 'should return 0 if wall_thickness is 0' do
      magic_spiralize = false
      wall_thickness = 0.0
      wall_line_width_0 = 0.3
      wall_line_width_x = 0.7
      actual = Curadef.wall_line_count(nil, magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
      expect(actual).to eq(0)
    end
    it 'should return 0 if wall_thickness is negative' do
      magic_spiralize = false
      wall_thickness = -2.3
      wall_line_width_0 = 0.3
      wall_line_width_x = 0.7
      actual = Curadef.wall_line_count(nil, magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
      expect(actual).to eq(0)
    end
    it 'should return 0 if wall_line_width_x is 0' do
      magic_spiralize = false
      wall_thickness = 2.3
      wall_line_width_0 = 0.3
      wall_line_width_x = 0.0
      actual = Curadef.wall_line_count(nil, magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
      expect(actual).to eq(0)
    end
    it 'should return 0 if wall_line_width_x is negative' do
      magic_spiralize = false
      wall_thickness = 2.3
      wall_line_width_0 = 0.3
      wall_line_width_x = -0.7
      actual = Curadef.wall_line_count(nil, magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
      expect(actual).to eq(0)
    end
    it 'should return correct value trial 1' do
      magic_spiralize = false
      wall_thickness = 2.3
      wall_line_width_0 = 0.3
      wall_line_width_x = 0.7
      actual = Curadef.wall_line_count(nil, magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
      expect(actual).to eq(3.857)
    end
    it 'should return correct value trial 2' do
      magic_spiralize = false
      wall_thickness = 2.5
      wall_line_width_0 = 0.1
      wall_line_width_x = 0.9
      actual = Curadef.wall_line_count(nil, magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
      expect(actual).to eq(3.222)
    end
  end

  context 'wall_0_wipe_dist' do
    it 'should return a value if given one' do
      machine_nozzle_size = -0.4
      actual = Curadef.wall_0_wipe_dist(0.8)
      expect(actual).to eq(0.8)
    end
    it 'should return a value if given one, regardless of following values' do
      machine_nozzle_size = -0.4
      actual = Curadef.wall_0_wipe_dist(0.8, 1, 2, 3)
      expect(actual).to eq(0.8)
    end
    it 'should return minimum value if machine_nozzle_size is negative' do
      machine_nozzle_size = -0.4
      actual = Curadef.wall_0_wipe_dist(nil, machine_nozzle_size)
      expect(actual).to eq(0)
    end
    it 'should return the correct value trial 1' do
      machine_nozzle_size = 0.4
      actual = Curadef.wall_0_wipe_dist(nil, machine_nozzle_size)
      expect(actual).to eq(0.2)
    end
    it 'should return the correct value trial 2' do
      machine_nozzle_size = 0.7
      actual = Curadef.wall_0_wipe_dist(nil, machine_nozzle_size)
      expect(actual).to eq(0.35)
    end
  end

  context 'speed_ironing' do
    it 'should return a value if given one' do
      actual = Curadef.speed_ironing(1.5)
      expect(actual).to eq(1.5)
    end
    it 'should return a value if give one, regardles of following values' do
      actual = Curadef.speed_ironing(1.5, 22, 33)
      expect(actual).to eq(1.5)
    end
    it 'should return minimum value if value is 0' do
      actual = Curadef.speed_ironing(0, 22, 33)
      expect(actual).to eq(0.001)
    end
    it 'should return minimum value if value is negative' do
      actual = Curadef.speed_ironing(-10, 22, 33)
      expect(actual).to eq(0.001)
    end
    it 'should return the correct value trial 1' do
      speed_topbottom = 30
      actual = Curadef.speed_ironing(nil, speed_topbottom)
      expect(actual).to eq(20)
    end
    it 'should return the correct value trial 2' do
      speed_topbottom = 60
      actual = Curadef.speed_ironing(nil, speed_topbottom)
      expect(actual).to eq(40)
    end
  end

  context 'ironing_inset' do
    it 'should return a value if given one' do
      actual = Curadef.ironing_inset(12.2)
      expect(actual).to eq(12.2)
    end
    it 'should return a value if give one, regardles of following values' do
      actual = Curadef.ironing_inset(1.5, 22, 33)
      expect(actual).to eq(1.5)
    end
    it 'should return minimum value if value is negative' do
      actual = Curadef.ironing_inset(-100, 22, 33)
      expect(actual).to eq(0)
    end
    it 'should return the correct value trial 1' do
      wall_line_width_0 = 30
      actual = Curadef.ironing_inset(nil, wall_line_width_0)
      expect(actual).to eq(15)
    end
    it 'should return the correct value trial 1' do
      wall_line_width_0 = 99
      actual = Curadef.ironing_inset(nil, wall_line_width_0)
      expect(actual).to eq(49.5)
    end
  end

  context 'magic_fuzzy_skin_point_dist' do
    it 'should return minimum value if value is too small' do
      magic_fuzzy_skin_thickness = 100
      actual = Curadef.magic_fuzzy_skin_point_dist(0, magic_fuzzy_skin_thickness)
      expect(actual).to eq(50)
    end
    it 'should return value if greater than minimum' do
      magic_fuzzy_skin_thickness = 100
      actual = Curadef.magic_fuzzy_skin_point_dist(150, magic_fuzzy_skin_thickness)
      expect(actual).to eq(150)
    end
    it 'should return the correct value trial 1' do
      magic_fuzzy_skin_thickness = 100
      magic_fuzzy_skin_point_density = 0
      actual = Curadef.magic_fuzzy_skin_point_dist(nil, magic_fuzzy_skin_thickness, magic_fuzzy_skin_point_density)
      expect(actual).to eq(10000)
    end
    it 'should return the correct value trial 1' do
      magic_fuzzy_skin_thickness = 0.1
      magic_fuzzy_skin_point_density = 0.1
      actual = Curadef.magic_fuzzy_skin_point_dist(nil, magic_fuzzy_skin_thickness, magic_fuzzy_skin_point_density)
      expect(actual).to eq(10)
    end
  end
end
