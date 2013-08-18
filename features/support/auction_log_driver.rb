class AuctionLogDriver
  def clear_log
    File.open(Xmpp::LoggingXmppFailureReporter::LOG_FILE_NAME, "w") {}
  end

  def has_log_entry_containing_string? string
    File.read(Xmpp::LoggingXmppFailureReporter::LOG_FILE_NAME).lines.any? {|l| l.include? string }
  end
end
