require 'spec_helper'
require 'time_calculator'

describe TimeCalculator do
  let(:start_column) { 'first' }
  let(:some_other_column) { 'unimportant' }
  let(:end_column) { 'last' }
  let(:start_value) { 1449071399 }
  let(:random_column) { 1449402150 }
  let(:end_value) { 1449602150 }
  let(:calc) { TimeCalculator.new start_column, end_column }

  context ', when a start_time column does not exist,' do
    let(:record) { { end_column => end_value } }
    let(:record2) { { start_column => start_value } }

    it 'will return nil' do
      expect(calc.calculate record).to eq nil
    end

    it 'will return nil' do
      expect(calc.calculate record2).to eq nil
    end
  end

  context ', when both a start column and and end column are supplied,' do
    let(:record) { { start_column => start_value, end_column => end_value } }

    it 'will return the difference between the value of the two columns' do
      expected = end_value - start_value
      expect(calc.calculate record).to eq expected
    end
  end
end
