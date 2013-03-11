module Jbs
  module PollingStrategies
    class Naive
      attr_accessor :next_poll
      def initialize
        self.next_poll = Time.now
      end

      def poll_now?
        if next_poll < Time.now
          increment_timer
          true
        else
          false
        end
      end

      private
      def increment_timer
        self.next_poll = Time.now + 60
      end
    end
  end
end
