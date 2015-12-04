class CardSummarizer
  def summerize cards
    grouped = cards.group_by do |card| card[:column_id] end
    grouped.each do |k, v| grouped[k] = v.length end
    { 'date_time' => Time.now }.merge grouped
  end
end
