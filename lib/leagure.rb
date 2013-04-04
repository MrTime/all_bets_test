require './lib/bet'

class Leagure
  def self.parse options, &block
    @parser, @name, @href = options[:parser], options[:name], options[:href]

    doc = Nokogiri::HTML(open(bets_url(@href)))

    Bet.parse bet_options(doc,'main'), &block
    doc.css('.event-more-view').each do |link|
      more_view_id = /event-more-view-(\d+)/.match(link['id'])

      @parser.start_task more_bets_url(more_view_id[1]) do |url|
        begin
          more_json_doc = JSON.parse open(url).read
          more_doc = Nokogiri::HTML(more_json_doc['HTML'])

          Bet.parse bet_options(doc,'addition'), &block
        rescue Exception => e
          puts "error occured while loading #{url}"
        end
      end
    end

  end

  def self.bet_options(doc, category)
    opts = {
      :doc => doc,
      :leagure => @name,
      :parser => @parser,
      :main_category => category
    }
  end

  def self.bets_url(href)
    "http://www.marathonbet.com/#{href}"
  end

  def self.more_bets_url(id)
    "http://www.marathonbet.com/ru/markets.htm?isHotPrice=false&treeId=#{id}"
  end

end
