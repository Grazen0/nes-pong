# NES Pong

A personal toy project for learning to program for the NES in 6502 assembly.

## Building

> [!TIP]
> If you use [Nix](https://nixos.org/) (which is awesome btw), you can use `nix shell` to quickly enter a development environment for this project.

Compiling this project requires the following dependencies:

- [GNU Make](https://www.gnu.org/software/make/)
- [cc65](https://cc65.github.io)

Then, the program can be built simply by running `make`. The resulting ROM file will be located at `build/pong.nes`.
