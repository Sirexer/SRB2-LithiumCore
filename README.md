# SRB2-LithiumCore

[![latest release](https://github.com/Sirexer/SRB2-LithiumCore/blob/main/.github/buttons/release.png?raw=true)](https://github.com/Sirexer/SRB2-LithiumCore/releases/download/alpha/L_LithiumCore_V1.1-alpha.pk3)
[![compiled](https://github.com/Sirexer/SRB2-LithiumCore/blob/main/.github/buttons/download_compiled.png?raw=true)](https://nightly.link/Sirexer/SRB2-LithiumCore/workflows/build.yml/main/LithiumCore.zip)

LithiumCore is an addon for Sonic Robo Blast 2 (SRB2) designed to improve hosting and server management.

# Addon description 
An add-on for SRB2, consisting of a set of server and client subsystems: account and authorization system (including 2FA/TOTP), progress/configuration saving, flexible menu/interface system (BBCode in MOTD, custom HUD hooks), module/add-on loader, and a bunch of admin tools (banlist, command permissions, console settings, etc.). The add-on contains a large number of graphics/icons and built-in libraries (JSON, QR/TOTP/sha1, etc.).

Everything is written in pure Lua. You only need SRB2 itself to run LithiumCore.

# Attribution of third-party components

This project includes code and/or content from the following third-party projects:

## SerenityOS Emoji
- **Source:** https://emoji.serenityos.org/
- **License:** BSD 2-Clause License
- **License file:** Located in `Graphics/Unicode/SerenityOSEmoji/LICENSE.txt`

## json.lua
- **Source:** https://github.com/rxi/json.lua
- **License:** MIT License

## qrencode.lua
- **Source:** https://speedata.github.io/luaqrcode/docs/qrencode.html
- **License:** BSD 3-Clause License

## SRB2 unicode fonts
- **Author:** Ors
