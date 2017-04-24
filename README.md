# micro-controller-radar

We have different ways to measure the distance. One way is to use ultrasonic module for distance measurement. An ultrasonic pulse is generated in a particular direction. If there is an object in the path of this pulse, part or all of the pulse will be reflected back to the transmitter as an echo and can be detected through the receiver path. The mechanism of the ultrasonic sensor is similar to the RADAR (Radio detection and ranging).

An ultrasonic rangefinder can measure distance up to 2.5m at an accuracy of 1 centi meter. At 89S52 micro controller and the ultrasonic transducer module HC-SR04 forms the basis of this circuit. This ultrasonic module sends a signal to the object, then picks up its echo and outputs a wave form whose time period is proportional to the distance. The micro controller accepts this signal, performs necessary processing and show the corresponding distance on the LCD display. It is very suitable for environments where optical sensors are unusable such as smoke, dust. It gives very accurate measurements.


This circuit finds a lot of application in projects as follows:

•	Used to measure obstacle distance

•	Used in terrain monitoring system

•	SONAR

# hardware design

Circuit Components 
•	89S52 Micro controller 
•	Programming board
•	Programming cable
•	DC battery
•	HC-SR04 ultrasonic module
•	16*2 LCD
•	11.0592 MHz Crystal
•	Buzzer
•	LED lights
•	Connecting wires:
1.	Jumper wires male to female
2.	Jumper wires female to female
3.	Jumper wires male to male

#Circuit Working
•	The major components in this project are at 89S52 microcontroller, ultrasonic module, buzzer, LCD. 
•	The ultrasonic sensor TRIGGGER and ECHO pins are connected to the P3.5 and P3.2 respectively.  
•	LCD data pins are connected to the PORT2 of the controller and controller pins RS, RW, En are connected to the P1.0, P1.1 and P1.2 respectively. Here LCD (liquid crystal display) is used to display distance of the object. 
•	Power supply pins of controller and ultrasonic sensor are connected to the 5V DC. 
•	Buzzer’s positive end is connected to VCC in the development and negative end to P0.7. 
•	We used LED as safe and danger lights. The positive ends of LEDs are connected to P0.1 and P0.3 respectively and the negative to GND in the development board. 

#Code working
•	The first part of the program sets the initial conditions. Port 2 is set as output ports for sending LCD patterns and LCD commands respectively. Port pin P3.5 is set as an output pin for sending the trigger signal to the ultrasonic module for starting transmission and port pin 3.2 is set as an input pin for receiving the echo. 
•	TMOD register of the microcontroller is so loaded that the Timer 1 operates in mode2 8 bit auto-reload mode. In the next part of the program (loop MAIN) the TL1 and TH1 registers of Timer1 are loaded with the initial values. TL1 is loaded with the initial value to start counting from and TH1 is loaded with the reload value.  When roll over occurs, TF1 flag is set and TL1 is automatically loaded with the reload value stored in TH1 and the sequence is repeated until TR1 is made low by the program.
•	In the next part of the MAIN loop P3.5 is set high for 10uS and then cleared to make 10uS triggering pulse. The ultrasonic module issues a 40Khz pulse wave form after receiving this trigger and the program waits until a valid echo is received at P3.2. The pulse width of the echo signal is proportional to the distance to the obstacle
•	Whenever there is a valid echo pulse at P3.5, the Timer1 starts and it counts from the initial value to 255 ie: 255-207= 48 counts. Then the counter restarts and accumulator increments by one for every restart. This sequence is repeated until the echo signal at P3.2 vanishes (ie; P3.2 goes low). 
•	The content in A will be equal to the number of  Timer1 reloads which is in fact proportional to the distance. From the datasheet it is clear that 58uS echo pulse width indicates 1cM distance. When the processor is clocked by a 12MHz crystal, 58 counts of Timer1 indicates 1cm. But here Timer1 counts only 48 times before reload and this is done in order to compensate for the time lags caused by the branching instructions used for checking the status of P3.5 and P3.2 pins.
