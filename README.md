# Zilch

This repository documents an attempt at bootstrapping a cold silicon baby with
nothing more than a BIOS and a floppy drive into a mean lean calculating machine.

## Prerequisites

- [nasm](https://linux.die.net/man/1/nasm)
- [make](https://linux.die.net/man/1/make)
- [qemu](https://www.qemu.org/)
- [od](https://linux.die.net/man/1/od)

## Contents

Each step in the bootstrapping process is within its own directory.

### 00-hi

This example consists of an assembly snippet which uses BIOS interrupts
to display the characters "Hi" onto the screen.

* Run `make` to produce a real mode bootloader binary, and a floppy image
containing that bootloader.

* Run `make run` to spin up an __i386__ qemu virtual machine with the floppy
image attached and selected as the boot drive. This will produce the message "Hi"
onto the screen, provided to you by the BIOS :)

---

This directory also holds a subdirectory with the same code, but without it
being a boot sector. Running `make` here will produce a `hi.txt` file, the
contents of which are the octal code, which we use in the next step.

This is here mainly to document how we can generate octal code which we can
input as code through the BIOS' real mode.

### 01-simple-monitor

This is where the fun begins.

In here you will find a simple monitor written in the same assembly, utilising
the BIOS to input code in octal and load that into memory for later execution.

This monitor can now be used to type out a better monitor with more functionality.

For now though, we will use it to display the message "Hi" again.

* Run `make` to build the binary and floppy image.
* Run `make run` to run a VM with the floppy image as the boot drive.
* **Very carefully** type out the following octal code (just the digits,
no spaces) using your keyboard.

  ```
  264 016 260 110 315 020 264 016 260 151 315 020 364
  ```

* To end a programme input, just type an invalid digit (anything > 7). This
will end the input sequence, and execute your input. In this case, displaying
"Hi" on the screen.
