class ActionTransformer
  def transform action
    { 'id' => action.id, 'type' => action.type, 'column' => action.data['list'], 'card_id' => action.data['card']['id'], 'time' => action.date.to_i }
  end
end
