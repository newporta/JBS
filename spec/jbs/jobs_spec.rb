require "jbs/jobs"
require_relative "../spec_helper"

describe Jbs::Jobs do

  let(:repo) { double("repo") }
  let(:job) { Jbs::Job.new(:repo => repo, :branch => '', :task => '') }
  before { repo.stub(:sha_for) }

  subject(:jobs) { Jbs::Jobs.new }
  its(:jobs) { should be_empty }
  its(:queue) { should be_empty }

  describe "#add" do
    before { jobs.add(job) }
    its(:jobs) { should_not be_empty }
  end

  context "with job" do
    before { jobs.add(job) }
    describe "#update" do
      before { job.should_receive(:sync_with_repo) }
      it "calls sync on it's jobs" do
        job.stub(:pending?) { false }
        jobs.update
      end
      it "queues pending jobs" do
        job.stub(:pending?) { true }
        jobs.update
        jobs.should be_pending
      end
    end

    context "with no jobs pending" do
      before { jobs.update }
      its(:pending?) { should be_false }
      its(:run_next) { should be_nil }
    end

    context "with jobs pending" do
      let(:job_run) { double("job_run") }
      before do
        job.stub(:pending?).and_return(:true)
        job.stub(:new_run).and_return(job_run)
        jobs.update
      end

      its(:pending?) { should be_true }
      describe "#run_next" do
        it "should run the job" do
          job_run.should_receive(:run)
          subject.run_next
        end
      end
    end
  end
end
