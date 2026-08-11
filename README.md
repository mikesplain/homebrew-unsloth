# homebrew-unsloth

[![CI](https://github.com/mikesplain/homebrew-unsloth/actions/workflows/ci.yml/badge.svg)](https://github.com/mikesplain/homebrew-unsloth/actions/workflows/ci.yml) [![Update Unsloth Cask](https://github.com/mikesplain/homebrew-unsloth/actions/workflows/update-unsloth.yml/badge.svg)](https://github.com/mikesplain/homebrew-unsloth/actions/workflows/update-unsloth.yml)

Dedicated Homebrew tap for the Unsloth Desktop macOS cask.

This tap installs the arm64 Unsloth Desktop app from upstream GitHub release DMGs with a pinned SHA-256 checksum. It does not attempt to package Unsloth Core’s Python, PyTorch, or GPU-specific runtime as a Homebrew formula.

## Install

```sh
brew tap mikesplain/unsloth
brew install --cask unsloth
```

The cask requires Apple Silicon and macOS 11 Big Sur or newer. Unsloth Desktop may download or manage additional model/runtime data after installation.

## Updating

`.github/workflows/update-unsloth.yml` runs every 6 hours and can also be triggered manually. It selects the newest upstream release that publishes a macOS DMG, recomputes its SHA-256 checksum, audits the cask, and opens or updates a pull request.

This asset-aware selection is intentional: upstream occasionally publishes release tags before attaching desktop artifacts.

## Local Validation

```sh
brew tap mikesplain/unsloth .
brew audit --cask --strict --online --tap=mikesplain/unsloth unsloth
brew style --cask mikesplain/unsloth
```
