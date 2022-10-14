[![EN](https://user-images.githubusercontent.com/9499881/33184537-7be87e86-d096-11e7-89bb-f3286f752bc6.png)](https://github.com/r57zone/XboxExternalPedals/) 
[![RU](https://user-images.githubusercontent.com/9499881/27683795-5b0fbac6-5cd8-11e7-929c-057833e01fb1.png)](https://github.com/r57zone/XboxExternalPedals/blob/master/README.RU.md)
&#8211; Other languages / Другие языки

# Xbox external pedals
External pedals for gamepads: Xbox, DualSense, DualShock 4, Pro controllers and joycons. Pedals based on Arduino work, compatible with programs: [DSAdvance](https://github.com/r57zone/DSAdvance) and [X360Advance](https://github.com/r57zone/X360Advance).

[![](https://user-images.githubusercontent.com/9499881/195859587-65cdaca4-5abd-4594-b079-e388721ae25d.gif)](https://youtu.be/liI_7U_R0as)

# Soldering
The first type of connection is used to connect pedals, with 2-pin potentiometers. A 10 kΩ resistor is soldered with one contact to A0, and the second contact to 5V. The second 10kom resistor is soldered to A1 and 5V. The potentiometer of the first pedal is soldered with one pin to A0, and the second pin to ground (GND). The potentiometer of the second pedal is soldered with one pin to A1, and the second pin to ground (GND).

![](https://user-images.githubusercontent.com/9499881/195835452-441661bc-d72e-4ff1-8f68-62eaa4354ed8.png)

The second type of connection is used to connect pedals, with 3-pin potentiometers. The center pins are connected to A0 and A1, the first pin is connected to 5V, the last pin to ground (GND).

![](https://user-images.githubusercontent.com/9499881/195835532-f015b3f1-0a9c-4ed3-ba92-752e9b09edca.png)

## Setup
1. Download and install [Arduino IDE](https://www.arduino.cc/en/software).
2. Change the board type to Arduino Nano, also change the Bootloader if necessary.
3. [Download the sketch](https://github.com/r57zone/XboxExternalPedals/blob/master/Firmware.ino), change the 6th line `bool Calibration = false;` to `bool Calibration = true;` for enable calibration mode.
4. Press the pedals several times, note down the minimum and maximum values ​​of the pedals.
5. Enter your values ​​to `PedalMin`, `PedalMax` into the sketch and re-sew it. Look at the results - "Out". If necessary, adjust the values ​​so that the percentage of depression is across the entire pedal, and also enter the desired percentage of the dead zone `DeadZonePercentPedal`.
6. Change the sketch again, `bool Calibration = true;` to `bool Calibration = false;` to disable calibration mode.
7. Change the COM port number in DSAdvance or X360Advance, then the pedals are ready to play.

## Feedback
`r57zone[at]gmail.com`