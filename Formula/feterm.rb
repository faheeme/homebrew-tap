class Feterm < Formula
  desc "GPU-rendered terminal with Cisco, Arista and Juniper syntax highlighting"
  homepage "https://faheeme.gitlab.io/feterm-site/"
  url "https://gitlab.com/faheeme/feterm/-/archive/v0.5.8/feterm-v0.5.8.tar.gz"
  sha256 "ad66b95502f396dd80de6e4863c17f652c5c7055bad8a1ae860fe4638d0083c8"
  license "MIT"
  head "https://gitlab.com/faheeme/feterm.git", branch: "main"

  bottle do
    root_url "https://github.com/faheeme/homebrew-tap/releases/download/feterm-0.5.8"
    sha256 arm64_tahoe:   "0d8ede4d05b28bf236dd2ada4177a0df76d5d55291263d6ba81888ff700b431a"
    sha256 arm64_sequoia: "d85db89a83ea3f6563587d1cf1202ab8277c4ac4b27a0535cf08e9c15c985f94"
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
