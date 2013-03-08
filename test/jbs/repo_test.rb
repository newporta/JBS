$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/../../lib")

require "rubygems"
require "minitest/autorun"
require "jbs/repo"

describe Jbs::Repo do
  before :each do
    @jobs = [{:branch => "master", :sha => ""}]
    @repo = Jbs::Repo.new @jobs
  end

  describe "poll_now?" do
    it "returns true when it should" do
      @repo.poll_now?.must_equal true
    end

    it "returns false when it should" do
      @repo.increment_timer
      @repo.poll_now?.must_equal false
    end
  end

  describe 'poll' do
    it "polls git" do
      @repo.poll
    end

    it "increments the timer" do
      @repo.poll_now?.must_equal true
      @repo.poll
      @repo.poll_now?.must_equal false
    end
  end

  describe 'sha_for' do
    it "returns the current sha" do
      @current_sha = `git rev-parse master`
      @repo.sha_for('master').must_equal @current_sha
    end

    it "returns nil for non existant branches" do
      @repo.sha_for('lemons').must_equal nil
    end
  end
end
