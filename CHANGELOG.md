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
