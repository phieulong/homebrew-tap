class ClaudeUsageTracker < Formula
  desc "macOS menu bar app tracking Claude AI session + weekly token usage"
  homepage "https://github.com/phieulong/claude-usage-tracker"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/phieulong/claude-usage-tracker/releases/download/v1.0.0/claude-usage-tracker-aarch64-apple-darwin.tar.gz"
      sha256 "6461042d5dd5fde62dbfe7fe67c669a6016062acaab28b0e282236ddc818869f"
    else
      url "https://github.com/phieulong/claude-usage-tracker/releases/download/v1.0.0/claude-usage-tracker-x86_64-apple-darwin.tar.gz"
      sha256 "deeb3997aecd4f7cc1edb9233bc8f223672d451caca20ed5e4e8ad89c0134d87"
    end
  end

  def install
    bin.install "claude-usage-tracker"
    (prefix/"LaunchAgents").install "com.user.claude-usage-tracker.plist"
  end

  service do
    run [opt_bin/"claude-usage-tracker", "daemon"]
    keep_alive true
    log_path "/tmp/claude-usage-tracker.log"
    error_log_path "/tmp/claude-usage-tracker.err"
    environment_variables RUST_LOG: "info"
  end

  def caveats
    <<~EOS
      Claude Usage Tracker là menu bar app — chạy ẩn, không có cửa sổ.

      Khởi động tự động khi login:
        brew services start claude-usage-tracker

      Dừng:
        brew services stop claude-usage-tracker
    EOS
  end

  test do
    assert_match "claude-usage-tracker", shell_output("#{bin}/claude-usage-tracker --help 2>&1")
  end
end
