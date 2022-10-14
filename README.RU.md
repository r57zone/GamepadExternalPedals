[![EN](https://user-images.githubusercontent.com/9499881/33184537-7be87e86-d096-11e7-89bb-f3286f752bc6.png)](https://github.com/r57zone/DSAdvance/) 
[![RU](https://user-images.githubusercontent.com/9499881/27683795-5b0fbac6-5cd8-11e7-929c-057833e01fb1.png)](https://github.com/r57zone/DSAdvance/blob/master/README.RU.md)

# Xbox external pedals
Внешние педали для геймпадов: Xbox, DualSense, DualShock 4, Pro контроллеров и джойконов. Работают педали на базе Arduino, совместимы с программами: [DSAdvance](https://github.com/r57zone/DSAdvance) и [X360Advance](https://github.com/r57zone/X360Advance).
![](https://user-images.githubusercontent.com/9499881/195859587-65cdaca4-5abd-4594-b079-e388721ae25d.gif)

# Пайка
Первый тип подключения используется для подключения педалей, с потанциометрами на 2 пина. Резистор на 10 кОм припаивается одним контактом на A0, а вторым контактом на 5В. Второй резистор на 10 кОм припаивается на А1 и 5В. Потанциометр первой педали припаивается одним контактом на А0, а вторым контактом на землю (GND). Потанциометр второй педали припаивается одним контактом на А1, а вторым контактом на землю (GND). 

![](https://user-images.githubusercontent.com/9499881/195828237-f4f72bb1-144a-4768-94bd-6808da9caba1.png)

Второй тип подключения используется для подключения педалей, с потанциометрами на 3 пина. Центральные пины подключаются на А0 и А1, первый пин подключается на 5В, последний пин на землю (GND).

![](https://user-images.githubusercontent.com/9499881/195832530-b340d0af-6b0d-4104-8a02-5b61916017a0.png)

## Настройка
1. Загрузите и установите [Arduino IDE](https://www.arduino.cc/en/software).
2. Измените тип платы на Arduino Nano, также при необходимости измените Bootloader.
3. [Загрузите скетч](https://github.com/r57zone/XboxExternalPedals/blob/master/Firmware.ino), измените в 6-ой строке `bool Calibration = false;` на `bool Calibration = true;` для включения режима калибровки.
4. Нажмите педали несколько раз, запишите минимальные и максимальные значения педалей.
5. Введите ваши значения `PedalMin`, `PedalMax` в скетч и прошейте его заново. Посмотрите результаты - "Out". При необходимости подправьте значения так, чтобы процент нажатия был по всей педали, а также введите необходимый процент мёртвой зоны `DeadZonePercentPedal`.
6. Измените в скетче снова, `bool Calibration = true;` на `bool Calibration = false;` для выключения режима калибровки.
7. Измените номер COM-порта в программах DSAdvance или X360Advance, после чего педали готовы к игре.

## Обратная связь
`r57zone[собака]gmail.com`