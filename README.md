# Fan Toggle

Arduino Uno firmware that toggles a fan on pin 9 (D9) over USB serial.
Flash it once, then `make toggle-on` / `make toggle-off` from the host:
`'1'` sets the pin to full PWM duty (`motorMAXpwm` = 255), `'0'` sets it to 0.

## Requirements

- Arduino Uno on USB
- [`arduino-cli`](https://arduino.github.io/arduino-cli/) on the host

## Quick start

```sh
make setup       # one-time: install the pinned AVR core
make list        # find your board's port
make upload      # compile + flash the firmware
make toggle-on   # fan to full speed
make toggle-off  # fan off
```

## Targets

| Target       | Description                                        |
|--------------|----------------------------------------------------|
| `setup`      | Install/verify the pinned AVR core                 |
| `list`       | Detect connected boards and ports                  |
| `build`      | Compile the sketch to `build/` (default target)    |
| `upload`     | Compile + flash to the board                       |
| `build-blank`  | Compile the blank (do-nothing) sketch to `build/blank/` |
| `upload-blank` | Flash the blank sketch — stops the fan program     |
| `toggle-on`  | Send `'1'` over serial → pin 9 = 255               |
| `toggle-off` | Send `'0'` over serial → pin 9 = 0                 |
| `monitor`    | Open the serial monitor (shows `pwm=…` acks)       |
| `clean`      | Remove build artifacts                             |

## Configuration

Precedence: command line > `config/local.mk` (gitignored, see
`config/local.mk.example`) > Makefile defaults.

| Variable | Default            | Notes                                                      |
|----------|--------------------|------------------------------------------------------------|
| `PORT`   | `/dev/ttyACM0`     | Prefer a stable `/dev/serial/by-id/…` or `by-path/…` path  |
| `FQBN`   | `arduino:avr:uno`  |                                                            |
| `BAUD`   | `9600`             | Must match `serialBaud` in the firmware                    |
| `CLI`    | `arduino-cli`      |                                                            |

## Notes

- The toggle targets sleep ~1 s before sending: opening the port can
  auto-reset the Uno (DTR), and the bootloader needs that long before the
  sketch is listening. The recipes clear HUPCL so repeat toggles don't reset.
- The firmware starts with the fan off, so the state after any reset is off.
- Wiring: see [docs/wiring.md](docs/wiring.md).
