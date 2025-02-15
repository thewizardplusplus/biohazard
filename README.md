# Biohazard

[![doc:build](https://github.com/thewizardplusplus/biohazard/actions/workflows/doc.yaml/badge.svg)](https://github.com/thewizardplusplus/biohazard/actions/workflows/doc.yaml)
[![doc:link](https://img.shields.io/badge/doc%3Alink-link-blue?logo=github)](https://thewizardplusplus.github.io/biohazard/)
[![lint](https://github.com/thewizardplusplus/biohazard/actions/workflows/lint.yaml/badge.svg)](https://github.com/thewizardplusplus/biohazard/actions/workflows/lint.yaml)

![](docs/screenshot.png)

2D puzzle game for Android inspired by [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) and various block games.

_**Disclaimer:** this game was written directly on an Android smartphone with the [QLua](https://play.google.com/store/apps/details?id=com.quseit.qlua5pro2) IDE and the [LÖVE for Android](https://play.google.com/store/apps/details?id=org.love2d.android) app._

## Features

- primary field:
  - configuration:
    - loading from a JSON file;
    - validation via the JSON Schema;
  - drawing:
    - resizable mode;
  - support of operations:
    - populating according to [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) rules;
- movable field part:
  - configuration:
    - loading from a JSON file;
    - validation via the JSON Schema;
  - drawing:
    - resizable mode;
    - drawing a frame around the movable field part;
    - drawing collisions with the primary field with a different color;
  - support of operations:
    - moving:
      - restricting moving by boundaries of the primary field;
    - rotation:
      - clockwise rotation only;
    - unioning with the primary field:
      - disabling unioning on collisions with the primary field;
  - controls:
    - controls via UI elements:
      - drawing:
        - resizable mode:
          - calculation of a font size based on a screen height;
      - support of touches;
    - controls via a keyboard:
      - loading a configuration of keys from a JSON file;
      - validation of a configuration of keys via the JSON Schema;
- game stats:
  - metrics:
    - current cell count;
    - minimal cell count;
  - drawing:
    - resizable mode:
      - calculation of a font size based on a screen height;
  - storing in the [FlatDB](https://github.com/uleelx/FlatDB) database:
    - saving on every turn;
    - saving if there are changes only.

## Building

Clone this repository:

```
$ git clone https://github.com/thewizardplusplus/biohazard.git
$ cd biohazard
```

Build the game with the [makelove](https://github.com/pfirsich/makelove) tool:

```
$ makelove ( win64 | macos | appimage )
```

Take the required build from the corresponding subdirectory of the created `builds` directory.

## Running

See for details: <https://love2d.org/wiki/Getting_Started#Running_Games>

### On the Android

Clone this repository:

```
$ git clone https://github.com/thewizardplusplus/biohazard.git
$ cd biohazard
```

Make a ZIP archive containing it:

```
$ git archive --format zip --output biohazard.zip HEAD
```

Change its extension from `.zip` to `.love`:

```
$ mv biohazard.zip biohazard.love
```

Transfer the resulting file to the Android device.

Open it with the [LÖVE for Android](https://play.google.com/store/apps/details?id=org.love2d.android) app.

### On the PC

Clone this repository:

```
$ git clone https://github.com/thewizardplusplus/biohazard.git
$ cd biohazard
```

Then run the game with the [LÖVE](https://love2d.org/) engine:

```
$ love .
```

## Documentation

- Table of Contents ([EN](docs/README.md) / [RU](docs/README_ru.md)):
  - Summary ([EN](docs/summary.md) / [RU](docs/summary_ru.md))
  - Gameplay ([EN](docs/gameplay.md) / [RU](docs/gameplay_ru.md))
  - Controls ([EN](docs/controls.md) / [RU](docs/controls_ru.md))

## License

The MIT License (MIT)

Copyright &copy; 2020-2021 thewizardplusplus
