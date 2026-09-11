cask "unsloth" do
  version "0.1.808-beta"
  sha256 "e868ea223de0268959de834d0765f92d20a30215c4c697f7e4a208e3265befd6"

  url "https://github.com/unslothai/unsloth/releases/download/v#{version}/Unsloth-Desktop-MacOS.dmg"
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
