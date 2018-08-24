class TimeCalculator
  def initialize start_columns, end_columns
    self.start_columns = start_columns
    self.end_columns = end_columns
  end

  def calculate card_activity
    start_times = card_activity.slice(*start_columns)
    end_times = card_activity.slice(*end_columns)
    end_times.values.first - start_times.values.last unless start_times.empty? or end_times.empty?
  end

  private

  attr_accessor :start_columns, :end_columns
end
