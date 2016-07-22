require 'time_data_formatter'
require 'spec_helper'

describe TimeDataFormatter do
  let(:time_diff) { 275994.0 }
  let(:expected) { '3 days, 4 hours, 39 minutes and 54 seconds' }
  let(:formatter) { TimeDataFormatter.new }

  it 'will format time diff in seconds to the right format' do
    expect(formatter.format_time time_diff).to eq expected
  end

  it 'will accept NaN and return NaN' do
    expect(formatter.format_time Float::NAN).to eq Float::NAN.to_s
  end
end
