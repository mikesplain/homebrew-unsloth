cask "unsloth" do
  version "0.1.70-beta"
  sha256 "6f49784d431dbb5679892f9e1964fe2fde2f1f1feffa86d8b7991a59219dd3b6"

  url "https://github.com/unslothai/unsloth/releases/download/v#{version}/Unsloth-Desktop-#{version.tr(".-", "__")}-MacOS.dmg"

  name "Unsloth"
  desc "Desktop app for running and training open models locally"
  homepage "https://github.com/unslothai/unsloth"

  livecheck do
    url "https://github.com/unslothai/unsloth/releases"
    regex(/^v?(\d+(?:\.\d+)+-(?:beta|rc)\d*)$/i)
    strategy :github_releases
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :big_sur

  app "Unsloth.app"

  uninstall quit: "ai.unsloth.studio"

  zap trash: [
    "~/.unsloth",
    "~/Library/Application Support/ai.unsloth.studio",
    "~/Library/Caches/ai.unsloth.studio",
    "~/Library/Logs/ai.unsloth.studio",
    "~/Library/Preferences/ai.unsloth.studio.plist",
    "~/Library/Saved Application State/ai.unsloth.studio.savedState",
  ]
end
