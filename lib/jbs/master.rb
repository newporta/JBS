class Jbs::Master
  trap('INT'){ $interrupted = true }

  attr_reader :repo, :queue, :jobs

  def initialize(repo, jobs)
    @queue = []
    @repo = repo
    @jobs = jobs
  end

  def run
    loop do
      break if $interrupted
      run_job || poll_repo || sleep(10)
    end
  end

  private

  def run_job
    if job = queue.shift
      job.run
      true
    else
      false
    end
  end

  def poll_repo
    if repo.poll_now?
      repo.poll
      queue_jobs
      true
    else
      false
    end
  end

  def queue_jobs
    jobs.each do |job|
      queue << job unless job.built
    end
  end
end
