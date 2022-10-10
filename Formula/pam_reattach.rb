class PamReattach < Formula
  desc "PAM module for reattaching to the user's GUI (Aqua) session"
  homepage "https://github.com/fabianishere/pam_reattach"
  url "https://github.com/fabianishere/pam_reattach/archive/refs/tags/v1.3.tar.gz"
  sha256 "b1b735fa7832350a23457f7d36feb6ec939e5e1de987b456b6c28f5738216570"
  license "MIT"
  head "https://github.com/fabianishere/pam_reattach.git", branch: "master"

  option "with-cli", "Build CLI application that reattaches"

  deprecate! date: "2022-05-15", because: "is in the Homebrew core repository. Use `brew install pam-reattach` instead"

  conflicts_with "pam-reattach", because: "you have already installed the same package from the Homebrew core repository"

  depends_on "cmake" => :build
  depends_on :macos

  def install
    ENV.permit_arch_flags
    args = std_cmake_args
    args << "-DENABLE_CLI=ON" if build.with? "cli"
    args << "-DCMAKE_OSX_ARCHITECTURES=arm64;x86_64" if Hardware::CPU.arm?

    system "cmake", ".", *args
    system "make", "install"
  end

  def caveats; <<~EOS
     Please read the documentation at https://github.com/fabianishere/pam_reattach
     on how to use the module.
  EOS
  end

  test do
    assert_match("Darwin", shell_output("#{bin}/reattach-to-session-namespace uname"))
  end
end
