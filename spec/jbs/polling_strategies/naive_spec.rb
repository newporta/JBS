require "jbs/polling_strategies/naive"
require "rspec"

describe Jbs::PollingStrategies::Naive do
  subject{Jbs::PollingStrategies::Naive.new}

  its(:poll_now?){ should be_true }

  context "after poll query" do
    before do
      subject.poll_now?
    end
    its(:poll_now?) { should be_false }
  end
end
