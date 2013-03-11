require "jbs/version"
require "jbs/master"
require "jbs/repo"
require "jbs/jobs"
require "jbs/job"
require "jbs/job_run"
require "jbs/polling_strategies/naive"

module Jbs
  class << self
    def just_build_stuff(jobs, repo, polling_strategy)
      Master.new(jobs, repo, polling_strategy).run
    end
  end
end
