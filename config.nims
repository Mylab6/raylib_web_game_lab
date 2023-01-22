import os
const AndroidApiVersion {.intdefine.} = 29
const AndroidNdk {.strdefine.} = "/opt/android-ndk"
when defined(windows):
  const AndroidToolchain = AndroidNdk / "toolchains/llvm/prebuilt/windows-x86_64"
elif defined(linux):
  const AndroidToolchain = AndroidNdk / "toolchains/llvm/prebuilt/linux-x86_64"
elif defined(macosx):
  const AndroidToolchain = AndroidNdk / "toolchains/llvm/prebuilt/darwin-x86_64"
const AndroidSysroot = AndroidToolchain / "sysroot"

switch("arm.android.clang.path", AndroidToolchain / "bin")
switch("arm.android.clang.exe", "armv7a-linux-androideabi" & $AndroidApiVersion & "-clang")
switch("arm.android.clang.linkerexe", "armv7a-linux-androideabi" & $AndroidApiVersion & "-clang")
switch("arm.android.clang.cpp.exe", "armv7a-linux-androideabi" & $AndroidApiVersion & "-clang++")
switch("arm.android.clang.cpp.linkerexe", "armv7a-linux-androideabi" & $AndroidApiVersion & "-clang++")

switch("arm64.android.clang.path", AndroidToolchain / "bin")
switch("arm64.android.clang.exe", "aarch64-linux-android" & $AndroidApiVersion & "-clang")
switch("arm64.android.clang.linkerexe", "aarch64-linux-android" & $AndroidApiVersion & "-clang")
switch("arm64.android.clang.cpp.exe", "aarch64-linux-android" & $AndroidApiVersion & "-clang++")
switch("arm64.android.clang.cpp.linkerexe", "aarch64-linux-android" & $AndroidApiVersion & "-clang++")

switch("i386.android.clang.path", AndroidToolchain / "bin")
switch("i386.android.clang.exe", "i686-linux-android" & $AndroidApiVersion & "-clang")
switch("i386.android.clang.linkerexe", "i686-linux-android" & $AndroidApiVersion & "-clang")
switch("i386.android.clang.cpp.exe", "i686-linux-android" & $AndroidApiVersion & "-clang++")
switch("i386.android.clang.cpp.linkerexe", "i686-linux-android" & $AndroidApiVersion & "-clang++")

switch("amd64.android.clang.path", AndroidToolchain / "bin")
switch("amd64.android.clang.exe", "x86_64-linux-android" & $AndroidApiVersion & "-clang")
switch("amd64.android.clang.linkerexe", "x86_64-linux-android" & $AndroidApiVersion & "-clang")
switch("amd64.android.clang.cpp.exe", "x86_64-linux-android" & $AndroidApiVersion & "-clang++")
switch("amd64.android.clang.cpp.linkerexe", "x86_64-linux-android" & $AndroidApiVersion & "-clang++")

when defined(windows):
  switch("wasm32.linux.clang.exe", "emcc.bat")
  switch("wasm32.linux.clang.linkerexe", "emcc.bat")
  switch("wasm32.linux.clang.cpp.exe", "emcc.bat")
  switch("wasm32.linux.clang.cpp.linkerexe", "emcc.bat")
else:
  switch("wasm32.linux.clang.exe", "emcc")
  switch("wasm32.linux.clang.linkerexe", "emcc")
  switch("wasm32.linux.clang.cpp.exe", "emcc")
  switch("wasm32.linux.clang.cpp.linkerexe", "emcc")

when defined(android):
  --define:GraphicsApiOpenGlEs2
  --os:android
  # --cpu:arm64
  --cc:clang
  switch("passC", "--sysroot=" & AndroidSysroot & " -I" & AndroidSysroot / "usr/include")
  switch("passL", "-L" & AndroidSysroot / "usr/lib")
  when hostCPU == "arm":
    switch("passC", "-I" & AndroidSysroot / "usr/include/arm-linux-androideabi")
    const AndroidAbiFlags = "-march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16"
  elif hostCPU == "arm64":
    switch("passC", "-I" & AndroidSysroot / "usr/include/aarch64-linux-android")
    const AndroidAbiFlags = "-target aarch64 -mfix-cortex-a53-835769"
  elif hostCPU == "i386":
    switch("passC", "-I" & AndroidSysroot / "usr/include/i686-linux-android")
    const AndroidAbiFlags = "-march=i686"
  elif hostCPU == "amd64":
    switch("passC", "-I" & AndroidSysroot / "usr/include/x86_64-linux-android")
    const AndroidAbiFlags = "-march=x86-64"
  switch("passC", AndroidAbiFlags)
  switch("passL", AndroidAbiFlags)

  # --define:androidNDK
  --mm:orc
  # --threads:off
  --panics:on
  --define:noSignalHandler

elif defined(emscripten):
  --define:GraphicsApiOpenGlEs2
  --define:NaylibWebResources
  --os:linux
  --cpu:wasm32
  --cc:clang
  --mm:orc
  --threads:off
  --panics:on
  --define:noSignalHandler
  --passL:"-o raylib_game.html"
  # Use raylib/src/shell.html or raylib/src/minshell.html
  # --passL:"--shell-file minshell.html"
