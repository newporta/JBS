require "jbs/master"
require "jbs/jobs"
require_relative "../spec_helper"

describe Jbs::Master do
  let(:repo) { double("repo") }
  let(:jobs) { Jbs::Jobs.new }
  let(:polling_strategy) { double("strategy") }

  before do
    repo.stub(:sha_for)
    jobs.stub(:repos).and_return([repo])
  end

  let(:master){ Jbs::Master.new(jobs, polling_strategy) }
  
  describe "#run_jobs" do
    context "with jobs pending" do
      before{ jobs.stub(:pending?).and_return(true) }
      it "runs the next job and returns true" do
        jobs.should_receive(:run_next)
        expect(master.run_jobs).to eq(true)
      end
    end
    context "with no jobs pending" do
      before{ jobs.stub(:pending?).and_return(false) }
      it "does nothing and returns false" do
        expect(master.run_jobs).to eq(false)
      end
    end
  end

  describe "#poll" do
    context "with poll pending" do
      before{ polling_strategy.stub(:poll_now?).and_return(true) }
      it "polls and updates jobs" do
        repo.should_receive(:poll)
        jobs.should_receive(:update)
        expect(master.poll).to eq(true)
      end
    end
    context "with no poll pending" do
      before{ polling_strategy.stub(:poll_now?).and_return(false) }
      it "does nothing and returns false" do
        expect(master.poll).to eq(false)
      end
    end
  end

  describe "#run" do
    # Infinite loops are pretty hard to cleanly test...
    before do
      master.stub(:running?) { @second_time ?  false : @second_time = true }
    end
    context "with jobs pending" do
      before{ jobs.stub(:pending?).and_return(true) }
      it "runs the next job and returns true" do
        jobs.should_receive(:run_next)
        master.run
      end
    end
    context "with poll pending" do
      before{ polling_strategy.stub(:poll_now?).and_return(true) }
      it "polls and updates jobs" do
        repo.should_receive(:poll)
        jobs.should_receive(:update)
        master.run
      end
    end
    context "with nothing to do" do
      before{ polling_strategy.stub(:poll_now?).and_return(false) }
      it "sleeps" do
        master.should_receive(:sleep)
        master.run
      end
    end
  end

  describe "#running?" do
    it "returns true" do
      expect(master.running?).to eq(true)
    end
  end

end
