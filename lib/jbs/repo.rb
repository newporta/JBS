module Jbs
  class Repo
    def initialize(jobs)
      @jobs = jobs
      @next_poll = Time.now
    end

    def poll_now?
      @next_poll < Time.now
    end

    def poll
      `git fetch`
      raise 'Oh Noes FETCH!' if $? != 0
      increment_timer
    end

    def increment_timer
      @next_poll = Time.now + 60
    end

    def queue_jobs queue
      @jobs.each do |job|
        current_sha = sha_for job[:branch]
        raise 'Oh Noes SHA!' if $? != 0
        if job[:sha] != current_sha
          job[:sha] = current_sha
          queue << job
        end
      end
    end

    def sha_for branch
      `git rev-parse #{branch}`
    end
  end
end
