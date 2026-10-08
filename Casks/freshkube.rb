cask "freshkube" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.10.0"
  sha256 arm:   "1d12753f1014bbaf75d197ef96a44cd33b1e0b2657e2c7ced3b876ac5e389a57",
         intel: "2d0aef0aa5f84bf6736e1305c52482a6d186874bf60b1ae4ae97d6ae571d15cf"

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
