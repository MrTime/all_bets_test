require './lib/leagure'

describe Leagure do
  before(:each) do
    Leagure.stub(:bets_url).and_return('spec/support/bets.html')
    Leagure.stub(:more_bets_url).and_return('spec/support/more_bets.json')
  end

  let(:parser) { Parser.new :sport_id => 11 }
  let(:leagure) { { :parser => parser, :name => "leagure", :href => "link" } }

  it 'should create bets' do
    Bet.should_receive(:parse).exactly(3).times
    Leagure.parse leagure

    parser.wait_for_tasks
  end
end
