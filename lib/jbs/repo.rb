require "jbs/util/in_directory"
module Jbs
  class Repo
    include Jbs::Util::InDirectory

    attr_accessor :dirname
    def initialize(dirname)
      self.dirname = dirname
    end

    def poll
      in_directory(dirname) do
        `#{git_fetch_command}`
      end
      raise "Oh Noes - couldn't FETCH!" if $? != 0
    end

    def sha_for branch
      in_directory(dirname) do
        result = `git rev-parse #{branch} 2>&1`
        result =~ /fatal/ ? nil : result.strip
      end
    end

    private
    def git_fetch_command
      "git fetch"
    end
  end
end
