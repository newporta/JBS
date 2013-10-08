require "jbs/config"
require "jbs/repo"
require "jbs/job"
require_relative "../spec_helper"

describe Jbs::Config do
  subject { Jbs::Config.new }

  describe "defaults" do
    it "should have an empty jobs object" do
      expect(subject.jobs.jobs).to eq([])
    end
  end

  describe "parsing jobstrings" do
    subject { Jbs::Config.parse(['-j', '.:master:spec,.:otherbranch:otherjob']) }
    it "creates the required repo" do
      expect(subject.jobs.jobs.first.repo.dirname).to eq('.')
    end

    it "creates all of the jobs passed in" do
      job1 = subject.jobs.jobs[0]
      job2 = subject.jobs.jobs[1]
      expect(job1.branch).to eq('master')
      expect(job1.task).to eq('spec')
      expect(job2.branch).to eq('otherbranch')
      expect(job2.task).to eq('otherjob')

      expect(job1.repo).to eq(job2.repo)
    end
  end
end
