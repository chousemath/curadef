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
    pending('infill_line_distance')
  end
end
