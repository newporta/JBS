module Jbs
  class Repo
    def initialize(jobs)
      @jobs = jobs
      @next_poll = Time.now
    end

    def poll
      `git fetch`
      raise "Oh Noes - couldn't FETCH!" if $? != 0
      increment_timer
    end

    def poll_now?
      @next_poll < Time.now
    end

    def increment_timer
      @next_poll = Time.now + 60
    end

    def sha_for branch
      result = `git rev-parse #{branch} 2>&1`
      result =~ /fatal/ ? nil : result
    end
  end
end
