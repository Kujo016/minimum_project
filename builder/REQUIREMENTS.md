# Builder Requirements

This file tracks the requirements for building and running the local C++ builder.

## Purpose

The builder is a small C++ bootstrap tool. It compiles project targets that use this layout:

```text
target/
|-- include/
`-- src/
```

When a target is built, the builder creates or updates that target's `obj/` and `bin/` folders.

## Windows Requirements

Windows is the primary supported path right now.

Required:

- Windows 10 or newer
- Visual Studio 2022 with the Desktop development with C++ workload, or another Visual Studio install matched by the bootstrap scripts
- MSVC `cl` and `link` available through `vcvars64.bat`
- A C++20-capable compiler

Optional:

- NVIDIA CUDA Toolkit with `nvcc` on `PATH`
- `CUDA_PATH` pointing to the installed CUDA Toolkit

The Windows bootstrap scripts currently search for `vcvars64.bat` in these locations:

```text
C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat
C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat
C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat
```

## Windows Build Commands

From the repository root:

```bat
win\build_system.bat
```

or:

```bat
win\build.bat system
```

For verbose builder-only diagnostics:

```bat
builder\debug_builder.bat
```

## Linux Requirements

Linux support exists in the builder source and has been tested, but it could be unstable. It is not yet considered an official release path.

There is no committed Linux bootstrap script yet. Treat the Linux notes here as the expected environment requirements for the source path, not as a finalized release procedure.

Expected requirements for the Linux path:

- Linux with `/proc/self/exe`
- `g++` with C++20 support
- Standard C++ filesystem support
- Optional: NVIDIA CUDA Toolkit with `nvcc`
- Optional: `CUDA_PATH`, or CUDA installed under `/usr/local/cuda`

Linux behavior should be verified against the current source before it is used in repeatable automation.

## CUDA Behavior

CUDA is optional. The Windows scripts check whether `nvcc` is available:

- If `nvcc` is found, the builder is compiled with CUDA detection enabled.
- If `nvcc` is not found, the builder is compiled as CPU-compatible.

When CUDA is enabled:

- Windows expects CUDA libraries under `%CUDA_PATH%\lib\x64`.
- Linux checks `$CUDA_PATH/lib64` first, then `/usr/local/cuda/lib64`.

## Runtime DLL Notes On Windows

For Windows targets that use SDL or CUDA runtime DLLs, the builder expects local runtime DLLs to be available before staging them into the target `bin/` folder.

Relevant behavior in the builder:

- `VECTORISO_RUNTIME_DLL_DIR` can override the runtime DLL source directory.
- If the override is not set, the builder checks the target's `dll/` folder.
- If the target does not have a `dll/` folder, the builder falls back to `system/dll/`.

Expected DLL names include:

- `SDL3.dll` for SDL targets
- `cudart64_12.dll` for CUDA-enabled Windows targets

## Version Status

The builder does not have an official version yet. Do not assign or publish a builder version until the Linux side has been tested further and officiated.
