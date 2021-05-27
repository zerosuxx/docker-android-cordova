# Android + Cordova Docker image

## Introduction

A **docker** image build with **Android** build environment.

## What Is Inside

It includes the following components:

* NodeJS 14
* Android NDK r21
* Android Command Line (build) tools 29.0.2
* Android SDK tools 7302050
* Cordova
* Gradle 6.5

## Available build arguments
- `ANDROID_NDK_VERSION="21"`
- `ANDROID_BUILD_TOOLS_VERSION="29.0.2"`
- `ANDROID_SDK_TOOLS_VERSION="7302050"`
- `GRADLE_VERSION="6.5"`

## Build command
```
docker build -t zerosuxx/android-cordova --build-arg ANDROID_NDK_VERSION="20" .
```