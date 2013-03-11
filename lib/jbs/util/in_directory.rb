module Jbs
  module Util
    module InDirectory
      def in_directory dirname, &block
        Dir.chdir(dirname) do
          block.call
        end
      end
    end
  end
end
