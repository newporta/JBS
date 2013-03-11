require "jbs/util/in_directory"
require "rspec"

class Dummy
end

describe Jbs::Util::InDirectory do
  subject { d = Dummy.new; d.extend(Jbs::Util::InDirectory); d }
  describe "#with_dir" do
    context "no dir passed in" do
      it "raises an exception" do
        expect { subject.in_directory{ `pwd`.strip } }.to raise_exception
      end
    end
    context "it has a dirname method" do
      it "executes in the context of the directory provided" do
        subject.in_directory('..'){ `pwd`.strip }.should == File.expand_path(File.join(Dir.pwd, '..'))
      end
    end
  end
end

