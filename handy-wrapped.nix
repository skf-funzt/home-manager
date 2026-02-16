# ============================================================================
# Handy Audio Wrapper
#
# This file wraps the Handy speech-to-text application with proper audio
# library paths to fix ALSA plugin loading errors.
#
# The problem: Handy is built with alsa-lib-1.2.13 which looks for plugins
# in its own lib/alsa-lib directory, but those plugin packages don't exist
# there. We need to set ALSA_PLUGIN_DIR to point to alsa-plugins instead.
# ============================================================================
{
  pkgs,
  handy,
}:

let
  # Extract the handy package for the current system
  handyPackage = handy.packages.${pkgs.system}.handy;

  # The key insight: plugins come from alsa-plugins, not alsa-lib!
  # Handy's build includes alsa-lib but NOT alsa-plugins
  # We need to explicitly add them here
  alsaPlugins = pkgs.alsa-plugins;

  # All audio-related libraries
  audioLibs = with pkgs; [
    alsa-lib
    alsa-plugins
    pipewire
    pulseaudio
    libjack2
  ];

  # The critical setting: point ALSA_PLUGIN_DIR to where plugins actually are
  alsaPluginDir = "${alsaPlugins}/lib/alsa-lib";

  # Build complete library path with all audio libs
  libPath = pkgs.lib.makeLibraryPath audioLibs;
in

pkgs.runCommand "handy-wrapped"
  {
    nativeBuildInputs = [ pkgs.makeWrapper ];
  }
  (''
    mkdir -p $out/bin

    makeWrapper ${handyPackage}/bin/handy $out/bin/handy \
      --set ALSA_PLUGIN_DIR "${alsaPluginDir}" \
      --set ALSA_PCM_PLUGINS "${alsaPluginDir}" \
      --prefix LD_LIBRARY_PATH : "${libPath}" \
      --set PULSE_RUNTIME_PATH "/run/user/$(id -u)/pulse" \
      --set PIPEWIRE_RUNTIME_PATH "/run/user/$(id -u)/pipewire-0"

    # Copy over other binaries and resources if they exist
    if [ -d ${handyPackage}/share ]; then
      mkdir -p $out/share
      cp -r ${handyPackage}/share/* $out/share/
    fi

    if [ -d ${handyPackage}/lib ]; then
      mkdir -p $out/lib
      cp -r ${handyPackage}/lib/* $out/lib/
    fi
  '')
