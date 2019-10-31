class Iconsync < Formula
  desc "A tool to sync your icon theme on macOS"
  homepage "https://github.com/fabianishere/iconsync"
  url "https://github.com/fabianishere/iconsync/archive/v1.1.0.tar.gz"
  sha256 "638473810594e8832815698ed3b960ec5e337b41e2fae66932e32a97d19f95aa"
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
