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
    it 'returns the correct infill_line_distance (trial 1)' do
      infill_line_width = 123.321
      infill_sparse_density = 75.432
      infill_pattern = :cubic
      actual = Curadef.infill_line_distance(infill_sparse_density, infill_line_width, infill_pattern)
      expect(actual).to eq(490.458)
    end

    it 'returns the correct infill_line_distance (trial 2)' do
      infill_line_width = 2.32155
      infill_sparse_density = 15.333
      infill_pattern = :cross
      actual = Curadef.infill_line_distance(infill_sparse_density, infill_line_width, infill_pattern)
      expect(actual).to eq(15.140)
    end

    it 'returns the minimum value (0) trial 1' do
      infill_line_width = -2.32155
      infill_sparse_density = 15.333
      infill_pattern = :cross
      actual = Curadef.infill_line_distance(infill_sparse_density, infill_line_width, infill_pattern)
      expect(actual).to eq(0)
    end

    it 'returns the minimum value (0) trial 2' do
      infill_line_width = 2.32155
      infill_sparse_density = -15.333
      infill_pattern = :cross
      actual = Curadef.infill_line_distance(infill_sparse_density, infill_line_width, infill_pattern)
      expect(actual).to eq(0)
    end
  end

  context 'wall_line_count' do
    it 'should return 1 if magic_spiralize is set to true' do
      magic_spiralize = true
      wall_thickness = 0.5
      wall_line_width_0 = 0.3
      wall_line_width_x = 0.7
      actual = Curadef.wall_line_count(magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
      expect(actual).to eq(1)
    end

    it 'should return 0 if wall_thickness is 0' do
      magic_spiralize = false
      wall_thickness = 0.0
      wall_line_width_0 = 0.3
      wall_line_width_x = 0.7
      actual = Curadef.wall_line_count(magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
      expect(actual).to eq(0)
    end

    it 'should return 0 if wall_thickness is negative' do
      magic_spiralize = false
      wall_thickness = -2.3
      wall_line_width_0 = 0.3
      wall_line_width_x = 0.7
      actual = Curadef.wall_line_count(magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
      expect(actual).to eq(0)
    end

    it 'should return 0 if wall_line_width_x is 0' do
      magic_spiralize = false
      wall_thickness = 2.3
      wall_line_width_0 = 0.3
      wall_line_width_x = 0.0
      actual = Curadef.wall_line_count(magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
      expect(actual).to eq(0)
    end

    it 'should return 0 if wall_line_width_x is negative' do
      magic_spiralize = false
      wall_thickness = 2.3
      wall_line_width_0 = 0.3
      wall_line_width_x = -0.7
      actual = Curadef.wall_line_count(magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
      expect(actual).to eq(0)
    end

    it 'should return correct value trial 1' do
      magic_spiralize = false
      wall_thickness = 2.3
      wall_line_width_0 = 0.3
      wall_line_width_x = 0.7
      actual = Curadef.wall_line_count(magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
      expect(actual).to eq(3.857)
    end

    it 'should return correct value trial 2' do
      magic_spiralize = false
      wall_thickness = 2.5
      wall_line_width_0 = 0.1
      wall_line_width_x = 0.9
      actual = Curadef.wall_line_count(magic_spiralize, wall_thickness, wall_line_width_0, wall_line_width_x)
      expect(actual).to eq(3.222)
    end
  end
end
