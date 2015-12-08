class ActionTransformer
  def transform action
    { 'id' => action.id, 'type' => action.type, 'column' => action.data['listAfter'], 'card_id' => action.data['card']['id'], 'time' => action.date.to_i } if action.data['listAfter']
  end
end
