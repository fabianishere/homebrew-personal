class PamReattach < Formula
  desc "PAM module for reattaching to the user's GUI (Aqua) session"
  homepage "https://github.com/fabianishere/pam_reattach"
  url "https://github.com/fabianishere/pam_reattach/archive/v1.2.tar.gz"
  sha256 "60133388c400a924ca05ee0e5e6f9cc74c9f619bf97e545afe96f35544b0d011"
  head "https://github.com/fabianishere/pam_reattach.git"

  option "with-cli", "Build CLI application that reattaches"

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DENABLE_CLI=ON" if build.with? "cli"

    system "cmake", ".", *args
    system "make", "install"
  end

  def caveats; <<~EOS
    Make sure you add the module to your targeted service in /etc/pam.d/ before
    the module you want put in the per-session bootstrap namespace:

      auth  optional    pam_reattach.so
      auth  sufficient  pam_tid.so
      ...

    See https://github.com/fabianishere/pam_reattach
  EOS
  end
end
