module Jbs
  trap('INT'){ $interrupted = true }

  class << self
    def just_build_stuff(repo)
      queue = []
      loop do
        break if $interrupted
        if queue.any?
          job = queue.shift
          run job
        elsif repo.poll_now?
          repo.poll
          repo.queue_jobs(queue)
        else
          sleep 10
        end
      end
    end

    def run job
      puts "Running #{job[:branch]} #{job[:task]}"
      pipe = IO.popen("git checkout #{job[:sha]} && git reset head --hard && bundle exec rake #{job[:task]} 2>&1")
      output = pipe.read
      Process.wait pipe.pid
      job[:status => $0]
      job[:output => output]

      puts "Result: #{job[:status]}"
      puts "#{job[:output]}"
    end

  end
end
