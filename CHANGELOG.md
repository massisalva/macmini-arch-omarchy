# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- GitHub Actions CI for Bash analysis, executable permissions, dry-run
  installation and high-risk credential patterns.
- Local `scripts/check.sh` entry point matching the CI checks.
- Clean Arch installation guide with verification and rollback procedures.
- Portable wallpaper launcher with a Tokyo Night color fallback.
- `iwd` migration now writes `Country=AR` and installs the regulatory database.

### Changed

- Resolved all current ShellCheck findings without changing script behavior.
- Completed the official package list for every default binding and helper.
- Documented how to diagnose the regulatory domain announced by the access
  point instead of repeatedly overriding it from the client.
- Recorded the Deco M4R UC 2.0 `US` domain as an accepted access-point
  limitation and removed the unsuccessful experimental systemd unit.
- Completed the final portable-dotfiles deployment and visual-session
  consistency check.
- Revalidated the complete dotfiles installer in an isolated empty HOME with
  byte-for-byte output comparison.
- Added an applications and services audit covering packages, orphans, SSH,
  resource usage and reproducibility gaps.
- Recorded the decision to keep SSH for occasional use and remove the unused
  Niri, Xwayland Satellite and Swayidle packages.
- Removed five unused packages, including two debug artifacts, and verified
  zero remaining orphans and failed units.
- Added an SSH hardening helper that restricts port 22 to the detected local
  subnet, disables root login and enables UFW.
- Made the helper remove pre-existing unrestricted SSH rules and explicitly
  enable Arch's `ufw.service` for persistence across reboots.
- Made SSH key-only authentication conditional on a non-empty authorized-keys
  file, preserving safe first-time setup without weakening the final policy.
- Completed the macOS ED25519 key migration and verified that SSH rejects
  password-only connections.
- Updated the pinned GitHub checkout action to v7.0.0, removing the deprecated
  Node.js 20 runtime warning.

## [0.1.0] - 2026-07-10

### Added

- Reproducible Hyprland, Waybar, Foot, Fuzzel, Mako, GTK and Hyprlock dotfiles.
- Portable helpers for audio, Bluetooth, clipboard, disks, power and screenshots.
- System, SMART and package audit scripts with private local reports.
- Dotfile backup, dry-run installation and restoration workflows.
- Declarative official and AUR package lists.
- Wi-Fi migration from NetworkManager to iwd with automatic rollback support.
- Hardware health, performance, visual inventory and recovery documentation.
- Privacy-reviewed desktop screenshot.

### Changed

- Adapted the desktop for Intel HD Graphics 5100 and an 8 GiB system.
- Replaced the NetworkManager frontend with Impala and iwd.
- Updated network auditing to use `ip`, `iw` and `resolvectl`.

### Verified

- Clean system and user service state after reboot.
- Automatic iwd reconnection, default route and DNS resolution.
- Healthy Kingston A400 SSD and stable Hyprland session.

[Unreleased]: https://github.com/massisalva/macmini-arch-omarchy/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/massisalva/macmini-arch-omarchy/releases/tag/v0.1.0
