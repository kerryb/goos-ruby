require "xmpp/logging_xmpp_failure_reporter"

describe Xmpp::LoggingXmppFailureReporter do
  subject { Xmpp::LoggingXmppFailureReporter.new logger }
  let(:logger) { double :logger, error: true }

  it "writes message translation failures to a log" do
    subject.cannot_translate_message "auction id", "bad message", Exception.new("bad")
    expect(logger).to have_received(:error).with(
      %{<auction id> Could not translate message "bad message" because #<Exception: bad>})
  end
end
