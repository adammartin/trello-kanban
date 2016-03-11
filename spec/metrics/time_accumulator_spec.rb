require 'metrics/time_accumulator'
require 'metrics/time_calculator'
require 'spec_helper'

describe TimeAccumulator do
  let(:calculator) { gimme(TimeCalculator) }
  let(:record_1) { gimme }
  let(:record_2) { gimme }
  let(:record_3) { gimme }
  let(:result_1) { 20 }
  let(:result_2) { 35 }
  let(:result_3) { 59 }
  let(:accumulator) { TimeAccumulator.new calculator }

  before(:each) {
    give(calculator).calculate(record_1) { result_1 }
    give(calculator).calculate(record_2) { result_2 }
    give(calculator).calculate(record_3) { result_3 }
  }

  it 'will return the average of a single record array' do
    expected = result_1
    expect(accumulator.average [record_1]).to eq expected
  end

  it 'will return the average of two record array' do
    expected = (result_1 + result_2).to_f / 2
    expect(accumulator.average [record_1, record_2]).to eq expected
  end

  it 'will return the average of a three record array' do
    expected = (result_1 + result_2 + result_3).to_f / 3
    expect(accumulator.average [record_1, record_2, record_3]).to eq expected
  end

  context ', when one of the records produces a nil result,' do
    let(:result_3) { nil }

    it 'will return the average of the other two records' do
      expected = (result_1 + result_2).to_f / 2
      expect(accumulator.average [record_1, record_2, record_3]).to eq expected
    end
  end
end
