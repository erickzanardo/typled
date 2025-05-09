#!/usr/bin/env bash

set -exuo pipefail

xvfb-run "$HOME/.typled/bundle/typled_editor" /typled/example /typled/example/test-map.typled
