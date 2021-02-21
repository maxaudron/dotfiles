#!/bin/sh
# 
# Start jack by loading a ladish studio, start the cadence pulseaudio bridge,
# and start the scream pulseaudio client to receive audio from the windows VM
#

# Create sink for TeamSpeak and connect it to Bitwig

jmcore &
sleep 1
ladishd &
sleep 1

ladish_control sload default
cadence-pulse2jack

sleep 2

# Disconnect system in and pulseaudio out
ladish_control sdisconnect "PulseAudio JACK Source" "front-left" "Hardware Capture" "capture_1"
ladish_control sdisconnect "PulseAudio JACK Source" "front-right" "Hardware Capture" "capture_2"
ladish_control sdisconnect "PulseAudio JACK Source" "rear-left" "Hardware Capture" "capture_3"
ladish_control sdisconnect "PulseAudio JACK Source" "rear-right" "Hardware Capture" "capture_4"

pacmd load-module module-jack-sink sink_name=TeamSpeak client_name=TeamSpeak channels=2
sleep 1
ladish_control sdisconnect "TeamSpeak" "front-left" "Hardware Playback" "playback_1"
ladish_control sdisconnect "TeamSpeak" "front-right" "Hardware Playback" "playback_2"
ladish_control sdisconnect "PulseAudio JACK Sink" "front-left" "Hardware Playback" "playback_1"
ladish_control sdisconnect "PulseAudio JACK Sink" "front-right" "Hardware Playback" "playback_2"

scream -i virbr0 &

