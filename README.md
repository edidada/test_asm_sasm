# test_asm_sasm

A tiny 64-bit NASM program built with the assembler/linker toolchain that ships
with SASM (C:\Program Files (x86)\SASM):

  - NASM\nasm.exe        - assembles to Win64 COFF
  - MinGW64\bin\gcc.exe - links against the C runtime (x86_64-w64-mingw32)

Build and run (local, PowerShell):

    .\build.ps1

It assembles src/main.asm, links it into build/main.exe, and runs it.
The program prints a banner, computes the sum 1..100 (5050), and exits 0.

CI:

.github/workflows/build.yml reproduces the exact same build on GitHub Actions
using the equivalent MSYS2 MinGW64 nasm + gcc, then runs the executable.
Check the run with:  gh run watch
