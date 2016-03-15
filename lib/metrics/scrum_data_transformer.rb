class ScrumDataTransformer
  def transform summaries, columns, iteration
    column_id = column_id columns, iteration
    days = days summaries, iteration
    totals = days.map do |column| column[column_id].to_i end
    velocities totals.compact
  end

  private

  def column_id columns, iteration
    (columns.select do |column| column['name'] == iteration['end'] end)[0]['id']
  end

  def days summaries, iteration
    summaries.select do |row| Time.parse(row['date_time']).wday == iteration['start_day'] end
  end

  def velocities totals
    totals.each_with_index.map do |total, index|
      velocity = totals[index + 1] - total if totals[index + 1]
      velocity
    end.compact
  end
end
