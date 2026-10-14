package Views {
	private import StandardViewDefinitions::*;
	private import TrafficLightIntersection::*;
	private import TrafficLightIntersectionBehavior::*;

	view structure : GeneralView {
		doc /* Structure only: parts and ports on intersectionInstance. */
		expose TrafficLightIntersection::intersectionInstance;
		filter @SysML::PartUsage or @SysML::PartDefinition
			or @SysML::PortUsage or @SysML::PortDefinition;
	}

	view connections : InterconnectionView {
		expose TrafficLightIntersection::intersectionInstance;
	}

	view controllerStateMachine : StateTransitionView {
		doc /* Normal phase cycle and Flash mode. */
		expose TrafficLightIntersectionBehavior::ControllerStateMachine;
	}

}
