require_relative 'card_created_date'
require_relative 'card_transformer'
require_relative 'array_transformer'

class TrelloRepository
  def initialize member, board_config
    self.member = member
    self.board = member.boards.select { |tboard| tboard.name == board_config['name'] }[0]
    self.cards_transformer = ArrayTransformer.new CardTransformer.new
  end

  def columns
    columns = board.lists.map do |list| { :id => list.id, :name => list.name, :pos => list.pos } end
    sorted_columns = columns.sort_by do |column| column[:pos] end
    sorted_columns.each_with_index.map do |column, index|
      column[:pos] = index
      column
    end
  end

  def cards
    cards_transformer.transform board.cards
  end

  private

  attr_accessor :member, :board, :cards_transformer
end
