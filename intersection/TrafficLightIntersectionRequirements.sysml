package TrafficLightIntersectionRequirements {
	import TrafficLightIntersectionStructure::*;

	private import ISQBase::DurationValue;
	private import ISQBase::LengthValue;
	private import ISQSpaceTime::SpeedValue;

	requirement def NoConflictingGreensReq {
		subject intersection : TrafficLightIntersection;
		doc /* No two conflicting movements shall have green simultaneously. */
		require constraint { doc /* Only one approach group has green at a time. */ }
	}

	requirement def ClearanceTimeReq {
		subject intersection : TrafficLightIntersection;
		doc /* Yellow and all-red shall be long enough for clearance per approach speed. */
		require constraint { doc /* yellowTime and allRedTime meet clearance requirements. */ }
	}

	requirement def FailSafeReq {
		subject intersection : TrafficLightIntersection;
		doc /* On fault or loss of controller, transition to flash or safe state. */
		require constraint { doc /* Fault triggers transition to Flash. */ }
	}

	requirement def PhaseSequenceReq {
		subject controller : IntersectionController;
		doc /* Controller shall run defined phase sequence A -> B -> C -> D. */
		require constraint { doc /* Cycle runs PhaseA, PhaseB, PhaseC, PhaseD in order. */ }
	}

	requirement def ModesReq {
		subject controller : IntersectionController;
		doc /* Support at least Normal and Flash modes. */
		require constraint { doc /* Normal and Flash modes supported. */ }
	}

	requirement def VisibilityReq {
		subject intersection : TrafficLightIntersection;
		doc /* Signal indications shall meet standard visibility. */
		require constraint { doc /* Luminance and position per standards. */ }
	}

	item def Operator;
	item def RoadUser;

	use case def NormalOperation {
		subject intersection : TrafficLightIntersection;
		actor driver : RoadUser;
		doc /* Controller runs phase sequence; vehicles and pedestrians obey signals. */
		objective { doc /* Safe, predictable right-of-way assignment. */ }
	}

	use case def SwitchToFlash {
		subject intersection : TrafficLightIntersection;
		actor operator : Operator;
		doc /* Operator or fault triggers flash mode. */
		objective { doc /* All approaches flash for maintenance or failure. */ }
	}

	use case def ReturnToNormal {
		subject intersection : TrafficLightIntersection;
		actor operator : Operator;
		doc /* Flash ends; controller resumes normal cycle. */
		objective { doc /* Resume phase sequence from defined phase. */ }
	}

	use case def ActuatedGreen {
		subject intersection : TrafficLightIntersection;
		actor driver : RoadUser;
		doc /* Green extends on vehicle demand until max green or gap-out. */
		objective { doc /* Responsive green based on detection. */ }
	}

	use case def PedestrianCrossing {
		subject intersection : TrafficLightIntersection;
		actor pedestrian : RoadUser;
		doc /* Button press registers; walk phase served in cycle. */
		objective { doc /* Adequate walk and clearance time. */ }
	}

	constraint def ClearanceTimeConstraint {
		doc /* Yellow time >= f(speed, distance) for clearance. */
		in approachSpeed : SpeedValue;
		in clearanceDistance : LengthValue;
		in yellowTime : DurationValue;
		yellowTime >= clearanceDistance / approachSpeed
	}

}
