require 'logger'
require 'forwardable'
module Jbs
  module Log
    include Logger::Severity
    extend Forwardable
    extend self

    attr_accessor :logger
    self.logger = Logger.new(STDOUT)

    def configure(level, location = STDOUT)
      self.logger = Logger.new(location)
      self.logger.level = level
    end

    def_delegators :logger, :unknown, :fatal, :error, :warn, :info, :debug
  end
end

