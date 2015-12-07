require 'time'

class CardActivityTransformer
  def transform card
    result = { 'created_date' => Time.parse(card['created_date']).to_i }
    append_lowest_column_times result, group(card['actions'])
  end

  private

  def group actions
    actions.delete_if { |action| action['column'].nil? }.group_by { |action| action['column']['name'] }
  end

  def append_lowest_column_times result, grouped
    grouped.map { |k, v| { k => v.sort_by { |action| action['time'] }.first['time'] } }.each {|first|
      array = first.flatten
      result[array[0]] = array[1]
    }
    result
  end
end
