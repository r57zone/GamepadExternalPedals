#include "DigiKeyboard.h"

// Setup
int Pedal_1_Analog_Pin = 1;
int Pedal_2_Analog_Pin = 0;
//int Pedal_3_Analog_Pin = 0;


int AnalogValue1 = 0;
int AnalogValue2 = 0;
//int AnalogValue3 = 0;

int AnalogValue1Min = 1024;
int AnalogValue1Max = 0;

int AnalogValue2Min = 1024;
int AnalogValue2Max = 0;

//int AnalogValue3Min = 1024;
//int AnalogValue3Max = 0;

void setup()
{  

}

void loop()
{
	AnalogValue1 = analogRead(Pedal_1_Analog_Pin);
	AnalogValue2 = analogRead(Pedal_2_Analog_Pin);
	//AnalogValue3 = analogRead(Pedal_3_Analog_Pin);

	DigiKeyboard.sendKeyStroke(0);

	DigiKeyboard.println("Pedal1 min=" + String(AnalogValue1Min) + " max=" + String(AnalogValue1Max) + " Pedal2 min=" + 
						  String(AnalogValue2Min) + " max=" + String(AnalogValue2Max));
	
	//DigiKeyboard.println("Pedal1 min=" + String(AnalogValue1Min) + " max=" + String(AnalogValue1Max) + " Pedal2 min=" + 
	//					  String(AnalogValue2Min) + " max=" + String(AnalogValue2Max) + " Pedal3 min=" + 
	//					  String(AnalogValue2Min) + " max=" + String(AnalogValue2Max));

	if (AnalogValue1Min > AnalogValue1)
		AnalogValue1Min = AnalogValue1;
	if (AnalogValue1Max < AnalogValue1)
		AnalogValue1Max = AnalogValue1;

	if (AnalogValue2Min > AnalogValue2)
		AnalogValue2Min = AnalogValue2;
	if (AnalogValue2Max < AnalogValue2)
		AnalogValue2Max = AnalogValue2;
	
	//if (AnalogValue3Min > AnalogValue3)
		//AnalogValue3Min = AnalogValue3;
	//if (AnalogValue3Max < AnalogValue3)
		//AnalogValue3Max = AnalogValue3;

	delay(1000);
}