require 'optparse'

module Jbs
  class Config
    attr_accessor :jobs

    def initialize
      self.jobs = Jbs::Jobs.new
    end

    def self.parse(args)
      config = new

      parser = OptionParser.new do |opts|
        opts.banner = "Usage: jbs [options]"

        opts.on("-j", "--job JOBSTRING1,JOBSTRING2", Array, "Specify the repo directory, branch name and rake tasks to run", "JOBSTRING format = repo:branch:task") do |jobstrings|
          jobstrings.each do |jobstring|
            repo_dirname, branch, task = jobstring.split(':')
            unless repo = config.jobs.repos.find{|r| r.dirname == repo_dirname }
              repo = Jbs::Repo.new(repo_dirname)
            end
            config.jobs.add Job.new(repo: repo, branch: branch, task: task)
          end
        end

        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
      end

      parser.parse!(args)

      config
    end
  end
end
