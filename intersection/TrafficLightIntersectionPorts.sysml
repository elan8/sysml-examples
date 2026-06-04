package TrafficLightIntersectionPorts {
	private import ScalarValues::String;
	private import ScalarValues::Boolean;

	port def LampCommandPort {
		out indication : String;
	}

	port def DetectorOutputPort {
		out vehiclePresent : Boolean;
		out pedestrianCall : Boolean;
	}

	port def OperatorCommandPort {
		in modeCommand : String;
	}

}
