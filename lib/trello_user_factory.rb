require 'trello'

include Trello

class TrelloUserFactory
  def generate config, trello
    trello.configure do | tconfig |
      tconfig.developer_public_key = config["key"]
      tconfig.member_token = config["token"]
    end
    Member.find config["member"]
  end
end
