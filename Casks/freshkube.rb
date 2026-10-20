cask "freshkube" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.17.0"
  sha256 arm:   "6b88568062105543f57027347ba42e5133571aed1f225c7ce235d3badb49bb51",
         intel: "a71a005905b84d5faf570efa0f85bd0231566d111c0307a3d300bde84f123ded"

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
