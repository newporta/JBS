require "jbs/repo"
require "rspec"

# We're stubbing git here, it's api is pretty stable so we can _probably_ rely on it.

describe Jbs::Repo do

  subject { Jbs::Repo.new(".") }

  describe '#poll' do
    it "polls git" do
      subject.should_receive(:`).with("git fetch")
      subject.poll
    end

    it "raises when git fails" do
      subject.stub(:git_fetch_command).and_return("garbagecommandthatshouldfail") # grody, replace later if can be bothered...
      expect{ subject.poll }.to raise_error
    end
  end

  describe '#sha_for' do

    context 'with real branch' do
      let(:branch){ 'master' }
      it "returns the current sha" do
        subject.should_receive(:`).with("git rev-parse #{branch} 2>&1").and_return("something\n")
        subject.sha_for(branch)
      end
    end

    context "with non existent branches" do
      let(:branch){ 'lemon' }
      let(:git_failure_message) { "fatal: ambiguous argument '#{branch}': unknown revision or path not in the working tree.\n" }

      it "returns nil" do
        subject.stub(:`).and_return(git_failure_message)
        subject.sha_for(branch).should be_nil
      end
    end

  end
end
