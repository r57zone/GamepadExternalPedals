[![EN](https://user-images.githubusercontent.com/9499881/33184537-7be87e86-d096-11e7-89bb-f3286f752bc6.png)](https://github.com/r57zone/XboxExternalPedals/) 
[![RU](https://user-images.githubusercontent.com/9499881/27683795-5b0fbac6-5cd8-11e7-929c-057833e01fb1.png)](https://github.com/r57zone/XboxExternalPedals/blob/master/README.RU.md)

# Xbox external pedals
Внешние педали для геймпадов: Xbox, DualSense, DualShock 4, Pro контроллеров и джойконов. Работают педали на базе DInput или Arduino, совместимы с программами: [DSAdvance](https://github.com/r57zone/DSAdvance) и [X360Advance](https://github.com/r57zone/X360Advance). Рекомендую педали Logitech e-uk12, они довольно компактные и качественные.

[![](https://user-images.githubusercontent.com/9499881/195859587-65cdaca4-5abd-4594-b079-e388721ae25d.gif)](https://youtu.be/liI_7U_R0as)

## Пайка
Первый тип подключения используется для подключения педалей с потанциометрами на 3 пина. Центральные пины подключаются на А0 и А1, первый пин подключается на 5В, последний пин на землю (GND).

![](https://github.com/r57zone/XboxExternalPedals/assets/9499881/a949e917-2036-425d-9a41-ec9ec4fe7d8d)

![](https://user-images.githubusercontent.com/9499881/195832530-b340d0af-6b0d-4104-8a02-5b61916017a0.png)

Второй тип подключения используется для подключения педалей с потанциометрами на 2 пина. Резистор на 10 кОм припаивается одним контактом на A0, а вторым контактом на 5В. Второй резистор на 10 кОм припаивается на А1 и 5В. Потанциометр первой педали припаивается одним контактом на А0, а вторым контактом на землю (GND). Потанциометр второй педали припаивается одним контактом на А1, а вторым контактом на землю (GND). 

![](https://github.com/r57zone/XboxExternalPedals/assets/9499881/c1aa6a34-2b31-47d2-a648-3b9150848572)

![](https://user-images.githubusercontent.com/9499881/195828237-f4f72bb1-144a-4768-94bd-6808da9caba1.png)

## Настройка DInput педалей (плата MH-ET Live)
1. Загрузите и установите [Arduino IDE](https://www.arduino.cc/en/software).
2. Установите последние [драйверы Digispark](https://github.com/digistump/DigistumpArduino/releases/) ("Digistump.Drivers.zip").
3. Запустите Arduino IDE, перейдите в настройки и добавьте `http://drazzy.com/package_drazzy.com_index.json` в поле "Дополнителньые ссылки для менеджера плат" и нажмите "ОК".
4. Перейдите в "Инструменты" -> "Плата" -> "Менеджер плат", введите в поиске `ATTinyCore` и установите.
5. Скопируйте [содержимое прошивки для калибровки](https://github.com/r57zone/XboxExternalPedals/blob/master/MH-ET%20Live/Calibration.ino), вставьте в Arduino IDE и нажмите кнопку "Вгрузить".
6. Подключите плату MH-Tiny ATTINY88 после нажатия прошивки или нажмите кнопку загрузки снова. MH-Tiny ATTINY88 прошивается сразу после подключения (нужно перевтыкать для перепрошивки).
7. Откройте блокнот и нажимайте на педали. В блокнот будут выводиться значения для калибровки педалей. Для надежности можно повторить процедуру несколько раз, с перевтыканием USB и вывести средние значения. Сохраните данные.
8. Скопируйте [содержимое прошивки](https://github.com/r57zone/XboxExternalPedals/blob/master/MH-ET%20Live/Firmware.ino) и вставье в Arduino IDE . Измените параметры `Pedal1Min`, `Pedal1Max` и `Pedal2Min`, `Pedal2Max` на ранее сохраненные и нажмите кнопку "Вгрузить". При необходимости подправьте значения так, чтобы процент нажатия был по всей педали, а также введите необходимый процент мёртвой зоны `DeadZonePercentPedal`.
9. Включите поиск DInput педалей в [DSAdvance](https://github.com/r57zone/DSAdvance) в конфигурационном файле.

## Настройка Arduino педалей
1. Загрузите и установите [Arduino IDE](https://www.arduino.cc/en/software).
2. Измените тип платы на Arduino Nano, также при необходимости измените Bootloader.
3. [Загрузите скетч](https://github.com/r57zone/XboxExternalPedals/blob/master/Firmware.ino), измените в 6-ой строке `bool Calibration = false;` на `bool Calibration = true;` для включения режима калибровки.
4. Нажмите педали несколько раз, запишите минимальные и максимальные значения педалей.
5. Введите ваши значения `PedalMin`, `PedalMax` в скетч и прошейте его заново. Посмотрите результаты - "Out". При необходимости подправьте значения так, чтобы процент нажатия был по всей педали, а также введите необходимый процент мёртвой зоны `DeadZonePercentPedal`.
6. Измените в скетче снова, `bool Calibration = true;` на `bool Calibration = false;` для выключения режима калибровки.
7. Измените номер COM-порта в программах [DSAdvance](https://github.com/r57zone/DSAdvance) или [X360Advance](https://github.com/r57zone/X360Advance/), после чего педали готовы к игре.

## Обратная связь
`r57zone[собака]gmail.com`