require 'spec_helper'
require 'card_created_date'

describe CardCreatedDate do
  let(:int_val_of_first_eight_characters_of_id) { 1298048559 }
  let(:id) { '4d5ea62fd76aa1136000000c' }
  let(:expected) { Time.at(int_val_of_first_eight_characters_of_id) }
  let(:parser) { CardCreatedDate.new }

  it 'can parse the date time from a id hash' do
    expect(parser.parse id).to eq expected
  end
end
