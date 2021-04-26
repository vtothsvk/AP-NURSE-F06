#include "AP-NURSEF05.h"

void setup() {
    //Init Serial port
    initSerialPort();

    //Inint WiFi
    ERROR_CHECK(
        startWifiManager()
    );

    //Init sensors
    initSensors();
}//setup

void loop() {
    //main programme loop
    waspmoteLoop();
}//loop
