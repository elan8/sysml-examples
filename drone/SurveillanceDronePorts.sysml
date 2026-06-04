package SurveillanceDronePorts {
	private import ScalarValues::Real;
	private import ScalarValues::String;
	private import ISQBase::LengthValue;
	private import ISQElectromagnetism::electricPower;
	private import ISQSpaceTime::AngularMeasureValue;
	private import SI::volt;
	private import SI::ampere;

	port def MotorCommandPort {
		doc /* Normalized throttle setpoint (dimensionless 0..1), not a physical quantity. */
		in throttleCommand : Real;
	}

	port def GimbalCommandPort {
		in panAngle : AngularMeasureValue;
		in tiltAngle : AngularMeasureValue;
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
		out power : electricPower;
		attribute voltage = 12.0 [V];
		attribute maxCurrent = 1.0 [A];
	}

	port def SensorDataPort {
		out position : String;
		out velocity : String;
		out attitude : String;
		out altitude : LengthValue;
	}

	port def RCCommandPort {
		in rcCommands : String;
		in modeChanges : String;
	}

}
