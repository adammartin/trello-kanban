require 'spec_helper'
require 'trello_user_factory'

include Trello

describe TrelloUserFactory do
  let(:trello) { gimme() }
  let(:member) { gimme(Member) }
  let(:trello_config) { Configuration.new }
  let(:factory) { TrelloUserFactory.new }

  before(:each) {
    give(trello).configure { |block|
      block.call trello_config unless block.nil?
      trello_config
    }
    give(Member).find(CONFIG["member"]) {
      member
    }
  }

  it "properly configures trello authentication when initialized" do
    factory.generate CONFIG, trello
    expect(trello_config.developer_public_key).to eq CONFIG["key"]
    expect(trello_config.member_token).to eq CONFIG["token"]
  end

  it "will return a member" do
    expect(factory.generate CONFIG, trello).to eq member
  end
end
