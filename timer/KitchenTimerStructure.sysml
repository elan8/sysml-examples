package KitchenTimerStructure {
	import KitchenTimerPorts::*;
	import KitchenTimerBehavior::*;

	private import ScalarValues::*;
	private import ISQBase::DurationValue;

	part def Microcontroller {
		doc /* MCU on PCB with built-in LCD controller; runs timer firmware; COM/SEG to display glass, GPIO to buttons. */
		attribute clockFrequency : Real;
		attribute flashSize : Real;
		attribute ramSize : Real;
		port buttonIn : ~ButtonInputPort;
		port displayOut : DisplayCommandPort;
		port lcdDrive : LcdSegmentDrivePort;
		port buzzerOut : BuzzerCommandPort;
		port pwr : ~BatteryOutlet { :>> maxCurrent = 0.02 [A]; }
		exhibit state timerMode : TimerStateMachine;
	}

	part def BuzzerDriver {
		doc /* Transistor or FET; switches battery power to buzzer when MCU GPIO is high. */
		port ctrlIn : ~BuzzerCommandPort;
		port pwrIn : ~BatteryOutlet { :>> maxCurrent = 0.001 [A]; }
		port buzzerPwrOut : BatteryOutlet;
	}

	part def Display {
		doc /* Segment LCD glass; COM/SEG from MCU LCD controller; shows MM:SS. */
		attribute format : String;
		port cmd : ~DisplayCommandPort;
		port lcdIn : ~LcdSegmentDrivePort;
		port pwr : ~BatteryOutlet { :>> maxCurrent = 0.01 [A]; }
	}

	part def ButtonInterface {
		doc /* Captures user input; debounces buttons. */
		port output : ButtonInputPort;
		port pwr : ~BatteryOutlet { :>> maxCurrent = 0.001 [A]; }
	}

	part def Buzzer {
		doc /* Piezo or similar; has only +/- terminals; buzzes when power is applied. */
		attribute duration : DurationValue;
		port pwr : ~BatteryOutlet { :>> maxCurrent = 0.05 [A]; }
	}

	part def TimerPCB {
		doc /* PCB assembly; display and buttons mounted on board; MCU and buzzer driver. */
		part mcu : Microcontroller;
		part display : Display;
		part buttons : ButtonInterface;
		part buzzerDriver : BuzzerDriver;
		connect buttons.output to mcu.buttonIn;
		connect mcu.displayOut to display.cmd;
		connect mcu.lcdDrive to display.lcdIn;
		connect mcu.buzzerOut to buzzerDriver.ctrlIn;
	}

	part def Battery {
		doc /* Power supply for all subsystems; e.g. 3xAAA. */
		attribute capacity : Real;
		attribute voltage : Real;
		attribute runtimeEstimate : DurationValue;
		port powerOut : BatteryOutlet;
	}

	part def KitchenTimer {
		doc /* Battery-powered kitchen timer; PCB with MCU, display, buttons, buzzer driver; buzzer off-board. */
		part pcb : TimerPCB;
		part battery : Battery;
		part buzzer : Buzzer;

		connect battery.powerOut to pcb.mcu.pwr;
		connect battery.powerOut to pcb.display.pwr;
		connect battery.powerOut to pcb.buttons.pwr;
		connect battery.powerOut to pcb.buzzerDriver.pwrIn;
		connect pcb.buzzerDriver.buzzerPwrOut to buzzer.pwr;
	}

}
