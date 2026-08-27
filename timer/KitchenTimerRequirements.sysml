package KitchenTimerRequirements {
	import KitchenTimerStructure::*;

	private import ScalarValues::*;
	private import ISQBase::DurationValue;
	private import ISQBase::ElectricCurrentValue;
	private import ISQElectromagnetism::ElectricChargeValue;

	requirement def TimerRangeReq {
		subject mcu : MCU;
		doc /* The controller shall support a configurable countdown range from 0:01 to 99:59. */
		require constraint { doc /* The configured countdown value stays within the supported timer range. */ }
	}

	requirement def DisplayFormatReq {
		subject display : Display;
		doc /* The display shall present the countdown value in MM:SS format. */
		require constraint { doc /* The visible timer presentation uses a two-field minutes-and-seconds display. */ }
	}

	requirement def AccuracyReq {
		subject mcu : MCU;
		doc /* The controller shall keep elapsed-time error within +/-1 second per minute. */
		require constraint { doc /* Tick handling and countdown accumulation stay within the stated timing tolerance. */ }
	}

	requirement def BuzzerAudibilityReq {
		subject buzzer : Buzzer;
		doc /* The buzzer shall provide an audible alarm for a typical kitchen environment. */
		require constraint { doc /* The buzzer output is intended to be noticeable when the timer expires. */ }
	}

	requirement def ButtonResponsivenessReq {
		subject mcu : MCU;
		doc /* The controller shall acknowledge button events within 100 ms. */
		require constraint { doc /* Input handling keeps button-to-response latency at or below 100 ms. */ }
	}

	requirement def StateConsistencyReq {
		subject mcu : MCU;
		doc /* The controller state machine shall remain in one mutually exclusive timer mode at a time. */
		require constraint { doc /* Idle, Running, Paused, and Expired remain mutually exclusive controller states. */ }
	}

	requirement def BatteryRuntimeReq {
		subject battery : Battery;
		doc /* The battery shall support a runtime estimate of at least 100 hours for typical use. */
		require constraint { doc /* The modeled runtime estimate meets or exceeds the target usage duration. */ }
	}

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

	constraint def TimerAccuracyConstraint {
		doc /* Illustrative parametric support for AccuracyReq. */
		in tickRate : DurationValue;
		in elapsedTime : DurationValue;
		in errorBound : Real;
		errorBound >= 0
	}

	constraint def BatteryRuntimeEstimate {
		doc /* Illustrative parametric support for BatteryRuntimeReq; charge / current gives duration. */
		in capacity : ElectricChargeValue;
		in loadCurrent : ElectricCurrentValue;
		in runtime : DurationValue;
		runtime >= capacity / loadCurrent
	}

}
