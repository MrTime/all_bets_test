class Leagure
  def self.parse options
    @parser, @name, @href, @parser = options[:parser], options[:name], options[:href], options[:parser]

    url = "http://www.marathonbet.com/#{@href}"
    doc = Nokogiri::HTML(open(url))
    doc.css('.event-more-view').each do |link|
      more_view_id = /event-more-view-(\d+)/.match(link['id'])

      more_url = "http://www.marathonbet.com/ru/markets.htm?isHotPrice=false&treeId=#{more_view_id[1]}"
      @parser.threads << Thread.new(more_url) do |url|
        puts more_url
        more_json_doc = JSON.parse open(more_url).read
        more_doc = Nokogiri::HTML(more_json_doc['HTML'])

        @parser.parse_doc_bets more_doc
      end
    end

    @parser.parse_doc_bets doc
  end

end
