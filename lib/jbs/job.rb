module Jbs
  class Job
    attr_accessor :repo, :branch, :sha, :task, :status, :output, :built

    def initialize(opts)
      self.repo = opts.fetch(:repo)
      self.branch = opts.fetch(:branch)
      self.task = opts.fetch(:task)
      self.sha = opts.fetch(:sha, nil)
      self.built = false
    end

    def sync_with_repo
      old_sha = sha
      self.sha = repo.sha_for(branch)
      self.built = old_sha == sha
    end

    def pending?
      !built
    end

    def update(status, output)
      self.status = status
      self.output = output
    end

    def new_run
      JobRun.new(self)
    end
  end
end
