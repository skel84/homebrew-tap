cask "freshkube" do
  arch arm: "aarch64", intel: "x86_64"

  version "0.21.1"
  sha256 arm:   "4199c691c2b85dc222f0e13155f39f16eda919bd19a8a7a90b0f480e3ab4e338",
         intel: "bf3c83fc3bc28be9ae1cb02717dc52f4ce68f06aec0452f12a27fd67b4a69ae9"

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
