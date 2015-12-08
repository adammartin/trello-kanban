class ArrayTransformer
  def initialize item_transformer
    self.item_transformer = item_transformer
  end

  def transform array
    array.map do |item| item_transformer.transform item end.compact
  end

  private

  attr_accessor :item_transformer
end
