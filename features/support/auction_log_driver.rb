class AuctionLogDriver
  LOG_FILE_NAME = "sniper.log"

  def clear_log
    File.open(LOG_FILE_NAME, "w") {}
  end

  def has_log_entry_containing_string? string
    File.read(LOG_FILE_NAME).lines.any? {|l| l.include? string }
  end
end
