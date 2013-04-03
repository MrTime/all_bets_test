require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require './lib/leagure'

describe Leagure do
  let(:parser) { Parser.new :sport_id => 11 }
  let(:leagure) { { :parser => parser, :name => "leagure", :href => "link" } }

  it 'should create bets' do
    Leagure.stub(:bets_url).and_return('spec/support/bets.html')
    Leagure.stub(:more_bets_url).and_return('spec/support/more_bets.json')

    Bet.should_receive(:parse).exactly(3).times
    Leagure.parse leagure

    parser.wait_for_tasks
  end

  it 'should generate bets url' do
    Leagure.bets_url('href').should eq 'http://www.marathonbet.com/href'
  end

  it 'should generate more bets url' do
    Leagure.more_bets_url('111').should eq 'http://www.marathonbet.com/ru/markets.htm?isHotPrice=false&treeId=111'
  end
end
