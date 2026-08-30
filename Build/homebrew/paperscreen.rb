class Paperscreen < Formula
  desc "Paper-like screen overlay for macOS"
  homepage "https://github.com/Bearbobs/PaperScreen"
  url "https://github.com/Bearbobs/PaperScreen/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_TARBALL_SHA256"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on macos: :ventura

  def install
    # Build the app using xcodebuild
    system "xcodebuild",
           "-project", "PaperScreen.xcodeproj",
           "-scheme", "PaperScreen",
           "-configuration", "Release",
           "SYMROOT=build"

    # Install the built .app into libexec and provide a wrapper script
    app_path = "build/Release/PaperScreen.app"
    libexec.install app_path

    (bin/"paperscreen").write <<~EOS
      #!/bin/bash
      open "#{libexec}/PaperScreen.app" "$@"
    EOS
  end

  test do
    # Basic test: ensure the wrapper script exists and is executable
    assert_predicate bin/"paperscreen", :executable?
  end
end
