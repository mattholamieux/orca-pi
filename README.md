# orca-pi-one
An example of using Orca to control live looping/sampling in Sonic Pi.

Orca sends MIDI to external synth. Synth is routed to audio interface and sampled into recording buffers in Sonic Pi. Playback of recording buffers in Sonic Pi is controlled by Orca using OSC messages. 