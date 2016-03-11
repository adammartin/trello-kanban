class TimeCalculator
  def initialize start_column, end_column
    self.start_column = start_column
    self.end_column = end_column
  end

  def calculate card_activity
    card_activity[end_column] - card_activity[start_column] if card_activity[end_column] && card_activity[start_column]
  end

  private

  attr_accessor :start_column, :end_column
end
