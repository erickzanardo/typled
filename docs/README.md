# Typled Docs

## Table of contents

 - [CLI](#CLI)
   - [Install](#install)
   - [Usage](#usage)
 - [File formats](#file-formats)
   - [Map](#map)
   - [Grid](#grid)
   - [Atlas](#atlas)
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

## File Formats

Typled is built from different types of files, that represents different things. This section covers all the existing type of files and their format.

### Map

Represents an individual map, it is composed mainly by three sections, one for the metadata, one for the palette of textures and the layers.

It should have the `.typled` extension for the previewer app to work correctly.

Example:

```
[map]
name = Test map
width = 12 
height = 8 
atlas = mini-dungeon.typled_atlas

[palette]
_ = EMPTY

a = top_left_dirt
m = top_middle_dirt
s = top_right_dirt
G = green_globin
R = red_globin

[layer]
____________
____________
____________
____________
____________
___G___R____
__ammmmms___
ammmmmmmmmms
```

Where
`[map]` contains the metadata of the map, with the following possible attributes
 - `name` Any string defining a name, for information only
 - `width` and `height` is how many cells wide and tall the grid of the map is
 - `atlas` should be a file path that points to the atlas location
 - `backgroundColor` and optional field with the hex color of the background of the map

`[palette]`

This represents a mapping where the value before the `=` is the character to be used in the map definition, and the value after is the sprite id on the `atlas` file.

> [!NOTE]  
> Although not required the `_ = EMPTY` is a convention on typled to represent an empty space in the map
> When the previwer finds an `EMTPY` texture, it will not render anything on that cell.

`[layer]`

A layer should be a text where the line length is equal to the `width` of the file and `height` equal to the number of lines.

A map can have multiple layers and they will be rendered on top of each other on the order that they appear on the file.

### Grid

This file defines a grid of maps, where each cell of the grid is an individual typled map. It uses a simpler format than the map, where each line of the file defines a thing, example:

```
2,1
20,12
0, 0: 1.typled
1, 0: 2.typled
```

Where, the lines, in the order that they appear are:
 - Size of the grid, in the example above it has two maps wide per one tall
 - The grid size of each individual map in the grid (the maps of a grid should have the same values as seem here)
 - All the remaining lines defines which map is in each cell, where the value before the `:` is the coordinate in the grid and the value after is the path to the `typled` file for that cell.

It should have the `.typled_grid` extension for the previewer app to work correctly.

### Atlas

Typled provides a out of the box texture atlas format, which allows users to select textures in spritesheet.

It is a rather simple texture atlas format, for more advanced texture atlas features, check out [Fire Atlas](https://docs.flame-engine.org/latest/bridge_packages/flame_fire_atlas/fire_atlas.html) instead, which typled also support

It should have the `.typled_atlas` extension for the previewer app to work correctly.

The format is as follows:

```
[atlas]
imagePath = mini-dungeon.png
tileSize = 8

[sprites]
top_left_dirt = 0, 0
top_middle_dirt = 1, 0
top_right_dirt = 2, 0

green_globin = 0, 4
red_globin = 1, 4
```

Where:

 - `[atlas]` contains all the metadata of the atlas, like the path of the image and the tile size.
 - `[sprites]` should define all the selections, where the key is the name of the sprite, and the value is defined by four numbers:
   -  `x`: The horizontal index, in tiles where the sprite starts
   -  `y`: The vertical index, in tiles where the sprite starts
   -  `w`: (Optional) How many tiles wide the sprite is
   -  `y`: (Optional) How many tiles tall the sprite is 
