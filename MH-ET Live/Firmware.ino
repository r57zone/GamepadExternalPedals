#include <DigiJoystick.h>  

// Setup
int Pedal_1_Analog_Pin = 1;
int Pedal_2_Analog_Pin = 0;

byte buttons = 0x00;

// Added 15 to the minimum and subtracted 15 from the maximum, it's better that way. A little deadzone wouldn't hurt from interference back and forth
// Прибавил к минимуму 15 и вычел 15 из максимума, так будет получше. Небольшая дедзона не помешает от помех туда сюда
int Pedal1Min = 127;
int Pedal1Max = 811;
int DeadZonePercentPedal1 = 2;

int Pedal2Min = 188;
int Pedal2Max = 895;
int DeadZonePercentPedal2 = 2;

// Sketch
float PedalsValues[2];

int Pedal1Diff = (Pedal1Max - Pedal1Min) / 100.0;
int Pedal1DiffFull = (Pedal1Max - Pedal1Min);
int Pedal2Diff = (Pedal2Max - Pedal2Min) / 100.0;
int Pedal2DiffFull = (Pedal2Max - Pedal2Min);

int AnalogValue1 = 0;
int AnalogValue2 = 0;

int AnalogValue1Min = 1024;
int AnalogValue1Max = 0;

int AnalogValue2Min = 1024;
int AnalogValue2Max = 0;

float DeadZoneAxis(float StickAxis, float DeadZone)
{
	if (StickAxis <= DeadZone)
		StickAxis = 0;
	else if (StickAxis > 100)
		StickAxis = 100;

	return StickAxis / 100.0;
}

void setup()
{  
	DigiJoystick.setX((byte)127);
	DigiJoystick.setY((byte)127);
	DigiJoystick.setZROT((byte)0);
}

void loop()
{
	AnalogValue1 = analogRead(Pedal_1_Analog_Pin);
	AnalogValue2 = analogRead(Pedal_2_Analog_Pin);

	PedalsValues[0] = 1.0 - DeadZoneAxis((AnalogValue1 - Pedal1Min) / Pedal1Diff, DeadZonePercentPedal1);
	PedalsValues[1] = 1.0 - DeadZoneAxis((AnalogValue2 - Pedal2Min) / Pedal2Diff, DeadZonePercentPedal2);

	DigiJoystick.setXROT((byte)(PedalsValues[0] * 255));
	DigiJoystick.setYROT((byte)(PedalsValues[1] * 255));

	buttons = 0x00;

	if (PedalsValues[0] > 0.2)
		buttons |= 0x1;
	if (PedalsValues[1] > 0.2)
		buttons |= 0x2;

	DigiJoystick.setButtons((byte)buttons, 0x00);
	DigiJoystick.update();    

	delay(1);
}