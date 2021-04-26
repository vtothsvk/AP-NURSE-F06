#include "wasp_free_fall.h"


char moteID[] = "AP-W8-01";
char password[] = "libeliumlibelium"; 
int     Pvalue = 0;
uint8_t error;
uint8_t status;
char body[] = "POZOR pad vozika!!!";

void initSensors()
{ 
    //Check WiFi connection
    isConnected();
    //Check WiFi IP
    wifiGetIp();
    } 
  Utils.readSerialID();
  
  USB.print(F("Waspmote serial ID: "));
  USB.printHex(_serial_id[0]);
  USB.printHex(_serial_id[1]);
  USB.printHex(_serial_id[2]);
  USB.printHex(_serial_id[3]);
  USB.printHex(_serial_id[4]);
  USB.printHex(_serial_id[5]);
  USB.printHex(_serial_id[6]);
  USB.printHex(_serial_id[7]);
  USB.println();

  delay(1000);
    // open serial port
  PWR.setSensorPower(SENS_3V3, SENS_ON);
  USB.ON();
  RTC.ON();
}//initSensors

void waspmoteLoop()
{
  ///////////////////////////////////////////////
  // 1. Starts accelerometer
  ///////////////////////////////////////////////
  ACC.ON();
  ///////////////////////////////////////////////
  // 2. Enable interruption: ACC Free Fall interruption 
  ///////////////////////////////////////////////
//  ACC.setFF(2000); 
   ACC.setFF();
//------------------------------------------------------
// casovac na spravu, ze zariadenie je funkcne
//  RTC.setAlarm1("00:00:01:00",RTC_OFFSET,RTC_ALM1_MODE2);
//------------------------------------------------------
  ///////////////////////////////////////////////
  // 3. Set low-power consumption state
  /////////////////////////////////////////////// 
  USB.println(F("Waspmote goes into sleep mode until the Accelerometer causes an interrupt"));
//  PWR.sleep(ALL_OFF); 
    PWR.deepSleep("00:00:10:00", RTC_OFFSET, RTC_ALM1_MODE1);


  // Interruption event happened

  ///////////////////////////////////////////////
  // 4. Disable interruption: ACC Free Fall interrupt 
  //    This is done to avoid new interruptions
  ///////////////////////////////////////////////
  ACC.ON();
  RTC.ON();
  ACC.unsetFF(); 
  PWR.setSensorPower(SENS_3V3, SENS_ON);

// zistit, ci toto staci na inicializaciu wifi pripojenia!!!!!!! 
    //start WiFi connection
    startWifiManager()

  ///////////////////////////////////////////////
  // 5. Check the interruption source 
  ///////////////////////////////////////////////
  // Only mandatory when multiple interruption 
  // sources are expected to be generated
  if( intFlag & ACC_INT )
  {
    // clear interruption flag
    intFlag &= ~(ACC_INT);
    USB.ON();
    USB.println(F("++++++++++++++++++++++++++++"));
    USB.println(F("++ ACC interrupt detected ++"));
    USB.println(F("++++++++++++++++++++++++++++")); 
    USB.println(); 
//    delay(5000);
    USB.println(intFlag);
    
// HTTPS sprava na meshlium
//      char body[] = "POZOR pad vozika";
      float Blevel = PWR.getBatteryLevel();
      Pvalue = 1;
//      frame.createFrame(ASCII);
//      frame.addSensor(SENSOR_BAT, Blevel);
//      frame.addSensor(SENSOR_STR, body);
//      frame.encryptFrame( AES_128, password );
//      frame.showFrame();
//      delay(1000);

//      error = WIFI_PRO.sendFrameToMeshlium( type, host, port, frame.buffer, frame.length);
//        if (error == 0)
//  {    
//    USB.println(F("WiFi t OK"));
//  }
//  else
//  {
//    USB.println(F("WiFi  ERROR"));
//  }

// sprava HTTP na premostovaci server
      char* payload = createPostPayload(FALL_FORMAT, Pvalue);
      char* payload = createPostPayload(Bat_FORMAT, Blevel);
      ERROR_CHECK(
            postData(payload)
      );
    for(int i=0; i<10; i++)
    {
      Utils.blinkLEDs(500);
    }
    
  }
//------------------------------------------------------
// sprava ze fungujem a stav baterie
//------------------------------------------------------
  if( intFlag & RTC_INT )
  {
    intFlag &= ~(RTC_INT); 
// sprava na meshlium
    float Blevel = PWR.getBatteryLevel();
    Pvalue = 0;
//    char body[] = "Zijem";
//    frame.createFrame(ASCII);
//    frame.addSensor(SENSOR_STR, body);
//    frame.addSensor(SENSOR_BAT, Blevel);
//    frame.showFrame();
//    frame.encryptFrame( AES_128, password );
//    frame.showFrame();
//    delay(100);
    
//    error = WIFI_PRO.sendFrameToMeshlium( type, host, port, frame.buffer, frame.length);

// sprava HTTP na premostovaci server
      char* payload = createPostPayload(FALL_FORMAT, Pvalue);
      char* payload = createPostPayload(Bat_FORMAT, Blevel);
      ERROR_CHECK(
            postData(payload)
      );
  }

  ///////////////////////////////////////////////////////////////////////
  // 6. Clear interruption pin   
  ///////////////////////////////////////////////////////////////////////
  // This function is used to make sure the interruption pin is cleared
  // if a non-captured interruption has been produced
  PWR.clearInterruptionPin();
}

