require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")
require './lib/parser'

describe Parser do
  before(:each) do
    Parser.any_instance.stub(:leagures_url).and_return('spec/support/leagures.html')
  end

  let(:parser) { Parser.new :sport_id => 11 }


  it 'should store sport id' do
    parser.sport_id.should eq 11
  end

  it 'should create leagures' do
    Leagure.should_receive(:parse).twice.with(:href => 'link', :name => 'country. name', :parser => anything())

    parser.parse
  end

  it 'should call block with bet options' do
    Leagure.stub(:parse).and_yield("new bet")

    parser.parse do |bet|
      bet.should eq "new bet"
    end
  end

  it 'should generate url for getting leagures list' do
    Parser.any_instance.unstub(:leagures_url)
    parser.leagures_url.should eq 'http://www.marathonbet.com/ru/tree-node.htm?nodeId=11'
  end
end
