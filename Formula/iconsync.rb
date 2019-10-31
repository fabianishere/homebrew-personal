class Iconsync < Formula
  desc "A tool to sync your icon theme on macOS"
  homepage "https://github.com/fabianishere/iconsync"
  url "https://github.com/fabianishere/iconsync/archive/v1.0.0.tar.gz"
  sha256 "16f56620f579380699bad22923d3c55e4f757125d52722b02a74ad3e5bd295d1"
  head "https://github.com/fabianishere/iconsync.git"


  depends_on :xcode => ["10.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/iconsync"
  end

  test do
    system "#{bin}/iconsync" "-v"
  end 
end
