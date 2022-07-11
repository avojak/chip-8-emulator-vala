![CI](https://github.com/avojak/chip-8-emulator-vala/workflows/CI/badge.svg)
![Lint](https://github.com/avojak/chip-8-emulator-vala/workflows/Lint/badge.svg)
![GitHub](https://img.shields.io/github/license/avojak/chip-8-emulator-vala.svg?color=blue)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/avojak/chip-8-emulator-vala?sort=semver)

<p align="center">
  <img src="data/assets/chip-8.png" alt="Icon" />
</p>
<h1 align="center">CHIP-8</h1>
<!-- <p align="center">
  <a href="https://appcenter.elementary.io/com.github.avojak.chip-8"><img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter" /></a>
</p> -->

## CHIP-8 Emulator

This project is my first dive into emulation.

### Background

I have wanted to create my own Game Boy emulator for a very long time. Along the way I realized that I should start out a bit more modest and implement a CHIP-8 emulator (technically interpreter) first. I plan on implementing debugging tools for each system that is emulated in the hopes of helping other people along with their own emulator journey.

## Install from Source

If you're lazy (like me), you can use the Makefile:

```bash
$ make init
$ make all
```

### Flatpak

This application is build with Flatpak:

```bash
$ flatpak-builder build com.github.avojak.chip-8.yml --user --install --force-clean
$ flatpak run --env=G_MESSAGES_DEBUG=com.github.avojak.chip-8 com.github.avojak.chip-8
```

### Updating Translations

When new translatable strings are added, ensure that `po/POTFILES` contains a
reference to the file with the translatable string.

Update the `.pot` file which contains the translatable strings:

```
$ ninja -C build com.github.avojak.chip-8-pot
```

Generate translations for the languages listed in the `po/LINGUAS` files:

```
$ ninja -C build com.github.avojak.chip-8-update-po
```