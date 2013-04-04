class Bet
  def self.parse options, &block

    @events = {}
    @leagure = options[:leagure]
    @parser = options[:parser]
    @total_bets_count ||= 0
    @processed_bets ||= 0
    doc = options[:doc]

    all_bets = doc.css('.selection-price')
    @total_bets_count += all_bets.size / 2

    all_bets.each_with_index do |link,i|
      if i%2 == 0

        begin
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


          opts = {
            :event_id => params[1],
            :koeff => koeff,
            :category => category,
            :value => value,
            :period => period,
            :event => get_event(params[1], link),
            :rel => rel,
            :progress =>"#{@processed_bets}/#{@total_bets_count}"

          }
          yield opts

          @processed_bets += 1
        rescue Exception => e
          puts "Error occured for bet: #{link.inspect}. From #{options[:href]} leagure. Error #{e}"
        end
      end
    end
  end

  def self.get_event id, link
    if @events[id].nil? or !@events[id][:pending].nil?

      event_root = link.parent.parent.parent
      while event_root.name != "tbody"
        event_root = event_root.parent
      end

      teams = event_root.css('.member-name, .today-member-name')

      if teams.nil?
        event = {:pending => true}
      else
        event_date = DateTime.parse(event_root.css('.date').first.inner_text.strip)

        if teams.nil? or teams.empty?
          puts "TEAMS is null for event #{id}"
          event = {:id => id}
        else

          event = {
            :id => id,
            :home => teams[0].content,
            :guess => teams[1].content,
            :leagure => @leagure,
            :date => event_date.to_date,
            :time => event_date.strftime("%H:%M")
          }

        end
      end
    else

      event = @events[id] 
    end

    @events[id] = event
  end
end
