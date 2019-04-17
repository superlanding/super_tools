module SuperLogger
  class Formatter < ::Logger::Formatter
    include ActiveSupport::TaggedLogging::Formatter

    def call(severity, timestamp, progname, msg)
      format(
        "%s[%-5s] %s%s\n",
        timestamp.to_s,
        severity,
        progname ? "#{progname} -- " : nil,
        "#{tags_text}#{msg}"
      )
    end
  end
end
