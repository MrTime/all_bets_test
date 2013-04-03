class Bet
  def self.parse doc, &block
    doc.css('.selection-price').each_with_index do |link,i|
      if i%2 == 0
        params = /(\d+)@(\w*).(.*)/.match(link['id'])
        options = {
          :event_id => params[1],
          :category => params[2],
          :bet => params[3]
        }
        yield options
      end
    end
  end
end
