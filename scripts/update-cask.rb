#!/usr/bin/env ruby
# frozen_string_literal: true

require "digest"
require "json"
require "net/http"
require "uri"

REPO = "unslothai/unsloth"
CASK_PATH = File.expand_path("../Casks/unsloth.rb", __dir__).freeze
USER_AGENT = "homebrew-unsloth-cask-updater"
MACOS_SUFFIX = "-MacOS.dmg"

def github_json(path)
  uri = URI("https://api.github.com/#{path}")
  request = Net::HTTP::Get.new(uri)
  request["Accept"] = "application/vnd.github+json"
  request["User-Agent"] = USER_AGENT
  request["Authorization"] = "Bearer #{ENV.fetch("GITHUB_TOKEN")}" if ENV["GITHUB_TOKEN"]

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end

  unless response.is_a?(Net::HTTPSuccess)
    warn "GitHub API request failed: #{response.code} #{response.body}"
    exit 1
  end

  JSON.parse(response.body)
end

def sha256_for(url, redirects = 0)
  if redirects > 5
    warn "Too many redirects while downloading #{url}"
    exit 1
  end

  uri = URI(url)
  request = Net::HTTP::Get.new(uri)
  request["User-Agent"] = USER_AGENT
  digest = Digest::SHA256.new

  Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
    http.request(request) do |response|
      case response
      when Net::HTTPRedirection
        return sha256_for(URI.join(url, response["location"]).to_s, redirects + 1)
      when Net::HTTPSuccess
        response.read_body { |chunk| digest.update(chunk) }
      else
        warn "Download failed: #{response.code} #{url}"
        exit 1
      end
    end
  end

  digest.hexdigest
end

def replace!(content, pattern, replacement)
  unless content.match?(pattern)
    warn "Could not update cask; pattern did not match: #{pattern.inspect}"
    exit 1
  end

  content.sub(pattern, replacement)
end

releases = github_json("repos/#{REPO}/releases?per_page=100")
release = releases.find do |candidate|
  candidate.fetch("assets").any? { |asset| asset.fetch("name").end_with?(MACOS_SUFFIX) }
end

unless release
  warn "Could not find a release with a macOS DMG asset"
  exit 1
end

version = release.fetch("tag_name").delete_prefix("v")
asset = release.fetch("assets").find { |candidate| candidate.fetch("name").end_with?(MACOS_SUFFIX) }
url = asset.fetch("browser_download_url")
sha256 = sha256_for(url)
cask = File.read(CASK_PATH)

cask = replace!(cask, /^  version "[^"]+"/, %Q(  version "#{version}"))
cask = replace!(cask, /^  sha256 "[0-9a-f]{64}"/, %Q(  sha256 "#{sha256}"))

File.write(CASK_PATH, cask)
puts "Updated Unsloth cask to #{version} (#{asset.fetch("name")})"
