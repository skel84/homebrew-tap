cask "freshkube" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.7.0"
  sha256 arm:   "6ce7de744c187185dbe030b6924041efae16d6f521ce82ad4ebb24d07997a4db",
         intel: "8cbc666ff8d2de26fd577e8b2a6342b5a72a79968a53241490570002abae87aa"

  url "https://github.com/skel84/freshkube/releases/download/v#{version}/Freshkube-#{version}-#{arch}-apple-darwin-adhoc.zip"
  name "Freshkube"
  desc "Native desktop app for Talos Linux and Kubernetes clusters"
  homepage "https://github.com/skel84/freshkube"

  # Every release so far is a pre-release, which the default strategy skips.
  livecheck do
    url :url
    strategy :github_releases do |json, regex|
      json.filter_map do |release|
        next if release["draft"]

        release["tag_name"]&.[](regex, 1)
      end
    end
  end

  depends_on macos: :sequoia

  app "Freshkube.app"
  binary "#{appdir}/Freshkube.app/Contents/MacOS/freshkube"

  zap trash: [
    "~/.freshkube",
    "~/Library/Application Support/Freshkube",
    "~/Library/Saved Application State/io.github.skel84.freshkube.savedState",
  ]

  caveats <<~EOS
    Freshkube is ad-hoc signed, not notarized. macOS blocks its first open:
    open it once, then choose System Settings → Privacy & Security → Open Anyway.
    https://support.apple.com/en-us/102445
  EOS
end
