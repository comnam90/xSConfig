# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.4] - 2021-09-15

### Fixed

- Updating logic in Invoke-xSConfig to target new SConfig module #9

## [0.1.3] - 2020-10-23

### Added

- Added Changelog to project
- Added Azure DevOps pipeline
- Added tests for Invoke-VirtualDiskMenu

### Changed

- Added Requirements section to README
- Added Install instruction to README
- Added Demo to README
- Updated Tests to not import module, and instead added module import to build script.

### Fixed

- Fixed Storage Pool menu table Health Status values and padding
- Fixed Virtual Disk menu table Health Status values and padding
- KB4580363 for Azure Stack HCI introduced breaking changes that have been resolved. #7

## [0.1.2] - 2020-09-26

### Fixed

- Fixed display of storage pool count in extras menu.

## 0.1.1 - 2020-09-26

### Fixed

- Fixed executing code in context of SConfig Module by importing first.

## 0.1.0 - 2020-09-26

### Added

- Initial release
- Adds 'Extra' menu to SConfig home menu
  - Contains Cluster Name, S2D Status, Storage Subsystem Health.
- Adds 'Storage Pools' sub-menu to Extra menu
  - Contains table of Storage Pools
- Adds 'Virtual Disks' sub-menu to Extra menu
  - Contains table of Virtual Disks
- Adds 'Cluster Nodes' sub-menu to Extra menu
  - Contains table of Cluster Nodes.

[Unreleased]: https://github.com/comnam90/xSConfig/compare/v0.1.3...HEAD
[0.1.4]: https://github.com/comnam90/xSConfig/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/comnam90/xSConfig/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/comnam90/xSConfig/releases/tag/v0.1.2
