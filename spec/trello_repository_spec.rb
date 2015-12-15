require 'spec_helper'
require 'trello'
require 'trello_repository'

include Trello

describe TrelloRepository do
  let(:member) { gimme(Member) }
  let(:our_board) { gimme(Board) }
  let(:other_board) { gimme(Board) }
  let(:cards_transformer) { gimme(ArrayTransformer) }
  let(:card_transformer) { gimme(CardTransformer) }
  let(:cards) { 'some_list_of_cards' }
  let(:transformed_cards) { 'cards_after_transformation' }

  let(:board_id) { '1337' }

  let(:column_1) { gimme(List) }
  let(:column_2) { gimme(List) }

  let(:column_1_id) { 'arbitrary_1' }

  let(:name_1) { 'First' }
  let(:name_2) { 'Second' }

  let(:card_created_parser) { gimme(CardCreatedDate) }

  let(:repo) { TrelloRepository.new member, CONFIG }

  before(:each) {
    give(CardTransformer).new { card_transformer }
    give(ArrayTransformer).new(card_transformer) { cards_transformer }
    give(cards_transformer).transform(cards) { transformed_cards }
    give(our_board).id { board_id }
    give(our_board).name { CONFIG['board']['name'] }
    give(other_board).name { 'Stop touching me!' }

    give(column_1).id { column_1_id }
    give(column_1).name { name_1 }
    give(column_1).pos { 12.5 }
    give(column_2).id { 'arbitrary_2' }
    give(column_2).name { name_2 }
    give(column_2).pos { 142.5 }

    give(member).boards { [our_board, other_board] }

    give(our_board).lists { [column_2, column_1] }
    give(our_board).cards { cards }
  }

  it 'will supply an array of columns for a given board' do
    expected_column_1 = { :id => column_1.id, :name => name_1, :pos => 0 }
    expected_column_2 = { :id => column_2.id, :name => name_2, :pos => 1 }
    expected = [expected_column_1, expected_column_2]

    expect(repo.columns).to eq expected
  end

  it 'will produce a list of cards for a board' do
    expect(repo.cards).to eq transformed_cards
  end
end
