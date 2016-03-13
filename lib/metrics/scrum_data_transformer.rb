class ScrumDataTransformer
  def transform summaries, columns, iteration
    column_id = (columns.select do |column| column["name"] == iteration["end"] end)[0]["id"]
    days = summaries.select do | row | Time.parse(row["date_time"]).wday == iteration['start_day'] end
    totals = days.map do | column | column[column_id] end
    velocities totals
  end

  private

  def velocities totals
    totals.each_with_index.map do | total, index |
      velocity = totals[index + 1] - total if totals[index + 1]
      velocity
    end.compact
  end
end
