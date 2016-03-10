class ScrumCardSummarizer
  def initialize board_config
    self.start_val = Regexp.escape board_config['delimiter']['start']
    self.end_val = Regexp.escape board_config ['delimiter']['end']
  end

  def summarize cards
    grouped = cards.group_by do |card| card[:column_id] end
    grouped.each do |k, v| grouped[k] = sum(v) end
    { 'date_time' => Time.now }.merge grouped
  end

  private

  attr_accessor :start_val, :end_val

  def sum columns
    columns.inject 0 do | sum, card | sum + value(card) end
  end

  def value card
    card[:name].scan(/(?<=#{start_val})\d+(?=#{end_val})/)[0].to_i
  end
end
