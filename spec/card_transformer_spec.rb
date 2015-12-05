require 'spec_helper'
require 'trello'
require 'card_transformer'

include Trello

describe CardTransformer do
  let(:act_list_transformer) { gimme(ArrayTransformer) }
  let(:action_transformer) { gimme(ActionTransformer) }
  let(:parser) { gimme(CardCreatedDate) }
  let(:actions) { 'some_array_of_actions' }
  let(:transformed_actions) { 'eresult_of_trans_formation' }
  let(:id) { 'card_id' }
  let(:column_id) { 'column id' }
  let(:created) { 'some_date' }
  let(:card) { gimme(Card) }
  let(:transformer) { CardTransformer.new }

  before(:each) {
    give(ActionTransformer).new { action_transformer }
    give(ArrayTransformer).new(action_transformer) { act_list_transformer }
    give(CardCreatedDate).new { parser }
    give(parser).parse(id) { created }
    give(act_list_transformer).transform(actions) { transformed_actions }
    give(card).id { id }
    give(card).list_id { column_id }
    give(card).actions { actions }
  }

  it 'will parse a Trello::Card into a hash' do
    expected = { :id => id, :column_id => column_id, :created_date => created, :actions => transformed_actions }
    expect(transformer.transform card).to eq expected
  end
end
