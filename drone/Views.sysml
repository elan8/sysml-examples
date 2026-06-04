package Views {
	import SurveillanceDrone::*;
	import SurveillanceDroneBehavior::*;

	view structure : GeneralView {
		doc /* Structure only: parts and ports on droneInstance. */
		expose SurveillanceDrone::droneInstance;
		filter @SysML::PartUsage or @SysML::PartDefinition
			or @SysML::PortUsage or @SysML::PortDefinition;
	}

	view connections : InterconnectionView {
		expose SurveillanceDrone::droneInstance;
	}

	view flightModeStateMachine : StateTransitionView {
		doc /* Flight modes, operator selection, and failsafe transitions. */
		expose SurveillanceDroneBehavior::FlightModeStateMachine;
	}

}
