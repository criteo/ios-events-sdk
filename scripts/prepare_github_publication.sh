#!/bin/bash -l
set -euf -o pipefail

PUB_DIR=publication
declare -a TO_PUBLISH=(
    "events-sdk"
    "events-sdk.xcodeproj"
    "events-sdkTests"
    "CriteoEventsSDK.podspec"
    "LICENSE"
    "podfile"
    "README.md"
    "CHANGELOG.md"
)

rm -rf $PUB_DIR
mkdir -p $PUB_DIR
git clone https://github.com/criteo/ios-events-sdk.git $PUB_DIR

echo -e "\x1B[32mMoving files and directories to publication public repo\x1B[0m";

for i in "${TO_PUBLISH[@]}";
do
    cp -rf $i $PUB_DIR
    echo -e "\tMove $i to $PUB_DIR"
done
cd $PUB_DIR
git status