# vsh

![cli to my <3](img/demo.png)

**Note:** In order to properly emulate a terminal, I had to ditch `textarea` and
use a plain `div` block, capturing key presses manually. Therefore, this app
will **not** work on mobile devices, unless your phone happens to have a
keyboard connected to it.

## Change Log

### v0.1.3

- `CTRL + <key>` combinations no longer result in text being displayed. They
  are treated as either special bindings within terminal and produce effect
  there or are interpreted as browser bindings and ignored.
- `CTRL + e` = `exit`
- `CTRL + ;` = `clear`

### v0.1.2

- Stylistic changes.
- Rich commands.
- Terminal colours for contrast and clarity.

### v0.1.1

- `top`, `cv`, `jobs` commands added.

### v0.1.0

- Basic functionality
- `whoami`, `help`, `version`, `touch` commands.
