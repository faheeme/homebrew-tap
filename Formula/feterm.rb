class Feterm < Formula
  desc "GPU-rendered terminal with Cisco, Arista and Juniper syntax highlighting"
  homepage "https://gitlab.com/faheeme/feterm"
  url "https://gitlab.com/faheeme/feterm/-/archive/v0.5.2/feterm-v0.5.2.tar.gz"
  sha256 "e39fff9926bc12ffc16ee100136c8f1459b0bfcc1f7708120fb59e9c80dc2887"
  license "MIT"
  head "https://gitlab.com/faheeme/feterm.git", branch: "main"

  bottle do
    root_url "https://github.com/faheeme/homebrew-tap/releases/download/feterm-0.5.2"
    sha256 arm64_tahoe:   "3ee9290f346e6bc3569c5525b566d2d9660199dee7a85458ab790419cdb9521e"
    sha256 arm64_sequoia: "45825a51ff650d9fc6a8e18b8de4da5f1cd7fd2adab5f78a565a6aaa2e466733"
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
