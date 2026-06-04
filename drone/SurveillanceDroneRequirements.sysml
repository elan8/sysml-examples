package SurveillanceDroneRequirements {
	import SurveillanceDroneStructure::*;

	private import ScalarValues::Real;
	private import ISQBase::DurationValue;
	private import ISQBase::MassValue;
	private import ISQBase::ElectricCurrentValue;
	private import ISQElectromagnetism::ElectricChargeValue;
	private import ISQMechanics::ForceValue;

	requirement def EnduranceReq {
		subject drone : SurveillanceQuadrotorDrone;
		doc /* Minimum flight time at nominal hover with standard payload. */
		require constraint { doc /* flightTime >= 25 min. */ }
	}

	requirement def MaxAltitudeAGLReq {
		subject drone : SurveillanceQuadrotorDrone;
		doc /* Max altitude AGL per regulation and mission (e.g. 120 m). */
		require constraint { doc /* altitudeAGL <= 120 m. */ }
	}

	requirement def WindToleranceReq {
		subject drone : SurveillanceQuadrotorDrone;
		doc /* Operate in winds up to specified speed (e.g. 10 m/s). */
		require constraint { doc /* windSpeed <= 10 m/s. */ }
	}

	requirement def VideoLatencyReq {
		subject communication : Communication;
		doc /* Video end-to-end latency < 300 ms. */
		require constraint { doc /* videoLatency < 300 ms. */ }
	}

	requirement def FailsafeReq {
		subject controller : FlightController;
		doc /* RTL or land on C2 loss, low battery, critical sensor failure. */
		require constraint { doc /* On C2 loss or low battery or critical sensor failure: execute RTL or land. */ }
	}

	requirement def GeofencingReq {
		subject flightControl : FlightControlAndSensing;
		doc /* Respect no-fly zones and altitude limits. */
		require constraint { doc /* Respect geofence and altitude limits. */ }
	}

	requirement def RemoteIDReq {
		subject drone : SurveillanceQuadrotorDrone;
		doc /* Remote ID or equivalent where required. */
		require constraint { doc /* Provide Remote ID where required. */ }
	}

	requirement def GimbalPanTiltReq {
		subject gimbal : Gimbal;
		doc /* 360 deg pan or sufficient range; tilt e.g. -90 deg to +30 deg. */
		require constraint { doc /* panRange >= 360; tiltRange covers -90 to +30. */ }
	}

	requirement def ControlModesReq {
		subject controller : FlightController;
		doc /* Manual, attitude, GPS hold, waypoint, orbit, RTL, optionally follow. */
		require constraint { doc /* Support manual, attitude, GPS hold, waypoint, orbit, RTL, follow. */ }
	}

	requirement def OperatingTempReq {
		subject drone : SurveillanceQuadrotorDrone;
		doc /* Operating temperature e.g. -10 degC to +45 degC. */
		require constraint { doc /* Operate in -10 degC to +45 degC. */ }
	}

	item def Operator;

	use case def PatrolOverwatch {
		subject drone : SurveillanceQuadrotorDrone;
		actor pilot : Operator;
		doc /* Predefined or manual route; continuous video to GCS. */
		objective { doc /* Provide continuous video of route to GCS. */ }
	}

	use case def PointOfInterestOrbit {
		subject drone : SurveillanceQuadrotorDrone;
		actor pilot : Operator;
		doc /* Circle fixed point with camera on center; adjustable radius and altitude. */
		objective { doc /* Maintain orbit around POI with camera on target. */ }
	}

	use case def FollowTarget {
		subject drone : SurveillanceQuadrotorDrone;
		actor pilot : Operator;
		doc /* Track moving object with gimbal while maintaining safe flight. */
		objective { doc /* Keep target in frame while flying safely. */ }
	}

	use case def Inspection {
		subject drone : SurveillanceQuadrotorDrone;
		actor pilot : Operator;
		doc /* Structured path (e.g. grid) for infrastructure/area inspection. */
		objective { doc /* Capture high-resolution stills and video for inspection. */ }
	}

	use case def Search {
		subject drone : SurveillanceQuadrotorDrone;
		actor pilot : Operator;
		doc /* Area search with thermal camera; loiter and zoom as needed. */
		objective { doc /* Locate targets using thermal and visible imagery. */ }
	}

	use case def ReturnToLaunchLanding {
		subject drone : SurveillanceQuadrotorDrone;
		actor pilot : Operator;
		doc /* Automated or assisted return and landing with payload secured. */
		objective { doc /* Return to launch point and land safely. */ }
	}

	constraint def TotalThrustMargin {
		doc /* Illustrative: thrust (force) vs weight force with dimensionless margin. */
		in totalThrust : ForceValue;
		in weightForce : ForceValue;
		in margin : Real;
		totalThrust >= weightForce * margin
	}

	calc def FlightTimeEstimate {
		doc /* Flight time from charge and current draw. */
		in capacity : ElectricChargeValue;
		in currentDraw : ElectricCurrentValue;
		return flightTime : DurationValue;
		capacity / currentDraw
	}

}
