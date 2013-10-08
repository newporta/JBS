require "jbs/job_run"
require "jbs/job"
require_relative "../spec_helper"

describe Jbs::JobRun do
  let(:repo) { double('repo') }
  let(:branch) { 'master' }
  let(:task) { 'rake::task' }
  let(:job) { Jbs::Job.new(:repo => repo, :branch => branch, :task => task, :sha => 'sha') }
  before do
    repo.stub(:dirname).and_return('.')
  end

  subject(:job_run) { job.new_run }
  its(:command) { should eq("git checkout sha && git reset head --hard && bundle exec rake rake::task 2>&1") }

  describe "#run" do
    context "failing build" do
      before { job_run.stub(:command).and_return('echo "lemons" && exit 1') }
      it "updates the job correctly" do
        job.should_receive(:update).with(1, "lemons\n")
        job_run.run
      end
    end
    context "passing build" do
      before { job_run.stub(:command).and_return('echo "lemons"') }
      it "updates the job correctly" do
        job.should_receive(:update).with(0, "lemons\n")
        job_run.run
      end
    end
  end
end
