// Setup
int Pedal_1_Analog_Pin = 0;
int Pedal_2_Analog_Pin = 1;

// Calibration
bool Calibration = false;

int Pedal1Min = 440;
int Pedal1Max = 859;
int DeadZonePercentPedal1 = 0;

int Pedal2Min = 430;
int Pedal2Max = 834;
int DeadZonePercentPedal2 = 11;

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

/*float DeadZoneAxis(float StickAxis, float DeadZonePercent)
{
  StickAxis-=DeadZonePercent;
  if (StickAxis < 0)
    StickAxis = 0;
  StickAxis = StickAxis + StickAxis * DeadZonePercent / 100;
  if (StickAxis > 100)
    StickAxis = 100;
  
  return StickAxis / 100.0;
}*/

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
  Serial.begin(115200);
}

void loop()
{
  AnalogValue1 = analogRead(Pedal_1_Analog_Pin);
  AnalogValue2 = analogRead(Pedal_2_Analog_Pin);

  PedalsValues[0] = DeadZoneAxis((AnalogValue1 - Pedal1Min) / Pedal1Diff, DeadZonePercentPedal1);
  PedalsValues[1] = DeadZoneAxis((AnalogValue2 - Pedal2Min) / Pedal2Diff, DeadZonePercentPedal2);
  
  if (Calibration) {
    Serial.print("Calibration: Min1=");
    Serial.print(AnalogValue1Min);
    Serial.print(", Max1=");
    Serial.print(AnalogValue1Max);
    Serial.print("\tMin2=");
    Serial.print(AnalogValue2Min);
    Serial.print(", Max2=");
    Serial.print(AnalogValue2Max);
    Serial.print("\tOut: Pedal1=");
    Serial.print(PedalsValues[0] * 100.0);
    Serial.print(", Pedal2=");
    Serial.print(PedalsValues[1] * 100.0);
    Serial.println(' ');
    
    if (AnalogValue1Min > AnalogValue1)
      AnalogValue1Min = AnalogValue1;
    if (AnalogValue1Max < AnalogValue1)
      AnalogValue1Max = AnalogValue1;

    if (AnalogValue2Min > AnalogValue2)
      AnalogValue2Min = AnalogValue2;
    if (AnalogValue2Max < AnalogValue2)
      AnalogValue2Max = AnalogValue2;
  } else
      Serial.write((byte*)&PedalsValues, sizeof(PedalsValues));
      
  delay(1);
}