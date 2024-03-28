# Pong for NES

A toy project for learning to program for the NES in 6502 Assembly.

## How to build

Make sure you've got [cc65](https://cc65.github.io) and [GNU make](https://www.gnu.org/software/make/) installed on your machine.

Then, simply run

```
$ make
```

## Running in an emulator

Running `make` will output the final binary at `build/pong.nes`, which can be ran by the emulator of your choice.

The makefile also contains a `run` target in order to compile and run the project with a single command. In order to use this, check and (very likely) edit the `EMU_BIN` variable in the makefile and set it to whatever command would run the emulator in your machine.

Then, run the command

```
$ make run
```
