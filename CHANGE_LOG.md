# Change Log

## [v1.6.2](https://github.com/thewizardplusplus/biohazard/tree/v1.6.2) (2021-03-04)

- describe the game documentation:
  - contents:
    - controls;
    - gameplay;
  - translations:
    - in English;
    - in Russian;
  - misc.:
    - screenshot;
    - linked table of contents.

## [v1.6.1](https://github.com/thewizardplusplus/biohazard/tree/v1.6.1) (2020-12-18)

- describe for releases:
  - features;
  - change log.

## [v1.6](https://github.com/thewizardplusplus/biohazard/tree/v1.6) (2020-10-19)

- primary field:
  - configuration:
    - loading from a JSON file;
    - validation via the JSON Schema;
    - forcing the default count of cells;
- movable field part:
  - configuration:
    - loading from a JSON file;
    - validation via the JSON Schema;
  - controls:
    - controls via a keyboard:
      - extending the default configuration of keys;
- misc. improvements:
  - fixing initialization of require paths;
  - adding the [LÖVE configuration](https://love2d.org/wiki/Config_Files):
    - game window:
      - resizable mode;
      - title;
      - size:
        - minimal;
        - default;
    - [MSAA](https://en.wikipedia.org/wiki/Multisample_anti-aliasing) tuning;
    - save directory for a game;
  - fullscreen mode:
    - using the fullscreen mode only on a mobile OS;
    - improving initialization of the fullscreen mode.

### Features

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

## [v1.5](https://github.com/thewizardplusplus/biohazard/tree/v1.5) (2020-09-26)

- refactoring.

## [v1.4](https://github.com/thewizardplusplus/biohazard/tree/v1.4) (2020-09-22)

- movable field part:
  - controls:
    - controls via a keyboard:
      - loading a configuration of keys from a JSON file;
      - validation of a configuration of keys via the JSON Schema;
- general controls:
  - quitting by the <kbd>Esc</kbd> key.

### Features

- primary field:
  - drawing;
  - support of operations:
    - populating according to [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) rules;
- movable field part:
  - drawing:
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
    - calculation of a font size based on a screen height;
  - storing in the [FlatDB](https://github.com/uleelx/FlatDB) database:
    - saving on every turn;
    - saving if there are changes only.

## [v1.3](https://github.com/thewizardplusplus/biohazard/tree/v1.3) (2020-09-19)

- movable field part:
  - controls:
    - controls via UI elements:
      - drawing:
        - calculation of a font size based on a screen height;
- game stats:
  - metrics:
    - current cell count;
    - minimal cell count;
  - drawing:
    - calculation of a font size based on a screen height;
  - storing in the [FlatDB](https://github.com/uleelx/FlatDB) database:
    - saving on every turn;
    - saving if there are changes only.

### Features

- primary field:
  - drawing;
  - support of operations:
    - populating according to [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) rules;
- movable field part:
  - drawing:
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
        - calculation of a font size based on a screen height;
      - support of touches;
- game stats:
  - metrics:
    - current cell count;
    - minimal cell count;
  - drawing:
    - calculation of a font size based on a screen height;
  - storing in the [FlatDB](https://github.com/uleelx/FlatDB) database:
    - saving on every turn;
    - saving if there are changes only.

## [v1.2](https://github.com/thewizardplusplus/biohazard/tree/v1.2) (2020-09-07)

- refactoring.

## [v1.1](https://github.com/thewizardplusplus/biohazard/tree/v1.1) (2020-08-14)

- movable field part:
  - support of operations:
    - rotation:
      - clockwise rotation only.

### Features

- primary field:
  - drawing;
  - support of operations:
    - populating according to [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) rules;
- movable field part:
  - drawing:
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
      - support of touches.

## [v1.0](https://github.com/thewizardplusplus/biohazard/tree/v1.0) (2020-08-11)

- movable field part:
  - drawing:
    - drawing a frame around the movable field part;
    - drawing collisions with the primary field with a different color;
  - support of operations:
    - moving:
      - restricting moving by boundaries of the primary field;
    - unioning with the primary field:
      - disabling unioning on collisions with the primary field;
  - controls:
    - controls via UI elements:
      - support of touches.

### Features

- primary field:
  - drawing;
  - support of operations:
    - populating according to [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) rules;
- movable field part:
  - drawing:
    - drawing a frame around the movable field part;
    - drawing collisions with the primary field with a different color;
  - support of operations:
    - moving:
      - restricting moving by boundaries of the primary field;
    - unioning with the primary field:
      - disabling unioning on collisions with the primary field;
  - controls:
    - controls via UI elements:
      - support of touches.

## [v1.0-alpha](https://github.com/thewizardplusplus/biohazard/tree/v1.0-alpha) (2020-08-03)

### Features

- primary field:
  - drawing;
  - support of operations:
    - populating according to [Conway's Game of Life](https://en.wikipedia.org/wiki/Conway's_Game_of_Life) rules.
