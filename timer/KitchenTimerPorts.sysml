package KitchenTimerPorts {
	private import ScalarValues::*;
	private import SI::volt;
	private import SI::ampere;
	private import ISQElectromagnetism::electricPower;

	port def BatteryOutlet {
		doc /* DC power source; e.g. 3xAAA = 4.5 V, max 0.5 A. */
		out power : electricPower;
		attribute voltage = 4.5 [V];
		attribute maxCurrent = 0.5 [A];
	}

	port def ButtonInputPort {
		in startPressed : Boolean;
		in stopPressed : Boolean;
		in resetPressed : Boolean;
		in incrementPressed : Boolean;
		in decrementPressed : Boolean;
	}

	port def DisplayCommandPort {
		out displayValue : String;
	}

	port def LcdSegmentDrivePort {
		doc /* COM/SEG lines from MCU LCD controller to segment LCD glass; multiplexed drive. */
		out comSegDrive : String;
	}

	port def BuzzerCommandPort {
		out buzzerOn : Boolean;
	}

}
