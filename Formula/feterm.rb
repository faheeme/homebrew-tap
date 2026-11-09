class Feterm < Formula
  desc "GPU-rendered terminal with Cisco, Arista and Juniper syntax highlighting"
  homepage "https://faheeme.gitlab.io/feterm-site/"
  url "https://gitlab.com/faheeme/feterm/-/archive/v0.5.5/feterm-v0.5.5.tar.gz"
  sha256 "71bd1c73974038b7b58bc6a37af3ca71e9e8ccd80597bf6675465db3008fd953"
  license "MIT"
  head "https://gitlab.com/faheeme/feterm.git", branch: "main"

  bottle do
    root_url "https://github.com/faheeme/homebrew-tap/releases/download/feterm-0.5.5"
    sha256 arm64_tahoe:   "899f3d72ef6d7d00128807b8862351e06d385486d51f102904c82ae062000233"
    sha256 arm64_sequoia: "f79809e8b53336a5e9068c37a6c1f2127d048fda5e6cdc411f5db27bc77bee8b"
  end

  depends_on "pkgconf" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  # Linux users: FeTerm has COPR (Fedora/RHEL) and PPA (Ubuntu) packages.
  depends_on :macos
  depends_on "pcre2"
  depends_on "sdl3"

  # C23 (<stdckdint.h>, nullptr) needs Apple clang 17 (Xcode 16.3) or newer.
  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version < 1700
  end

  def install
    ENV.llvm_clang if DevelopmentTools.clang_build_version < 1700

    # Data is looked up through the stable opt path, so it survives upgrades.
    args = %W[PREFIX=#{prefix} WERROR=]
    system "make", *args, "DATADIR=#{opt_pkgshare}"
    system "make", *args, "DATADIR=#{pkgshare}", "install"
    system "make", *args, "DATADIR=#{opt_pkgshare}", "app-unbundled"
  end

  def caveats
    <<~EOS
      To launch FeTerm from Launchpad, the Dock or Spotlight:
        ln -sf #{opt_prefix}/FeTerm.app /Applications/FeTerm.app
    EOS
  end

  test do
    assert_match "FeTerm #{version}", shell_output("#{bin}/feterm --version")
    assert_path_exists pkgshare/"fonts.conf"
    assert_path_exists prefix/"FeTerm.app/Contents/MacOS/feterm"
  end
end
