# Minimum Project

Minimum Project is a small C++ bootstrap project for testing and building local C++ targets from a simple folder layout. The repository currently includes a sample `system` target and a custom `builder` program that compiles targets with `src/` and `include/` directories.

The project is intentionally small. It is meant to be easy to inspect, rebuild, and adjust without a larger build system.

## Current Status

- Windows is the primary supported path at this time.
- Linux support exists and has been tested, but it could still be unstable.
- More Linux testing is planned before the Linux path is treated as official.
- The builder does not have an official version yet. A builder version should be assigned only after the Linux side has been tested and officiated.

## Repository Layout

```text
.
|-- builder/          C++ builder source and builder-specific requirements
|-- system/           Example build target
|   |-- include/      Target headers
|   |-- src/          Target source files
|   |-- bin/          Generated binaries
|   `-- obj/          Generated object files
|-- win/              Windows build scripts
`-- run_system.bat    Runs the built system executable on Windows
```

## Requirements

See [builder/REQUIREMENTS.md](builder/REQUIREMENTS.md) for the requirements used by the builder and the current platform notes.

Short version for Windows:

- Windows 10 or newer
- Visual Studio 2022 with the Desktop development with C++ workload, or another Visual Studio install matched by the scripts
- C++20-capable MSVC toolchain
- Optional: NVIDIA CUDA Toolkit if building CUDA-enabled targets

## Build On Windows

From the repository root:

```bat
win\build_system.bat
```

This calls `win\build.bat system`, which:

1. Cleans the selected target output folders.
2. Builds `builder\bin\builder.exe`.
3. Runs the builder against the `system` target.

To build another target that follows the same folder layout:

```bat
win\build.bat target_folder_name
```

Build targets must contain:

```text
target/
|-- include/
`-- src/
```

The builder writes generated files into the target's `bin/` and `obj/` folders.

## Run On Windows

After building the `system` target:

```bat
run_system.bat
```

The current sample program prints `Hello, world!` and waits for input. The run script currently points at `system\bin\CUDA_System.exe`; if the generated executable name changes, run the executable in `system\bin\` directly or update the script.

## Linux Notes

The Linux builder code path is present and has been tested, but it is not yet considered stable or official. Expect additional testing and cleanup before Linux is treated as a supported release path.

Until that work is complete:

- Do not treat Linux behavior as final.
- Do not assign an official builder version based on the Linux path.
- Prefer checking the current `builder/` source before relying on Linux behavior in automation.

## Generated Files

The `bin/` and `obj/` folders are build outputs. They may exist in the working tree for convenience, but the source of truth is the C++ source and build scripts.
