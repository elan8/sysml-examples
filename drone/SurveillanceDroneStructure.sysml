package SurveillanceDroneStructure {
	import SurveillanceDronePorts::*;
	import SurveillanceDroneBehavior::*;

	private import ScalarValues::Real;
	private import ScalarValues::String;
	private import ISQBase::MassValue;
	private import ISQBase::LengthValue;
	private import ISQBase::DurationValue;
	private import ISQBase::ElectricCurrentValue;
	private import ISQElectromagnetism::ElectricChargeValue;
	private import ISQElectromagnetism::ElectricPotentialDifferenceValue;
	private import ISQMechanics::ForceValue;
	private import ISQSpaceTime::FrequencyValue;
	private import ISQSpaceTime::AngularMeasureValue;
	private import ISQSpaceTime::AngularVelocityValue;

	part def Airframe {
		doc /* Structural support, attachment points, quad-X or H layout. */
		attribute wheelbase : LengthValue;
		attribute weight : MassValue;
		attribute maxPayloadCapacity : MassValue;
		attribute foldableArms : String;
		attribute ipRating : String;
	}

	part def PropulsionUnit {
		doc /* One motor + ESC + propeller; BLDC outrunner, PWM/DShot input. */
		attribute thrust : ForceValue;
		attribute hoverThrottle : Real;
		attribute maxCurrent : ElectricCurrentValue;
		port cmd : MotorCommandPort;
		port pwr : ~PowerPort { :>> maxCurrent = 30 [A]; }
	}

	part def Propulsion {
		doc /* Four propulsion units for quadrotor lift and thrust. */
		part propulsionUnit1 : PropulsionUnit;
		part propulsionUnit2 : PropulsionUnit;
		part propulsionUnit3 : PropulsionUnit;
		part propulsionUnit4 : PropulsionUnit;
		attribute thrustTotal : ForceValue;
	}

	part def FlightController {
		doc /* Main processor: attitude/rate control, mixing, flight modes. */
		attribute updateRate : FrequencyValue;
		attribute supportedModes : String;
		port motorCmd : ~MotorCommandPort;
		port gimbalCmd : ~GimbalCommandPort;
		port telemetryOut : TelemetryPort;
		port rcIn : ~RCCommandPort;
		port sensorIn : ~SensorDataPort;
		port pwr : ~PowerPort { :>> maxCurrent = 0.5 [A]; }
		exhibit state flightMode : FlightModeStateMachine;
	}

	part def IMU {
		attribute sampleRate : FrequencyValue;
		port dataOut : SensorDataPort;
		port pwr : ~PowerPort { :>> maxCurrent = 0.01 [A]; }
	}

	part def Barometer {
		port altitudeOut : SensorDataPort;
		port pwr : ~PowerPort { :>> maxCurrent = 0.001 [A]; }
	}

	part def GNSSReceiver {
		port positionOut : SensorDataPort;
		port pwr : ~PowerPort { :>> maxCurrent = 0.05 [A]; }
	}

	part def FlightControlAndSensing {
		doc /* FC + IMU, baro, GNSS for stabilization and navigation. */
		part flightController : FlightController;
		part imu : IMU;
		part barometer : Barometer;
		part gnss : GNSSReceiver;
		connect imu.dataOut to flightController.sensorIn;
		connect barometer.altitudeOut to flightController.sensorIn;
		connect gnss.positionOut to flightController.sensorIn;
		attribute geofenceBehavior : String;
		attribute failsafeLogic : String;
	}

	part def Gimbal {
		doc /* Mechanically stabilized platform; pan/tilt, optionally roll. */
		attribute panRange : AngularMeasureValue;
		attribute tiltRange : AngularMeasureValue;
		attribute maxAngularRate : AngularVelocityValue;
		attribute payloadCapacity : MassValue;
		port cmd : GimbalCommandPort;
		port cameraCtrl : CameraControlPort;
		port pwr : ~PowerPort { :>> maxCurrent = 0.5 [A]; }
	}

	part def CameraPayload {
		doc /*
		 * Visible and/or thermal camera; video and stills.
		 * frameRate, fov, and zoomRange are dimensionless sketches, not optical quantities.
		 */
		attribute resolution : String;
		attribute frameRate : Real;
		attribute fov : Real;
		attribute zoomRange : Real;
		port videoOut : TelemetryPort;
		port control : ~CameraControlPort;
		port pwr : ~PowerPort { :>> maxCurrent = 0.3 [A]; }
	}

	part def Communication {
		doc /* C2 link, telemetry, video downlink. */
		attribute range : LengthValue;
		attribute latency : DurationValue;
		attribute bandwidth : Real;
		port c2In : RCCommandPort;
		port telemetryIn : ~TelemetryPort;
		port videoIn : ~TelemetryPort;
		port pwr : ~PowerPort { :>> maxCurrent = 0.2 [A]; }
	}

	part def Battery {
		attribute nominalVoltage : ElectricPotentialDifferenceValue;
		attribute capacity : ElectricChargeValue;
		attribute maxDischargeRate : ElectricCurrentValue;
		attribute weight : MassValue;
		port pwrOut : PowerPort;
	}

	part def PowerDistribution {
		port mainPower : ~PowerPort;
		port regulated5V : PowerPort;
		port regulated12V : PowerPort;
	}

	part def Power {
		doc /* Battery + distribution; supplies all onboard systems. */
		part battery : Battery;
		part distribution : PowerDistribution;
		attribute flightTimeNominal : DurationValue;
	}

	part def SurveillanceQuadrotorDrone {
		doc /* Surveillance quadrotor UAV with gimbal-mounted cameras. */
		part airframe : Airframe;
		part propulsion : Propulsion;
		part flightControl : FlightControlAndSensing;
		part gimbal : Gimbal;
		part cameraPayload : CameraPayload;
		part communication : Communication;
		part power : Power;

		connect flightControl.flightController.motorCmd to propulsion.propulsionUnit1.cmd;
		connect flightControl.flightController.motorCmd to propulsion.propulsionUnit2.cmd;
		connect flightControl.flightController.motorCmd to propulsion.propulsionUnit3.cmd;
		connect flightControl.flightController.motorCmd to propulsion.propulsionUnit4.cmd;
		connect flightControl.flightController.gimbalCmd to gimbal.cmd;
		connect gimbal.cameraCtrl to cameraPayload.control;
		connect cameraPayload.videoOut to communication.videoIn;
		connect flightControl.flightController.telemetryOut to communication.telemetryIn;
		connect communication.c2In to flightControl.flightController.rcIn;
		connect power.battery.pwrOut to power.distribution.mainPower;
		connect power.distribution.regulated5V to flightControl.flightController.pwr;
		connect power.distribution.regulated5V to flightControl.imu.pwr;
		connect power.distribution.regulated5V to flightControl.barometer.pwr;
		connect power.distribution.regulated5V to flightControl.gnss.pwr;
		connect power.distribution.regulated5V to gimbal.pwr;
		connect power.distribution.regulated5V to cameraPayload.pwr;
		connect power.distribution.regulated5V to communication.pwr;
		connect power.distribution.regulated12V to propulsion.propulsionUnit1.pwr;
		connect power.distribution.regulated12V to propulsion.propulsionUnit2.pwr;
		connect power.distribution.regulated12V to propulsion.propulsionUnit3.pwr;
		connect power.distribution.regulated12V to propulsion.propulsionUnit4.pwr;
	}

}
