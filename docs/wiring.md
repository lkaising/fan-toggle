# Wiring

| Connection | Arduino Uno pin | Notes                                        |
|------------|-----------------|----------------------------------------------|
| Fan/motor  | D9 (OUTPUT, PWM)| Drive through a transistor/motor driver — do not power a motor directly from the pin |
| Host link  | USB             | Serial command link, 9600 baud: `'1'` = full speed, `'0'` = off |
