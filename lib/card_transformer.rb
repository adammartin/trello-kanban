require_relative 'array_transformer'
require_relative 'action_transformer'
require_relative 'card_created_date'

class CardTransformer
  def initialize
    self.actions_transformer = ArrayTransformer.new ActionTransformer.new
    self.parser = CardCreatedDate.new
  end

  def transform card
    { :id => card.id, :name => card.name, :column_id => card.list_id, :created_date => parser.parse(card.id), :actions => actions_transformer.transform(card.actions) }
  end

  private

  attr_accessor :actions_transformer, :parser
end
