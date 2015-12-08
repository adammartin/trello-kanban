require 'spec_helper'
require 'card_array_filter'

describe CardArrayFilter do
  let(:type1) { 'some_column' }
  let(:type2) { 'some_other_column' }
  let(:nil_activity1) { { 'column' => nil } }
  let(:type_activity1) { { 'column' => { 'name' => type1 } } }
  let(:type2_activity1) { { 'column' => { 'name' => type2 } } }
  let(:card1) { { 'actions' => actions } }
  let(:card2) { { 'actions' => actions2 } }
  let(:filter) { CardArrayFilter.new type1 }

  context ', when passed a single card' do
    let(:actions) { [type_activity1, nil_activity1, type2_activity1] }
    let(:actions2) { [type2_activity1, nil_activity1] }

    it 'will return the card when it has the appropriate activity' do
      expect(filter.filter [card1]).to eq [card1]
    end

    it 'will not return the card when it does not have the appropriate activity' do
      expect(filter.filter [card2]).to eq []
    end
  end

  context ', when passed multiple cards' do
    let(:actions) { [type_activity1, nil_activity1, type2_activity1] }
    let(:actions2) { [type2_activity1, nil_activity1] }

    it 'will return the card when it has the appropriate activity' do
      expect(filter.filter [card1, card2]).to eq [card1]
    end
  end
end
