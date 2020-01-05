class PamWatchid < Formula
  desc "PAM plugin module that allows the Apple Watch to be used for authentication"
  homepage "https://github.com/fabianishere/pam-watchid"
  url "https://github.com/fabianishere/pam-watchid/archive/v1.0.tar.gz"
  sha256 "b76d0bc2c31a68e500f538304f98870fe9b4c0e4d87f3cef7530c7e49f6d819f"
  head "https://github.com/fabianishere/pam-watchid.git"


  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats; <<~EOS
    Make sure you add the module to your targeted service in /etc/pam.d/:

      auth  sufficient  pam_watchid.so
      ...

    See https://github.com/fabianishere/pam-watchid
  EOS
  end
end
