# Dotfiles

Personal machine configuration managed across computers.

## Language

**Profile**:
A named slice of the dotfiles that applies to a machine based on its role.
_Avoid_: setup, mode

Profile values are `personal` and `modular`.

The selected profile is persisted on each machine.

**Shared Profile**:
The baseline profile for configuration that should be consistent across work and personal machines.
_Avoid_: common setup, default setup

**Modular Profile**:
The profile for Modular-specific configuration, credentials, paths, and tooling.
_Avoid_: work profile, company setup, office setup

**Personal Profile**:
The profile for non-work machines that should receive shared configuration while excluding work-only configuration.
_Avoid_: home setup, private setup

The personal profile is the default profile for new installs.

**Modular File**:
A file whose meaning depends on Modular-specific accounts, paths, repositories, credentials, or tooling.
_Avoid_: work file, company file

The `max/` tree is Modular-only.

The Claude Code configuration is Modular-only.

Pixi is Modular-only.

**Modular Tooling**:
Tools used for Modular-specific development but not expected on a personal machine.
_Avoid_: work tooling, company tooling

**Neutral App Config**:
A configuration file for an app used across profiles that contains no Modular-specific assumptions.
_Avoid_: inert config, generic config

Ghostty is a neutral app config with a profile-specific working directory.

GitHub CLI is a neutral app config.

Karabiner is a neutral app config for macOS machines.

Karabiner automatic backups are not owned config.

Neovim is a neutral app config.

**Shared Secret**:
A secret used intentionally across profiles.
_Avoid_: personal secret, work secret

The 1Password CLI is shared tooling because shared secrets can use it.

**Optional Secret**:
A secret whose absence must not prevent a profile from being applied or a shell from starting.
_Avoid_: best-effort secret, soft secret

**Owned Config**:
A configuration area that the dotfiles are allowed to replace completely on a target machine.
_Avoid_: managed config, controlled config

The default shell is owned config across profiles.
