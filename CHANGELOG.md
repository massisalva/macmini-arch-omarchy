# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/)
and this project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Pending

- Add a privacy-reviewed desktop screenshot.
- Publish the repository on GitHub.

## [0.1.0] - 2026-07-10

### Added

- Reproducible Hyprland, Waybar, Foot, Fuzzel, Mako, GTK and Hyprlock dotfiles.
- Portable helpers for audio, Bluetooth, clipboard, disks, power and screenshots.
- System, SMART and package audit scripts with private local reports.
- Dotfile backup, dry-run installation and restoration workflows.
- Declarative official and AUR package lists.
- Wi-Fi migration from NetworkManager to iwd with automatic rollback support.
- Hardware health, performance, visual inventory and recovery documentation.

### Changed

- Adapted the desktop for Intel HD Graphics 5100 and an 8 GiB system.
- Replaced the NetworkManager frontend with Impala and iwd.
- Updated network auditing to use `ip`, `iw` and `resolvectl`.

### Verified

- Clean system and user service state after reboot.
- Automatic iwd reconnection, default route and DNS resolution.
- Healthy Kingston A400 SSD and stable Hyprland session.

[Unreleased]: https://github.com/OWNER/macmini-arch-omarchy/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/OWNER/macmini-arch-omarchy/releases/tag/v0.1.0
