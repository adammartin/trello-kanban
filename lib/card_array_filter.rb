class CardArrayFilter
  def initialize required_activity_column
    self.required_activity_column = required_activity_column
  end

  def filter cards
    cards.delete_if do |card| !(actions_contain_column? card['actions']) end
  end

  private

  attr_accessor :required_activity_column

  def actions_contain_column? actions
    actions.any? do |action|
      return action['column']['name'] == required_activity_column if action['column']
      false
    end
  end
end
