require "jbs/config"
require "jbs/repo"
require "jbs/job"
require_relative "../spec_helper"

describe Jbs::Config do
  subject { Jbs::Config.new }

  describe "defaults" do
    its(:jobs){ should eq([]) }
    its(:repos){ should eq([]) }
  end

  describe "parsing jobstrings" do
    subject { Jbs::Config.parse(['-j', '.:master:spec,.:otherbranch:otherjob']) }
    it "creates require repo" do
      expect(subject.repos.count).to eq(1)
    end

    it "creates all of the jobs passed in" do
      job1 = subject.jobs[0]
      job2 = subject.jobs[1]
      expect(job1.branch).to eq('master')
      expect(job1.task).to eq('spec')
      expect(job2.branch).to eq('otherbranch')
      expect(job2.task).to eq('otherjob')

      expect(job1.repo).to eq(job2.repo)
    end
  end
end
