$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/../../lib")

require "rubygems"
require "minitest/autorun"
require "jbs/job.rb"

describe Jbs::Job do
  describe '#update' do
    before :each do
      @current_sha = `git rev-parse master`
      @job = Jbs::Job.new 'master', 'some::rake::task'
      @job.sha = @current_sha
      @repo = MiniTest::Mock.new
      @job.built = true
    end

    it "updates itself when the repo has a different sha" do
      @repo.expect(:sha_for, 'a random sha', ['master'])
      @job.update(@repo)
      @job.sha.must_equal 'a random sha'
      @job.built.must_equal false
    end

    it "doesn't update itself when the sha hasn't changed" do
      @repo.expect(:sha_for, @current_sha, ['master'])
      @job.sha.must_equal @current_sha
      @job.built.must_equal true
    end
  end
end
