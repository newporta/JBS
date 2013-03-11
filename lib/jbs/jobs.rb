require "jbs/job_run"

module Jbs
  class Jobs
    attr_accessor :jobs, :queue
    def initialize
      self.jobs = []
      self.queue = []
    end

    def add(job)
      jobs << job
    end

    def update
      jobs.map(&:sync_with_repo)
      refresh_queue
    end

    def run_next
      return unless pending?
      queue.shift.run
    end

    def pending?
      queue.any?
    end

    private

    def refresh_queue
      jobs.select(&:pending?).each do |pending_job|
        queue << pending_job.new_run
      end
    end
  end
end
