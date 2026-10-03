# skel84/tap

Homebrew casks for [Freshkube](https://github.com/skel84/freshkube), a native macOS app for Talos Linux and Kubernetes clusters.

```sh
brew install --cask skel84/tap/freshkube
```

This installs `Freshkube.app` in `/Applications` and links the `freshkube` command. Freshkube needs macOS 15 or later, on Apple silicon or Intel. `brew upgrade --cask freshkube` updates it, and `brew uninstall --zap --cask freshkube` also removes its preferences and operation audit files.

The app is ad-hoc signed, not notarized, so macOS blocks its first open. Open it once, then choose **System Settings → Privacy & Security → Open Anyway** ([Apple's instructions](https://support.apple.com/en-us/102445)). Do not disable Gatekeeper globally.

The cask follows Freshkube's published releases, pre-releases included. [Bump casks](.github/workflows/bump.yml) checks every three hours and commits a new version with the checksums the release ships; run it by hand to pick one up at once.
