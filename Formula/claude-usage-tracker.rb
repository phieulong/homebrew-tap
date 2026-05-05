class ClaudeUsageTracker < Formula
  desc "macOS menu bar app tracking Claude AI session + weekly token usage"
  homepage "https://github.com/phieulong/claude-usage-tracker"
  version "2.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/phieulong/claude-usage-tracker/releases/download/v2.0.0/claude-usage-tracker-aarch64-apple-darwin.tar.gz"
      sha256 "24af8d8f978abe093a0f7ff7eaf36a281842d942e12f532e4ea1271af72fcdc9"
    else
      url "https://github.com/phieulong/claude-usage-tracker/releases/download/v2.0.0/claude-usage-tracker-x86_64-apple-darwin.tar.gz"
      sha256 "8ec456f4e32ff49fdc224562719badd6d2489f0d4ee7b73b50d0d0f92563950c"
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
