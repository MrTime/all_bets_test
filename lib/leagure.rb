require './lib/bet'

class Leagure
  def self.parse options, &block
    @parser, @name, @href = options[:parser], options[:name], options[:href]

    doc = Nokogiri::HTML(open(bets_url(@href)))

    doc.css('.event-more-view').each do |link|
      more_view_id = /event-more-view-(\d+)/.match(link['id'])

      @parser.start_task more_bets_url(more_view_id[1]) do |url|
        more_json_doc = JSON.parse open(url).read
        more_doc = Nokogiri::HTML(more_json_doc['HTML'])

        opts = {
          :doc => more_doc,
          :leagure => @name,
          :main_category => "addition"
        } 
        Bet.parse opts, &block
      end
    end

    opts = {
      :doc => doc,
      :leagure => @name,
      :main_category => "main"
    } 
    Bet.parse opts, &block
  end

  def self.bets_url(href)
    "http://www.marathonbet.com/#{href}"
  end

  def self.more_bets_url(id)
    "http://www.marathonbet.com/ru/markets.htm?isHotPrice=false&treeId=#{id}"
  end

end
