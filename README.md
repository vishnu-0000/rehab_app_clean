# REHAB – Rehabilitation Glove

This repository contains the code for the REHAB wearable rehabilitation glove. The system uses an ESP32 to collect sensor data, control the servo motor, and communicate with a Flutter mobile application.

## Project Overview

The ESP32 collects data from the sensors attached to the glove. The sensor data is processed to determine finger movement, grip force, and wrist orientation.

The processed data is sent to the Flutter application through Wi-Fi using TCP communication. The Flutter application displays the collected information and provides the interface for the rehabilitation exercises.

## Hardware Used

* ESP32-WROOM-32
* Flex sensors
* Force Sensitive Resistor (FSR)
* MPU6050 accelerometer and gyroscope
* Servo motor
* XL4016 buck converter
* LM2596 buck converter

## ESP32 Code

The ESP32 firmware handles the main hardware operations:

* Reading the five flex sensors using ADC
* Reading grip force using the FSR
* Reading acceleration and gyroscope data from the MPU6050 using I2C
* Controlling the servo motor using PWM
* Processing sensor readings
* Calibrating sensor values
* Filtering sensor data
* Establishing Wi-Fi communication
* Sending sensor data to the Flutter application using TCP

## Flutter Application

The Flutter application is responsible for the mobile interface and communication with the ESP32.

It provides:

* Connection with the ESP32
* Reception of sensor data
* Display of finger movement data
* Display of grip force
* Display of wrist movement data
* Rehabilitation exercise interface
* Monitoring of collected data

## Code Structure

```text
REHAB/
│
├── ESP32/
│   ├── Sensor reading
│   ├── Sensor calibration
│   ├── MPU6050 communication
│   ├── Servo control
│   └── Wi-Fi/TCP communication
│
└── Flutter/
    ├── User interface
    ├── ESP32 communication
    ├── Sensor data processing
    └── Rehabilitation data display
```

## Communication

The ESP32 connects to the Wi-Fi network and communicates with the Flutter application using TCP.

The ESP32 sends the sensor readings to the application, where the received data is processed and displayed in the user interface.

## Running the ESP32 Code

1. Open the ESP32 code in Arduino IDE or a compatible development environment.
2. Install the required ESP32 board support and libraries.
3. Connect the ESP32 to the computer.
4. Select the ESP32 board and appropriate COM port.
5. Configure the Wi-Fi settings if required.
6. Upload the code to the ESP32.


## Main Functions

| Function            | Purpose                               |
| ------------------- | ------------------------------------- |
| Flex sensor reading | Measures finger bending               |
| FSR reading         | Measures grip force                   |
| MPU6050 reading     | Measures wrist movement               |
| Sensor calibration  | Calibrates sensor readings            |
| Data filtering      | Reduces variations in sensor readings |
| Servo control       | Controls assisted finger movement     |
| Wi-Fi communication | Connects the ESP32 to the application |
| TCP communication   | Transfers sensor data                 |
| Flutter UI          | Displays the collected data           |

## Note

This repository contains the software implementation for the REHAB prototype, including ESP32 firmware and the Flutter mobile application.
