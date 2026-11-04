class Feterm < Formula
  desc "GPU-rendered terminal with Cisco, Arista and Juniper syntax highlighting"
  homepage "https://faheeme.gitlab.io/feterm-site/"
  url "https://gitlab.com/faheeme/feterm/-/archive/v0.5.4/feterm-v0.5.4.tar.gz"
  sha256 "68d0b36be2d5aa19e860a86afdd0b789cd17d897497c81b60701dfed9221c76e"
  license "MIT"
  head "https://gitlab.com/faheeme/feterm.git", branch: "main"

  bottle do
    root_url "https://github.com/faheeme/homebrew-tap/releases/download/feterm-0.5.3"
    sha256 arm64_tahoe:   "bed7be572729988e6d572fbed12f130191ad33223162b42ff945fd170dd8fe90"
    sha256 arm64_sequoia: "1a77ba1e8050f503134db56512a6bcef8553e100ff98502a181d5e7baf4d045d"
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
