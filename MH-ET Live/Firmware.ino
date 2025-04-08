#include <DigiJoystick.h>  

// Setup
int Pedal_1_Analog_Pin = 1;
int Pedal_2_Analog_Pin = 0;
//int Pedal_3_Analog_Pin = 0;

byte buttons = 0x00;

// Added 15 to the minimum and subtracted 15 from the maximum, it's better that way. A little deadzone wouldn't hurt from interference back and forth
// Прибавил к минимуму 15 и вычел 15 из максимума, так будет получше. Небольшая дедзона не помешает от помех туда сюда
int Pedal1Min = 127;
int Pedal1Max = 811;
int DeadZonePercentPedal1 = 2;

int Pedal2Min = 188;
int Pedal2Max = 895;
int DeadZonePercentPedal2 = 2;

//int Pedal3Min = 188;
//int Pedal3Max = 895;
//int DeadZonePercentPedal3 = 2;

// Sketch
float PedalsValues[2];
//float PedalsValues[3];

int Pedal1Diff = (Pedal1Max - Pedal1Min) / 100.0;
int Pedal1DiffFull = (Pedal1Max - Pedal1Min);
int Pedal2Diff = (Pedal2Max - Pedal2Min) / 100.0;
int Pedal2DiffFull = (Pedal2Max - Pedal2Min);
//int Pedal3Diff = (Pedal3Max - Pedal3Min) / 100.0;
//int Pedal3DiffFull = (Pedal3Max - Pedal3Min);

int AnalogValue1 = 0;
int AnalogValue2 = 0;
//int AnalogValue3 = 0;

int AnalogValue1Min = 1024;
int AnalogValue1Max = 0;

int AnalogValue2Min = 1024;
int AnalogValue2Max = 0;

//int AnalogValue3Min = 1024;
//int AnalogValue3Max = 0;

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
	DigiJoystick.setXROT((byte)0);
	DigiJoystick.setYROT((byte)0);
	
	// Another buttons for actions
    //for (int i = 0; i < 16; i++)
        //pinMode(buttonPins[i], INPUT_PULLUP);
}

void loop()
{
	AnalogValue1 = analogRead(Pedal_1_Analog_Pin);
	AnalogValue2 = analogRead(Pedal_2_Analog_Pin);
	//AnalogValue3 = analogRead(Pedal_3_Analog_Pin);

	PedalsValues[0] = 1.0 - DeadZoneAxis((AnalogValue1 - Pedal1Min) / Pedal1Diff, DeadZonePercentPedal1);
	PedalsValues[1] = 1.0 - DeadZoneAxis((AnalogValue2 - Pedal2Min) / Pedal2Diff, DeadZonePercentPedal2);
	//PedalsValues[2] = 1.0 - DeadZoneAxis((AnalogValue3 - Pedal3Min) / Pedal3Diff, DeadZonePercentPedal3);

	DigiJoystick.setXROT((byte)(PedalsValues[0] * 255));
	DigiJoystick.setYROT((byte)(PedalsValues[1] * 255));
	//DigiJoystick.setZROT((byte)(PedalsValues[2] * 255));

	buttons = 0x00;

	if (PedalsValues[0] > 0.2)
		buttons |= 0x1;
	if (PedalsValues[1] > 0.2)
		buttons |= 0x2;
	//if (PedalsValues[2] > 0.2)
		//buttons |= 0x4;
	
	// Another buttons for actions
	//for (int i = 0; i < 14; i++)
        //if (digitalRead(buttonPins[i]) == LOW)
            //buttons |= (1 << i);

	DigiJoystick.setButtons((byte)buttons, 0x00);
	DigiJoystick.update();    

	delay(1);
}