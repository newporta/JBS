require "jbs/log"
require_relative "../spec_helper"

describe Jbs::Log do

  let(:logger_instance){ Jbs::Log.logger }

  %i{debug info warn error fatal unknown}.each do |message|
    describe ".#{message}" do
      it "delegates #{message} to the standard logger" do
        logger_instance.should_receive(message).with "lemons"
        Jbs::Log.send(message, "lemons")
      end
    end
  end

  describe ".configure" do
    it "sets the log level on the logger instance" do
      Jbs::Log.configure(Jbs::Log::WARN)
      expect(logger_instance.level).to eq(Jbs::Log::WARN)
    end

    it "defaults to STDOUT" do
      Logger.should_receive(:new).with(STDOUT).and_call_original
      Jbs::Log.configure(Jbs::Log::WARN)
    end

    it "allows files to be set" do
      Logger.should_receive(:new).with('tmp/jbs.log').and_call_original
      Jbs::Log.configure(Jbs::Log::WARN, 'tmp/jbs.log')
    end

  end

end
