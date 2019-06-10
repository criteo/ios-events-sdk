#!/bin/bash -l

set +x
set -Eeuo pipefail

rm -rf build/output
mkdir -p build/output/sim

CRITEO_ARCHS='armv7 armv7s arm64'
CRITEO_SIM_ARCHS='i386 x86_64'

CRITEO_CONFIGURATION="Debug"

    xcodebuild \
    -workspace events-sdk.xcworkspace \
        -scheme events-sdk-static \
        -configuration $CRITEO_CONFIGURATION \
        -IDEBuildOperationMaxNumberOfConcurrentCompileTasks=`sysctl -n hw.ncpu` \
        -derivedDataPath build/DerivedData  \
        -sdk iphonesimulator \
        -destination 'platform=iOS Simulator,name=iPhone XS,OS=latest' \
        ARCHS="$CRITEO_SIM_ARCHS" \
        VALID_ARCHS="$CRITEO_SIM_ARCHS" \
        ONLY_ACTIVE_ARCH=NO \
        clean build test | xcpretty
