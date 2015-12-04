class CardCreatedDate
  def parse id
    Time.at id[0...8].to_i 16
  end
end
