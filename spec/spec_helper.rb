require 'gimme'
require 'simplecov'
require 'json'

LEAD_START = 'lead_start'
LEAD_START_OLD = 'lead_start_old'
CYCLE_START = 'cycle_start'
CYCLE_START_OLD = 'cycle_start_old'
DONE = 'done'
DONE_OLD = 'done_old'


CONFIG = {
  'member' => 'MEMBER_NAME',
  'key' => 'KEY_VALUE',
  'secret' => 'SECRET_VALUE',
  'token' => 'TOKEN_VALUE',
  'datadir' => 'SOME_DATA_DIR',
  'boards' => [{
    'name' => 'Operations Automation Backlog',
    'type' => 'kanban',
    'lead_time' => { 'start' => LEAD_START, 'end' => DONE },
    'cycle_time' => { 'start' => CYCLE_START, 'end' => DONE },
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
