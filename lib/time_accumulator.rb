class TimeAccumulator
  def initialize calculator
    self.calculator = calculator
  end

  def average card_activity_records
    numbers = card_activity_records.map do | record | calculator.calculate(record) end.compact
    numbers.inject(:+).to_f/numbers.length
  end

  private
  attr_accessor :calculator
end
