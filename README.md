[![EN](https://user-images.githubusercontent.com/9499881/33184537-7be87e86-d096-11e7-89bb-f3286f752bc6.png)](https://github.com/r57zone/XboxExternalPedals/) 
[![RU](https://user-images.githubusercontent.com/9499881/27683795-5b0fbac6-5cd8-11e7-929c-057833e01fb1.png)](https://github.com/r57zone/XboxExternalPedals/blob/master/README.RU.md)
← Choose language | Выберите язык

# Xbox external pedals
External pedals for gamepads: Xbox, DualSense, DualShock 4, Pro controllers and joycons. Pedals based on DInput or Arduino, compatible with programs: [DSAdvance](https://github.com/r57zone/DSAdvance), [X360Advance](https://github.com/r57zone/X360Advance) and [External Pedals Utility](https://github.com/r57zone/XboxExternalPedals/releases). I recommend the Logitech e-uk12 pedals, they are pretty compact and high quality.

[![](https://github.com/r57zone/XboxExternalPedals/assets/9499881/f4b55990-d795-4455-918f-a08a59122171)](https://youtu.be/aK1SV_eXJ_4)
[![](https://user-images.githubusercontent.com/9499881/195859587-65cdaca4-5abd-4594-b079-e388721ae25d.gif)](https://youtu.be/liI_7U_R0as)

## Soldering
The first type of connection is used to connect pedals, with 2-pin potentiometers. A 10 kΩ resistor is soldered with one contact to A0, and the second contact to 5V. The second 10kom resistor is soldered to A1 and 5V. The potentiometer of the first pedal is soldered with one pin to A0, and the second pin to ground (GND). The potentiometer of the second pedal is soldered with one pin to A1, and the second pin to ground (GND).

![](https://github.com/r57zone/XboxExternalPedals/assets/9499881/edcfe7f9-f512-42c0-84cd-197114c71043)

(MH-ET Live ATtiny88)

![](https://user-images.githubusercontent.com/9499881/195835532-f015b3f1-0a9c-4ed3-ba92-752e9b09edca.png)

(Arduino Nano)

The second type of connection is used to connect pedals, with 3-pin potentiometers. The center pins are connected to A0 and A1, the first pin is connected to 5V, the last pin to ground (GND).

![](https://github.com/r57zone/XboxExternalPedals/assets/9499881/bdaef474-e104-4162-8090-32edca4dcb46)

(MH-ET Live ATtiny88)

![](https://user-images.githubusercontent.com/9499881/195835452-441661bc-d72e-4ff1-8f68-62eaa4354ed8.png)

(Arduino Nano)

## Setup DInput pedals (MH-ET Live ATtiny88 board)
1. Download and install [Arduino IDE](https://www.arduino.cc/en/software).
2. Install the latest [Digispark drivers](https://github.com/digistump/DigistumpArduino/releases/) ("Digistump.Drivers.zip").
3. Launch the Arduino IDE, go to settings and add `http://drazzy.com/package_drazzy.com_index.json` in the "Additional links for board manager" field and click "OK".
4. Go to "Tools" -> "Board" -> "Board Manager", search for `ATTinyCore` and install.
5. Copy [firmware contents for calibration](https://github.com/r57zone/XboxExternalPedals/blob/master/MH-ET%20Live/Calibration.ino), paste it into the Arduino IDE and click the "Upload" button.
6. Connect the MH-Tiny ATTINY88 board after clicking the firmware or click the download button again. MH-Tiny ATTINY88 is flashed immediately after connection (you need to re-plug it for flashing).
7. Open the notepad and press the pedals. The notepad will display values for pedal calibration. For reliability, you can repeat the procedure several times, with USB reconnection, and display the average values. Save your data.
8. Copy [firmware contents](https://github.com/r57zone/XboxExternalPedals/blob/master/MH-ET%20Live/Firmware.ino) and paste into Arduino IDE. Change the parameters `Pedal1Min`, `Pedal1Max` and `Pedal2Min`, `Pedal2Max` to the previously saved ones and click the "Load" button. If necessary, adjust the values so that the percentage of pressing is across the entire pedal, and also enter the required percentage of the dead zone `DeadZonePercentPedal`.
9. Enable DInput search for pedals in [DSAdvance](https://github.com/r57zone/DSAdvance) in the configuration file.
10. You can also use the pedals to press keyboard keys, using [External Pedals Utility](https://github.com/r57zone/XboxExternalPedals/#external-pedals-utility), for example, to activate a function (such as recording video, Discord voice, and so on).

## Setup Arduino pedals
1. Download and install [Arduino IDE](https://www.arduino.cc/en/software).
2. Change the board type to Arduino Nano, also change the Bootloader if necessary.
3. [Download the sketch](https://github.com/r57zone/XboxExternalPedals/blob/master/Firmware.ino), change the 6th line `bool Calibration = false;` to `bool Calibration = true;` for enable calibration mode.
4. Press the pedals several times, note down the minimum and maximum values ​​of the pedals.
5. Enter your values ​​to `PedalMin`, `PedalMax` into the sketch and re-sew it. Look at the results - "Out". If necessary, adjust the values ​​so that the percentage of depression is across the entire pedal, and also enter the desired percentage of the dead zone `DeadZonePercentPedal`.
6. Change the sketch again, `bool Calibration = true;` to `bool Calibration = false;` to disable calibration mode.
7. Change the COM port number in [DSAdvance](https://github.com/r57zone/DSAdvance) or [X360Advance](https://github.com/r57zone/X360Advance/), then the pedals are ready to play.

## External Pedals Utility
Simple utility for pressing keyboard keys with external pedals (only DInput).

![](https://github.com/r57zone/XboxExternalPedals/assets/9499881/6c25a843-4049-435f-adc7-24f35fe08f9a)

## Feedback
`r57zone[at]gmail.com`