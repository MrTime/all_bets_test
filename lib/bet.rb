class Bet
  def self.parse doc, &block
    doc.css('.selection-price').each_with_index do |link,i|
      if i%2 == 0
        params = /(\d+)@(\w*).(.*)/.match(link['id'])

        koeff = link.parent.css('.selection-link').inner_text.to_f
        value = /\((.+)\).*/.match(link.parent.content.strip)
        value = value.nil? ? nil : value[1]

        options = {
          :event_id => params[1],
          :koeff => koeff,
          :category => params[2],
          :value => value,
          :bet => params[3]
        }
        yield options
      end
    end
  end
end
