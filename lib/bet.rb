class Bet
  def self.parse options, &block
    @events = {}
    @leagure = options[:leagure]
    doc = options[:doc]

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
          :event => get_event(params[1], link),
          :rel => rel
        }
        yield options
      end
    end
  end

  def self.get_event id, link
    return @events[id] unless @events[id].nil?

    event_root = link.parent.parent
    teams = event_root.css('.member-name')
    event_date = DateTime.parse(event_root.css('.date').first.inner_text.strip)

    @events[id] = {
            :home => teams[0].inner_text,
            :guess => teams[1].content,
            :leagure => @leagure,
            :date => event_date.to_date,
            :time => event_date.strftime("%H:%M")
          }
  end
end
