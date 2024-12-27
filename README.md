# NES Pong

A personal toy project for learning to program for the NES in 6502 assembly.

## Building

> [!TIP]
> If you use [Nix](https://nixos.org/) (which is awesome btw), you can use `nix shell` to quickly enter a development environment for this project.

Compiling this project requires the following dependencies:

- [GNU Make](https://www.gnu.org/software/make/)
- [cc65](https://cc65.github.io)

Then, the program can be built by running `make`. The resulting ROM file will be located at `build/pong.nes`.

### Running

The resulting file at `build/pong.nes` may be ran with an emulator like [FCEUX](https://fceux.com/web/home.html).

## Acknowledgments

- [NESdev Wiki](https://www.nesdev.org/wiki/Nesdev_Wiki): An awesome website with all info there is to NES programming.
- [Nerdy Nights](https://nerdy-nights.nes.science/): An awesome tutorial series for NES programming.
- [The Zero Pages](https://www.youtube.com/playlist?list=PL29OkqO3wUxzOmjc0VKcdiNPqwliHEuEk): A useful YouTube playlist on NES programming by Michael Chiaramonte.
