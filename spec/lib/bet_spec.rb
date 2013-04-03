require './lib/leagure'

describe Bet do

  let(:parser) { Parser.new :sport_id => 11 }
  let(:doc) { Nokogiri::HTML(open('spec/support/bets.html')) }

  it 'should understand values' do
    Bet.parse(doc) do |result|
      res = { :event_id => '805371', 
              :category => 'Match_Result', 
              :bet => '1'}
      result.should eq res
    end
    
  end
end
