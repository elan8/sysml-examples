package TrafficLightIntersectionBehavior {

	state def PhaseA {
		doc /* Main Street green; Side Street red. */
	}

	state def PhaseB {
		doc /* Main Street yellow; Side Street red. */
	}

	state def PhaseC {
		doc /* Side Street green; Main Street red. */
	}

	state def PhaseD {
		doc /* Side Street yellow; Main Street red. */
	}

	item def PhaseTimerElapsed;
	item def FlashCommand;
	item def NormalCommand;

	state def Normal {
		doc /* Running main cycle A -> B -> C -> D -> A. */
		entry;
		then phaseA;
		state phaseA : PhaseA;
		state phaseB : PhaseB;
		state phaseC : PhaseC;
		state phaseD : PhaseD;
		transition a_to_b first phaseA accept PhaseTimerElapsed then phaseB;
		transition b_to_c first phaseB accept PhaseTimerElapsed then phaseC;
		transition c_to_d first phaseC accept PhaseTimerElapsed then phaseD;
		transition d_to_a first phaseD accept PhaseTimerElapsed then phaseA;
	}

	state def Flash {
		doc /* All approaches flashing; no cycle. */
	}

	state def ControllerStateMachine {
		doc /* Top-level: Normal cycle or Flash mode. */
		entry;
		then normal;
		state normal : Normal;
		state flash : Flash;
		transition to_flash first normal accept FlashCommand then flash;
		transition to_normal first flash accept NormalCommand then normal;
	}

	action def SetMainGreen {
		doc /* Command Main Street to green. */
	}

	action def SetMainYellow {
		doc /* Command Main Street to yellow. */
	}

	action def SetSideGreen {
		doc /* Command Side Street to green. */
	}

	action def SetSideYellow {
		doc /* Command Side Street to yellow. */
	}

	action def SetAllFlash {
		doc /* Command all approaches to flash. */
	}

}
