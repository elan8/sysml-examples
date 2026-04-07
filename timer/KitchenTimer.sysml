/*
* Kitchen Timer - SysML v2 model.
*/
package KitchenTimer {
	doc /* Root package for the kitchen timer example. */

	// ========== Value types ==========
	attribute def Integer;
	attribute def Real;
	attribute def TimeValue;
	attribute def String;
	attribute def Boolean;
	private import SI::V;
	private import SI::A;
	private import ISQElectromagnetism::electricPower;

	port def BatteryOutlet {
		doc /* DC power source; e.g. 3xAAA = 4.5 V, max 0.5 A. */
		out power : electricPower;
		attribute voltage = 4.5 [V];
		attribute maxCurrent = 0.5 [A];
	}

	// ========== Port definitions (README §8) ==========
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

	// ========== Part definitions (README §3, §4) ==========
	// ========== Implementation-level parts ==========
	part def Microcontroller {
		doc /* MCU on PCB with built-in LCD controller; runs timer firmware; COM/SEG to display glass, GPIO to buttons. */
		attribute clockFrequency : Real;
		attribute flashSize : Real;
		attribute ramSize : Real;
		port buttonIn : ~ButtonInputPort;
		port displayOut : DisplayCommandPort;
		port lcdDrive : LcdSegmentDrivePort;
		port buzzerOut : BuzzerCommandPort;
		port pwr : ~BatteryOutlet { :>> maxCurrent = 0.02 [A]; }  // ~20 mA typical
		exhibit state timerMode : TimerStateMachine;
	}

	part def BuzzerDriver {
		doc /* Transistor or FET; switches battery power to buzzer when MCU GPIO is high. */
		port ctrlIn : ~BuzzerCommandPort;
		port pwrIn : ~BatteryOutlet { :>> maxCurrent = 0.001 [A]; }  // driver circuit negligible
		port buzzerPwrOut : BatteryOutlet;
	}

	part def Display {
		doc /* Segment LCD glass; COM/SEG from MCU LCD controller; shows MM:SS. */
		attribute format : String;
		port cmd : ~DisplayCommandPort;
		port lcdIn : ~LcdSegmentDrivePort;
		port pwr : ~BatteryOutlet { :>> maxCurrent = 0.01 [A]; }  // ~10 mA typical
	}

	part def ButtonInterface {
		doc /* Captures user input; debounces buttons. */
		port output : ButtonInputPort;
		port pwr : ~BatteryOutlet { :>> maxCurrent = 0.001 [A]; }  // ~1 mA (polled)
	}

	part def Buzzer {
		doc /* Piezo or similar; has only +/- terminals; buzzes when power is applied. */
		attribute duration : TimeValue;
		port pwr : ~BatteryOutlet { :>> maxCurrent = 0.05 [A]; }  // ~50 mA when active
	}

	part def TimerPCB {
		doc /* PCB assembly; display and buttons mounted on board; MCU and buzzer driver. */
		part mcu : Microcontroller;
		part display : Display;
		part buttons : ButtonInterface;
		part buzzerDriver : BuzzerDriver;
		// Internal signal paths (power and external buzzer wired at KitchenTimer)
		connect buttons.output to mcu.buttonIn;
		connect mcu.displayOut to display.cmd;
		connect mcu.lcdDrive to display.lcdIn;
		connect mcu.buzzerOut to buzzerDriver.ctrlIn;
	}

	part def Battery {
		doc /* Power supply for all subsystems; e.g. 3xAAA. */
		attribute capacity : Real;
		attribute voltage : Real;
		attribute runtimeEstimate : TimeValue;
		port powerOut : BatteryOutlet;
	}

	// ========== Top-level system ==========
	part def KitchenTimer {
		doc /* Battery-powered kitchen timer; PCB with MCU, display, buttons, buzzer driver; buzzer off-board. */
		part pcb : TimerPCB;
		part battery : Battery;
		part buzzer : Buzzer;

		// Power: BatteryOutlet → ~BatteryOutlet (fan-out from battery to PCB loads)
		connect battery.powerOut to pcb.mcu.pwr;
		connect battery.powerOut to pcb.display.pwr;
		connect battery.powerOut to pcb.buttons.pwr;
		connect battery.powerOut to pcb.buzzerDriver.pwrIn;
		// Switched path: driver output → buzzer load
		connect pcb.buzzerDriver.buzzerPwrOut to buzzer.pwr;
	}

	// ========== State machine (README §5) ==========
	state def Idle {
		doc /* Timer not running; user can set time via +/-. */
	}

	state def Running {
		doc /* Countdown in progress. */
	}

	state def Paused {
		doc /* Countdown suspended; can resume or reset. */
	}

	state def Expired {
		doc /* Countdown reached zero; buzzer on. */
	}

	item def StartPressed;
	item def StopPressed;
	item def ResetPressed;
	item def IncrementPressed;
	item def DecrementPressed;
	item def CountdownComplete;

	state def TimerStateMachine {
		doc /* Top-level: Idle, Running, Paused, Expired. */
		entry;
		then idle;
		state idle : Idle;
		state running : Running;
		state paused : Paused;
		state expired : Expired;
		transition to_running first idle accept StartPressed then running;
		transition inc_dec_idle first idle accept IncrementPressed then idle;
		transition dec_dec_idle first idle accept DecrementPressed then idle;
		transition to_paused first running accept StopPressed then paused;
		transition to_expired first running accept CountdownComplete then expired;
		transition to_running_resume first paused accept StartPressed then running;
		transition to_idle_from_paused first paused accept ResetPressed then idle;
		transition to_idle_from_expired first expired accept ResetPressed then idle;
	}

	requirement def TimerRangeReq {
		subject timer : KitchenTimer;
		doc /* Support 1-99 minutes (or 0:01-99:59). */
		require constraint { doc /* minValue and maxValue define 1–99 min range. */ }
	}

	requirement def DisplayFormatReq {
		subject timer : KitchenTimer;
		doc /* Display remaining time in MM:SS format. */
		require constraint { doc /* Display format is MM:SS. */ }
	}

	requirement def AccuracyReq {
		subject mcu : Microcontroller;
		doc /* ±1 second per minute of elapsed time. */
		require constraint { doc /* Tick rate and accumulation meet accuracy. */ }
	}

	requirement def BuzzerAudibilityReq {
		subject timer : KitchenTimer;
		doc /* Alarm shall be audible in typical kitchen environment. */
		require constraint { doc /* Buzzer output meets audibility. */ }
	}

	requirement def ButtonResponsivenessReq {
		subject mcu : Microcontroller;
		doc /* Button presses acknowledged within 100 ms. */
		require constraint { doc /* Response time <= 100 ms. */ }
	}

	requirement def StateConsistencyReq {
		subject mcu : Microcontroller;
		doc /* No conflicting states (e.g., running and expired). */
		require constraint { doc /* State machine mutually exclusive states. */ }
	}

	requirement def BatteryRuntimeReq {
		subject battery : Battery;
		doc /* Minimum runtime (e.g., 100 hours typical use) on single charge. */
		require constraint { doc /* runtimeEstimate >= 100 hours. */ }
	}

	part timerInstance : KitchenTimer;
	satisfy TimerRangeReq by timerInstance;
	satisfy DisplayFormatReq by timerInstance;
	satisfy AccuracyReq by timerInstance.pcb.mcu;
	satisfy BuzzerAudibilityReq by timerInstance;
	satisfy ButtonResponsivenessReq by timerInstance.pcb.mcu;
	satisfy StateConsistencyReq by timerInstance.pcb.mcu;
	satisfy BatteryRuntimeReq by timerInstance.battery;

	// ========== Use cases (README §6) ==========
	item def User;

	use case def SetAndStartTimer {
		subject timer : KitchenTimer;
		actor user : User;
		doc /* User sets time via +/-, then presses Start; countdown begins. */
		objective { doc /* Start countdown with user-selected duration. */ }
	}

	use case def PauseResume {
		subject timer : KitchenTimer;
		actor user : User;
		doc /* User pauses via Stop, resumes via Start. */
		objective { doc /* Pause and resume countdown. */ }
	}

	use case def Reset {
		subject timer : KitchenTimer;
		actor user : User;
		doc /* User presses Reset to return to Idle and clear. */
		objective { doc /* Return to idle state and clear set value. */ }
	}

	use case def HearAlarm {
		subject timer : KitchenTimer;
		actor user : User;
		doc /* When countdown expires, buzzer sounds; user hears alarm. */
		objective { doc /* Audible alarm on expiration. */ }
	}

	use case def QuickStart {
		subject timer : KitchenTimer;
		actor user : User;
		doc /* User presses Start with preset (e.g., 5 min) without changing value. */
		objective { doc /* Start with preset duration. */ }
	}

	// ========== Optional: actions (placeholder) ==========
	action def UpdateDisplay {
		doc /* Command display to show current value. */
	}

	action def StartCountdown {
		doc /* Begin countdown from set value. */
	}

	action def SoundAlarm {
		doc /* Turn buzzer on. */
	}

	action def ClearDisplay {
		doc /* Clear or reset display. */
	}

	// ========== Optional: parametrics ==========
	constraint def TimerAccuracyConstraint {
		doc /* Accuracy bounded by tick rate and elapsed time. */
		in tickRate : TimeValue;
		in elapsedTime : TimeValue;
		in errorBound : Real;
		errorBound >= 0
	}

	constraint def BatteryRuntimeEstimate {
		doc /* Runtime = f(capacity, load current). */
		in capacity : Real;
		in loadCurrent : Real;
		in runtime : TimeValue;
		runtime >= capacity / loadCurrent
	}

}


