require "jbs/job"
require_relative "../spec_helper"

describe Jbs::Job do

  let(:repo) {double('repo') }
  let(:branch) { 'master' }
  let(:task) { 'rake::task' }
  let(:job) { Jbs::Job.new(:repo => repo, :branch => branch, :task => task) }


  subject { job }

  its(:branch) { should eq('master') }
  its(:task) { should eq('rake::task') }
  its(:built) { should be_false }
  its(:sha) { should eq(nil) }
  its(:pending?) { should be_true }

  describe "#sync_with_repo" do
    before { subject.sha = "some-sha" }
    context "repo matches" do
      before do
        repo.should_receive(:sha_for).with('master').and_return("some-sha")
        subject.sync_with_repo
      end
      its(:built) { should be_true }
      its(:pending?) { should be_false }
    end
    context "repo doesn't match" do
      before do
        repo.should_receive(:sha_for).with('master').and_return("some-other-sha")
        subject.sync_with_repo
      end
      its(:built) { should be_false }
      its(:pending?) { should be_true }
    end
  end

  describe "#new_run" do
    before { job.sha = "some-sha" }
    subject { job.new_run }
    its(:sha) { should eq('some-sha') }
    its(:job) { should eq(job) }
  end

  describe "#update" do
    before do
      job.update(1, 'Lemons')
    end
    its(:status){ should eq(1) }
    its(:output){ should eq('Lemons') }
  end
end
