module Jbs
  class Job
    attr_accessor :branch, :sha, :task, :status, :output, :built

    def initialize(branch, task)
      @branch = branch
      @task = task
    end

    def run
      puts "Running #{branch} #{task}!"

      pipe = IO.popen("git checkout #{branch} && git reset head --hard && bundle exec rake #{task} 2>&1")
      output = pipe.read
      Process.wait pipe.pid

      self.status = $?
      self.output = output
      self.built = true

      puts "Result: #{status}"
      puts "#{output}"
    end

    def update(repo)
      new_sha = repo.sha_for branch
      if new_sha != sha
        self.sha = new_sha
        self.built = false
      end
    end
  end
end
