name: Android NDK Mod Build

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          distribution: 'temurin'
          java-version: '11'
      - name: Install Android SDK & NDK
        run: |
          sudo apt-get update
          sudo apt-get install -y unzip wget
          wget https://dl.google.com/android/repository/commandlinetools-linux-9123335_latest.zip -O cmdline.zip
          unzip cmdline.zip -d $HOME/android-sdk
          yes | $HOME/android-sdk/cmdline-tools/bin/sdkmanager --sdk_root=$HOME/android-sdk \
            "platform-tools" "platforms;android-33" "ndk;25.2.9519653"
      - name: Build with Gradle
        run: |
          chmod +x ./gradlew
          ./gradlew assembleDebug
      - uses: actions/upload-artifact@v3
        with:
          name: terraria-mod-artifacts
          path: app/build/outputs/**/*.so
