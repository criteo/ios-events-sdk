#!/bin/bash -l
set -euf -o pipefail

PUB_DIR="publication"
GITHUB_REPO_DIR="${PUB_DIR}/ios-events-sdk-EXTERNAL"
TESTING_APP_REPO_DIR="${PUB_DIR}/criteo-test-app-INTERNAL"
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

rm -rf "${PUB_DIR}"
mkdir -p "${PUB_DIR}"

git clone git@github.com:criteo/ios-events-sdk.git "${GITHUB_REPO_DIR}"
git clone https://review.crto.in/ios/criteo-test-app "${TESTING_APP_REPO_DIR}"

echo -e "\x1B[32mMoving files and directories to publication public repo\x1B[0m";
for i in "${TO_PUBLISH[@]}";
do
    cp -rf "${i}" "${GITHUB_REPO_DIR}"
    echo -e "\tMove $i to ${GITHUB_REPO_DIR}"
done

cd "${GITHUB_REPO_DIR}"
git status