# faheeme/tap

Homebrew formulae by Faheem Essack.

| Formula | What it is |
|---|---|
| `feterm` | [FeTerm](https://gitlab.com/faheeme/feterm): a GPU-rendered terminal for network engineers, with PCRE2 highlighting for Cisco, Arista and Juniper, an SSH/Telnet/serial session manager and an SFTP file explorer. |

## Install

```sh
brew install faheeme/tap/feterm
```

Then run `feterm` from any terminal, or add the app to Applications (Launchpad, Dock, Spotlight):

```sh
ln -sf "$(brew --prefix)/opt/feterm/FeTerm.app" /Applications/FeTerm.app
```

Update with `brew upgrade`. Prebuilt bottles exist for Apple Silicon on macOS 15 Sequoia and
macOS 26 Tahoe. On macOS 14 Sonoma and on Intel Macs, Homebrew itself no longer ships
prebuilt packages, so it builds FeTerm and its libraries from source (slow); there the disk
image from the [releases page](https://gitlab.com/faheeme/feterm/-/releases) is quicker.

Installing through Homebrew avoids the Gatekeeper "unidentified developer" prompt that the
unsigned disk images on the [releases page](https://gitlab.com/faheeme/feterm/-/releases) get.

## Issues

FeTerm itself: <https://gitlab.com/faheeme/feterm/-/issues>. Problems with the formula: open
an issue here.
