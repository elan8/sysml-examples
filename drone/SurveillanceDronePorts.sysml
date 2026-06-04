package SurveillanceDronePorts {
	private import ScalarValues::Real;
	private import ScalarValues::String;

	port def MotorCommandPort {
		in throttleCommand : Real;
	}

	port def GimbalCommandPort {
		in panAngle : Real;
		in tiltAngle : Real;
		in mode : String;
	}

	port def CameraControlPort {
		in recordCommand : String;
		in zoomCommand : Real;
		out videoStream : String;
	}

	port def TelemetryPort {
		out position : String;
		out attitude : String;
		out batteryStatus : String;
		out status : String;
	}

	port def PowerPort {
		out voltage : Real;
		out current : Real;
	}

	port def SensorDataPort {
		out position : String;
		out velocity : String;
		out attitude : String;
		out altitude : Real;
	}

	port def RCCommandPort {
		in rcCommands : String;
		in modeChanges : String;
	}

}
