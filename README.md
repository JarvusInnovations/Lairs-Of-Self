Lairs-Of-Self
=============

## Components

### `ipad-app`
UI for kiosk that visitors use first when they arrive at the event.

#### Settings
Edit in Settings -> Lairs of Self

##### Mask 1 Defaults
- X: 170
- Y: 250
- Height: 295
- Width: 500

##### Mask 2 Defaults
- X: 225
- Y: 300
- Height: 123
- Width: 300


### `mac-server`
NodeJS daemon and HTML5 UI for each Mac Mini that iPad kiosks will be individually paired to for rendering its submissions to a display output.

Requires GraphicsMagick installed: `brew install GraphicsMagick`

### `emergence-server`
Online API for uploading submissions to from all mac servers.

### `touch-webapp`
Mobile webapp for visitors to modify their submissions during the event

### `midi-server`
NodeJS daemon for listening for HTTP based post requests. Format is /midi/1 would post the midi value 1. Depending on the target machine hardware, the midi port may need to be changed midiOut.openPort(0)