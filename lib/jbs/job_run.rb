require "jbs/util/in_directory"
module Jbs
  class JobRun
    include Jbs::Util::InDirectory

    attr_accessor :job, :sha

    def initialize(job)
      self.job = job
      self.sha = job.sha
    end

    def run
      Jbs::Log.info("Job #{job.repo.dirname}:#{job.branch} starting.")

      output = in_directory(job.repo.dirname) do
       IO.popen(command) {|pipe| pipe.readlines.join }
      end

      status = $?.exitstatus

      log_result(status, output)
      job.update(status, output)
    end

    def command
      "git checkout #{job.sha} 2>&1 && git reset head --hard 2>&1 && bundle exec rake #{job.task} 2>&1"
    end

    private
    def log_result(status, output)
      Jbs::Log.info("JobRun for #{job.repo.dirname}:#{job.branch} #{status == 0 ? 'passed' : 'failed'}.")
      Jbs::Log.info("Output: #{output}")
    end
  end
end
