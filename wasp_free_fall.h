#ifndef WASPMOTE_H_
#define WASPMOTE_H_

#include "AP-NURSEF05.h"

/**
 * @brief Serial Port initialisation
 * 
 * Used to initialise Serial Port connected to the USB port
 */
void initSerialPort(void);

/**
 * @brief Waspmote sensors initialisation
 * 
 * Used to Initialise waspmote unit sensors
 */
void initSensors(void);

/**
 * @brief Main programme loop
 * 
 * Main logic loop of the programme
 */
void waspmoteLoop(void);

#endif//WASPMOTE_H_