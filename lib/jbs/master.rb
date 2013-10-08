class Jbs::Master
  trap('INT') { $interrupted = true }

  attr_accessor :repos, :polling_strategy, :jobs

  def initialize(jobs, repos, polling_strategy)
    self.jobs = jobs
    self.repos = repos
    self.polling_strategy = polling_strategy
  end

  def run
    while running? do
      run_jobs || poll || sleep(20)
    end
  end

  def run_jobs
    jobs.pending? ? run_next_job : false
  end

  def poll
    polling_strategy.poll_now? ? poll_and_update : false
  end

  def running?
    true unless $interrupted
  end

  private

  def run_next_job
    jobs.run_next
    true
  end

  def poll_and_update
    poll_repos
    update_jobs
    true
  end

  def poll_repos
    repos.map(&:poll)
  end

  def update_jobs
    jobs.update
  end
end
