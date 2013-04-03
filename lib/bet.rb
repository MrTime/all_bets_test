class Bet
  def self.parse doc, &block
    doc.css('.selection-price').each_with_index do |link,i|
      if i%2 == 0
        params = /(\d+)@(.*)/.match(link['id'])

        koeff = link.parent.css('.selection-link').inner_text.to_f
        value = /\((.+)\).*/.match(link.parent.content.strip)
        value = value.nil? ? nil : value[1]
        rel = link.parent['rel']
        category = params[2]
        
        period = if category.include? '1st_Half'
                   '1st_Half'
                 elsif category.include? '2nd_Half'
                   '2nd_Half'
                 else
                   'Full_Match'
                 end

        options = {
          :event_id => params[1],
          :koeff => koeff,
          :category => category,
          :value => value,
          :period => period,
          :rel => rel
        }
        yield options
      end
    end
  end
end
