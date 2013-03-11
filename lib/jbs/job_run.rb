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
      pipe = in_directory(job.repo.dirname) do
        IO.popen(command)
      end
      output = pipe.read
      Process.wait pipe.pid

      job.update($?.exitstatus, output)
    end

    def command
      "git checkout #{job.sha} && git reset head --hard && bundle exec rake #{job.task} 2>&1"
    end
  end
end
