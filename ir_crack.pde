
#define IR_LED 7
#define MAX 128
#define MICRO_STEP 10
#define IDLE_PULSE 10000

unsigned long pulses[MAX];

void setup()
{
  pinMode(IR_LED, INPUT);
  Serial.begin(115200);
}

void loop()
{   
  // The IR receiver output is set HIGH until a signal comes in ...
  if( digitalRead(IR_LED) == LOW)
  {
    //Start receiving data ...
    int count = 0;
    int exit = 0;
    while(!exit)
    {
      while( digitalRead(IR_LED) == LOW )
        delayMicroseconds(MICRO_STEP);

      // Store the time when the pulse begin      
      unsigned long start = micros();

      int max_high = 0;
      while( digitalRead(IR_LED) == HIGH )
      {
        delayMicroseconds(MICRO_STEP);
        
        max_high += MICRO_STEP;
        if( max_high > IDLE_PULSE )
        {
          exit = 1;
          break;
        }
      }
        
      unsigned long duration = micros() - start;
      pulses[count++] = duration;
    }
    
    for(int i=0; i<count; i++)
    {
      if(pulses[i] > IDLE_PULSE)
      {
        Serial.print("<");
        Serial.print(pulses[i], DEC);
        Serial.print(">|");
      }
      else
      {
        Serial.print(pulses[i], DEC);
        Serial.print("|");
      }
    }
    
    Serial.println(".");
  }
}

