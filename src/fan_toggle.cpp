/*
 * Purpose: Listens on serial for single-character commands and toggles the
 *          fan PWM output: '1' -> full speed, '0' -> off.
 * Copyright (c) 2026 Logan Kaising. All rights reserved.
 */

#include "fan_toggle.h"

#include <Arduino.h>

constexpr uint8_t motorPin = 9;
constexpr uint8_t motorMAXpwm = 255;
constexpr unsigned long serialBaud = 9600;  // must match BAUD in Makefile/config/local.mk

void fan_toggle_setup() {
  pinMode(motorPin, OUTPUT);
  analogWrite(motorPin, 0);  // fan off at boot (and after any DTR auto-reset)
  Serial.begin(serialBaud);
}

void fan_toggle_loop() {
  while (Serial.available() > 0) {
    char c = (char)Serial.read();
    if (c == '1') {
      analogWrite(motorPin, motorMAXpwm);
      Serial.println(F("pwm=255"));
    } else if (c == '0') {
      analogWrite(motorPin, 0);
      Serial.println(F("pwm=0"));
    }
  }
}
