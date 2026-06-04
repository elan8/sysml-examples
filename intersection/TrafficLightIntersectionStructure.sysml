package TrafficLightIntersectionStructure {
	import TrafficLightIntersectionPorts::*;
	import TrafficLightIntersectionBehavior::*;

	private import ScalarValues::String;
	private import ISQBase::DurationValue;

	part def SignalHead {
		doc /* Display Red, Yellow, Green to road users. */
		attribute approachName : String;
		port cmd : ~LampCommandPort;
	}

	part def Detector {
		doc /* Vehicle presence or pedestrian demand. */
		attribute coverage : String;
		port output : DetectorOutputPort;
	}

	part def IntersectionController {
		doc /* Logic and timing; runs phase state machine. */
		attribute minGreen : DurationValue;
		attribute maxGreen : DurationValue;
		attribute yellowTime : DurationValue;
		attribute allRedTime : DurationValue;
		attribute cycleLength : DurationValue;
		port mainLampOut : LampCommandPort;
		port sideLampOut : LampCommandPort;
		port detectorIn : ~DetectorOutputPort;
		port operatorIn : ~OperatorCommandPort;
		exhibit state controllerMode : ControllerStateMachine;
	}

	part def OperatorPanel {
		doc /* Local cabinet or remote input for mode commands (e.g. Normal / Flash). */
		port commands : OperatorCommandPort;
	}

	part def TrafficLightIntersection {
		doc /* 4-way intersection with controller, signal heads, optional detector. */
		part controller : IntersectionController;
		part mainStreetSignals : SignalHead;
		part sideStreetSignals : SignalHead;
		part detector : Detector;
		part operatorPanel : OperatorPanel;

		connect controller.mainLampOut to mainStreetSignals.cmd;
		connect controller.sideLampOut to sideStreetSignals.cmd;
		connect detector.output to controller.detectorIn;
		connect operatorPanel.commands to controller.operatorIn;
	}

}
