require 'spec_helper'
require 'array_transformer'

describe ArrayTransformer do
  let(:item_transformer) { gimme }
  let(:item_1) { 'blah' }
  let(:item_2) { 'blarg' }
  let(:item_3) { 'she' }
  let(:result_1) { 'foo' }
  let(:result_2) { 'bar' }
  let(:result_3) { 'bang' }
  let(:transformer) { ArrayTransformer.new item_transformer }

  before(:each) {
    give(item_transformer).transform(item_1) { result_1 }
    give(item_transformer).transform(item_2) { result_2 }
    give(item_transformer).transform(item_3) { result_3 }
  }

  it 'will transform an array of items into an array of results' do
    expect(transformer.transform [item_1, item_2, item_3]).to eq [result_1, result_2, result_3]
  end

  context ', when one item is transformed to nil' do
    before(:each) {
      give(item_transformer).transform(item_1) { result_1 }
      give(item_transformer).transform(item_2) { result_2 }
      give(item_transformer).transform(item_3) { nil }
    }

    it 'will transform an array of items into an array of results' do
      expect(transformer.transform [item_1, item_2, item_3]).to eq [result_1, result_2]
    end
  end
end
