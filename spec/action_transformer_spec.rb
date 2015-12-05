require 'spec_helper'
require 'trello'
require 'action_transformer'
require 'time'

include Trello

describe ActionTransformer do
  let(:action) { gimme(Action) }
  let(:id) { 'some_id' }
  let(:type) { 'some_type' }
  let(:list) { { 'name' => 'some_name', 'id' => 'list_id' } }
  let(:card_id) { 'card_id' }
  let(:action_date) { Time.parse('2015-12-01 17:00:53 UTC') }
  let(:action_date_in_millis) { 1448989253 }
  let(:transformer) { ActionTransformer.new }

  before(:each) {
    give(action).id { id }
    give(action).type { type }
    give(action).data { { 'list' => list, 'card' => { 'id' => card_id } } }
    give(action).date { action_date }
  }

  it 'will transform a Trello::Action into an internal action for persistance' do
    expected = { 'id' => id, 'type' => type, 'column' => list, 'card_id' => card_id, 'time' => action_date_in_millis }
    expect(transformer.transform action).to eq expected
  end
end
