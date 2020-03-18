#!/bin/bash -l

PUB_DIR="publication"
GITHUB_REPO_DIR="${PUB_DIR}/ios-events-sdk-EXTERNAL"

cd "${GITHUB_REPO_DIR}"
pod trunk push CriteoEventsSDK.podspec
