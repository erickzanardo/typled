# Typled Docs

## Table of contents

 - [CLI](#CLI)
   - [Install](#install)
   - [Usage](#usage)
 - File formats
   - Map
   - Grid
   - Atlas
 - Using the Dart package

## CLI

Typled CLI allows users to install the Previewer application and interact with typled files.

### Install

> [!NOTE]  
> Typled CLI requires dart to be installed in the system. If you don't have it, follow
> [Dart's official docs on how to get it.](https://dart.dev/get-dart)


To install the CLI, simply execute the following in your terminal

```bash
dart pub global activate typled_cli
```

### Usage

After installed, refer to the `help` subcommand in your terminal to check on the available operations that you can do with the CLI:

```
typled --help
CLI tool for the Typled application.

Usage: typled <command> [arguments]

Global options:
-h, --help    Print this usage information.

Available commands:
  open      Open a Typled file
  status    Print the status of the Typled Editor
  upgrade   Upgrade a the Typled Editor
```
