require_relative 'card_created_date'

class TrelloRepository
  def initialize member, config
    self.member = member
    self.config = config
    self.board = member.boards.select { |tboard| tboard.name == config['board'] }[0]
    self.parser = CardCreatedDate.new
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
    board.cards.map do |card|
      { :id => card.id, :column_id => card.list_id, :created_date => parser.parse(card.id) }
    end
  end

  private

  attr_accessor :member, :config, :board, :parser
end
