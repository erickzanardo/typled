#!/bin/bash

flutter build macos

rm -rf ~/bin/typled.app
cp -rf build/macos/Build/Products/Release/typled.app ~/bin/
