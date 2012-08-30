$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + "/../../lib")

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

  describe "queue_jobs" do
    before :each do
      @queue = []
    end

    it "queues jobs when the sha has changed" do
      @queue.size.must_equal 0
      @repo.queue_jobs @queue
      @queue.size.must_equal 1
    end

    it "doesn't queue jobs when there's no change" do
      @current_sha = `git rev-parse master`
      @queue.size.must_equal 0
      @jobs[0][:sha] = @current_sha
      @repo.queue_jobs @queue

      @queue.size.must_equal 0
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

end
