require 'spec_helper'
require 'metrics/card_activity_transformer'

describe CardActivityTransformer do
  let(:type1) { 'some_column' }
  let(:type2) { 'some_other_column' }
  let(:time1) { 1448736565 }
  let(:time2) { 1448736569 }
  let(:time3) { 1449174314 }
  let(:created_date) { '2015-11-28T12:49:25.000-06:00' }
  let(:created_date_to_i) { 1448736565 }
  let(:nil_activity1) { { 'column' => nil, 'time' => 1449174263 } }
  let(:nil_activity2) { { 'column' => nil, 'time' => 1449174263 } }
  let(:type_activity1) { { 'column' => { 'name' => type1 }, 'time' => time1 } }
  let(:type_activity2) { { 'column' => { 'name' => type1 }, 'time' => time2 } }
  let(:type_activity3) { { 'column' => { 'name' => type1 }, 'time' => time3 } }
  let(:type2_activity1) { { 'column' => { 'name' => type2 }, 'time' => time1 + 6000 } }
  let(:type2_activity2) { { 'column' => { 'name' => type2 }, 'time' => time2 + 7000 } }
  let(:type2_activity3) { { 'column' => { 'name' => type2 }, 'time' => time3 + 8000 } }
  let(:card) { { 'created_date' => created_date, 'actions' => actions } }
  let(:transformer) { CardActivityTransformer.new }

  context ', when there is only one action' do
    let(:actions) { [type_activity1] }

    it 'will capture the created and the column dates' do
      expected = { 'created_date' => created_date_to_i, type1 => time1 }
      expect(transformer.transform card).to eq expected
    end
  end

  context ', when there are two actions' do
    let(:actions) { [type_activity2, type_activity1] }

    it 'will capture the created and the column dates' do
      expected = { 'created_date' => created_date_to_i, type1 => time1 }
      expect(transformer.transform card).to eq expected
    end
  end

  context ', when there are three actions' do
    let(:actions) { [type_activity2, type_activity1, type_activity3] }

    it 'will capture the created and the column dates' do
      expected = { 'created_date' => created_date_to_i, type1 => time1 }
      expect(transformer.transform card).to eq expected
    end
  end

  context ', when there are three actions' do
    let(:actions) { [type_activity2, type_activity1, type_activity3] }

    it 'will capture the created and the column dates' do
      expected = { 'created_date' => created_date_to_i, type1 => time1 }
      expect(transformer.transform card).to eq expected
    end
  end

  context ', when there are nil actions' do
    let(:actions) { [type_activity2, type_activity1, nil_activity1] }

    it 'will capture the created and the column dates' do
      expected = { 'created_date' => created_date_to_i, type1 => time1 }
      expect(transformer.transform card).to eq expected
    end
  end

  context ', when there are multiple types of actions' do
    let(:actions) { [type_activity2, type_activity1, type2_activity1] }

    it 'will capture the created and the column dates' do
      expected = { 'created_date' => created_date_to_i, type1 => time1, type2 => time1 + 6000 }
      expect(transformer.transform card).to eq expected
    end
  end

  context ', when there are multiple types of actions' do
    let(:actions) { [type_activity2, type_activity1, type2_activity1] }

    it 'will capture the created and the column dates' do
      expected = { 'created_date' => created_date_to_i, type1 => time1, type2 => time1 + 6000 }
      expect(transformer.transform card).to eq expected
    end
  end

  context ', when there are multiple types of actions' do
    let(:actions) { [type_activity2, type_activity1, type2_activity1, type_activity3, nil_activity1, type2_activity2, type2_activity3, nil_activity2] }

    it 'will capture the created and the column dates' do
      expected = { 'created_date' => created_date_to_i, type1 => time1, type2 => time1 + 6000 }
      expect(transformer.transform card).to eq expected
    end
  end
end
