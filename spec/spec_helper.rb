require 'gimme'
require 'simplecov'
require 'json'

LEAD_START_COLUMN = 'lead_start'
LEAD_START_OLD_COLUMN = 'lead_start_old'
LEAD_START_COLUMNS = [LEAD_START_COLUMN, LEAD_START_OLD_COLUMN]
CYCLE_START_COLUMN = 'cycle_start'
CYCLE_START_OLD_COLUMN = 'cycle_start_old'
CYCLE_START_COLUMNS = [CYCLE_START_COLUMN, CYCLE_START_OLD_COLUMN]
DONE_COLUMN = 'done'
DONE_OLD_COLUMN = 'done_old'
END_COLUMNS = [DONE_COLUMN, DONE_OLD_COLUMN]


CONFIG = {
  'member' => 'MEMBER_NAME',
  'key' => 'KEY_VALUE',
  'secret' => 'SECRET_VALUE',
  'token' => 'TOKEN_VALUE',
  'datadir' => 'SOME_DATA_DIR',
  'boards' => [{
    'name' => 'Operations Automation Backlog',
    'type' => 'kanban',
    'lead_time' => { 'start' => LEAD_START_COLUMNS, 'end' => END_COLUMNS },
    'cycle_time' => { 'start' => CYCLE_START_COLUMNS, 'end' => END_COLUMNS },
    'exclude_columns' => ['exclude_1'],
    'graphdef' => { 'some' => 'hash_values' }
  },
               {
                 'name' => 'Example Other Board',
                 'type' => 'scrum',
                 'delimiter' => { 'start' => '(', 'end' => ')' },
                 'iteration' => { 'start_day' => 1, 'length' => 2, 'end' => 'Done' },
                 'exclude_columns' => ['exclude_1'],
                 'graphdef' => { 'some' => 'hash_values' }
               }],
  'exclude_columns' => ['exclude_1'],
  'graphdef' => { 'some' => 'hash_values' }
}.freeze

def no_methods_called_on_object a_test_double
  verification = verify(a_test_double, 0)
  (verification.__gimme__cls.instance_methods - Object.methods).each do |method_name|
    method = verification.__gimme__cls.instance_method method_name
    verification.send method_name, *(Array.new method.arity, anything)
  end
end

SimpleCov.start do
  add_filter '/spec/'
end

module Gimme
  class MultiCaptor
    attr_reader :values

    def values
      @values ||= []
    end

    def value
      values.last
    end

    def value= arg
      values << arg
    end

    private

    attr_writer :values
  end
end

module MyMatchers
  def verify_never test_double
    verify(test_double, 0)
  end

  def verify_never! test_double
    verify!(test_double, 0)
  end
end

RSpec.configure do |config|
  config.mock_framework = Gimme::RSpecAdapter
  config.include MyMatchers
end
