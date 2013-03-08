require "jbs/version"
require "jbs/master"
require "jbs/repo"
require "jbs/job"

module Jbs
  class << self
    def just_build_stuff(repo)
      Master.new(repo).run
    end
  end
end
