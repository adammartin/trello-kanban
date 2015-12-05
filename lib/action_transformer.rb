require 'time'

class ActionTransformer
  def transform action
    { 'id' => action.id, 'type' => action.type, 'list' => action.data['list'], 'card_id' => action.data['card']['id'], 'time' => Time.parse(action.date).to_i }
  end
end
