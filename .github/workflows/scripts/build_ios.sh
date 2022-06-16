#!/bin/bash
set -euxo pipefail

cd example

flutter pub get

flutter build ios --no-codesign
