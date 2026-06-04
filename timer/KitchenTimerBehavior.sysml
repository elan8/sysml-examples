package KitchenTimerBehavior {
	private import ScalarValues::*;

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
		transition increment_idle first idle accept IncrementPressed then idle;
		transition decrement_idle first idle accept DecrementPressed then idle;
		transition to_paused first running accept StopPressed then paused;
		transition to_expired first running accept CountdownComplete then expired;
		transition to_running_resume first paused accept StartPressed then running;
		transition to_idle_from_paused first paused accept ResetPressed then idle;
		transition to_idle_from_expired first expired accept ResetPressed then idle;
	}

}
