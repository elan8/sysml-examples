package SurveillanceDroneBehavior {
	private import ScalarValues::Real;
	private import ScalarValues::String;
	private import ScalarValues::Boolean;

	action def ExecutePatrol {
		in route : String;
		out status : String;
		doc /* High-level patrol mission action for route-based surveillance. */
		action validateRoute { out routeReady : Boolean; }
		action armForMission { out armed : Boolean; }
		action takeOff { out airborne : Boolean; }
		action flyPatrolRoute { out routeComplete : Boolean; }
		action captureSurveyPass { out imageryCaptured : Boolean; }
		action reportMissionStatus { out missionStatus : String; }
		first validateRoute then armForMission;
		first armForMission then takeOff;
		first takeOff then flyPatrolRoute;
		first flyPatrolRoute then captureSurveyPass;
		first captureSurveyPass then reportMissionStatus;
	}

	action def ExecuteOrbit {
		in center : String;
		in radius : Real;
		in altitude : Real;
		out status : String;
		doc /* High-level orbit mission action around a point of interest. */
		action validateOrbitPoint { out orbitValid : Boolean; }
		action climbToOrbitAltitude { out altitudeReached : Boolean; }
		action enterOrbitPattern { out orbitEstablished : Boolean; }
		action stabilizeOrbitTrack { out orbitStable : Boolean; }
		action reportOrbitStatus { out orbitStatus : String; }
		first validateOrbitPoint then climbToOrbitAltitude;
		first climbToOrbitAltitude then enterOrbitPattern;
		first enterOrbitPattern then stabilizeOrbitTrack;
		first stabilizeOrbitTrack then reportOrbitStatus;
	}

	action def ControlGimbal {
		in panAngle : Real;
		in tiltAngle : Real;
		in mode : String;
		doc /* High-level command for gimbal pointing and mode selection. */
		action interpretModeCommand { out commandReady : Boolean; }
		action slewPanAxis { out panSettled : Boolean; }
		action slewTiltAxis { out tiltSettled : Boolean; }
		action stabilizeLineOfSight { out sightStable : Boolean; }
		action confirmGimbalAim { out aimConfirmed : Boolean; }
		first interpretModeCommand then slewPanAxis;
		first slewPanAxis then slewTiltAxis;
		first slewTiltAxis then stabilizeLineOfSight;
		first stabilizeLineOfSight then confirmGimbalAim;
	}

	action def CaptureVideo {
		out videoStream : String;
		doc /* High-level action for producing a surveillance video stream. */
		action powerImager { out imagerPowered : Boolean; }
		action configureEncoder { out encoderReady : Boolean; }
		action startCapture { out captureStarted : Boolean; }
		action streamVideoFrames { out encodedFrames : String; }
		action publishVideoStream { out streamPublished : String; }
		first powerImager then configureEncoder;
		first configureEncoder then startCapture;
		first startCapture then streamVideoFrames;
		first streamVideoFrames then publishVideoStream;
	}

	state def Manual {
		doc /* Direct pilot control with minimal stabilization assumptions. */
	}

	state def AttitudeHold {
		doc /* Stabilized flight while pilot commands attitude and thrust. */
	}

	state def GPSHold {
		doc /* Position-hold mode using GNSS and attitude stabilization. */
	}

	state def Waypoint {
		doc /* Autonomous waypoint-following mission mode. */
	}

	state def Orbit {
		doc /* Automated orbit around a point of interest. */
	}

	state def Follow {
		doc /* Tracking mode for a moving subject or designated target. */
	}

	state def RTL {
		doc /* Return-to-launch recovery mode. */
	}

	state def Landing {
		doc /* Final descent and touchdown sequence. */
	}

	item def ManualSelected;
	item def AttitudeHoldSelected;
	item def GPSHoldSelected;
	item def WaypointSelected;
	item def OrbitSelected;
	item def FollowSelected;
	item def RTLCommanded;
	item def LandingCommanded;
	item def DisarmCommanded;
	item def C2LinkLost;
	item def LowBattery;
	item def CriticalSensorFailure;
	item def Recovered;

	state def FlightModeStateMachine {
		doc /* Flight-controller mode set with operator and failsafe transitions. */
		state manual : Manual;
		state attitudeHold : AttitudeHold;
		state gpsHold : GPSHold;
		state waypoint : Waypoint;
		state orbit : Orbit;
		state follow : Follow;
		state rtl : RTL;
		state landing : Landing;

		entry;
		then manual;

		transition to_attitude_from_manual first manual accept AttitudeHoldSelected then attitudeHold;
		transition to_gpshold_from_manual first manual accept GPSHoldSelected then gpsHold;
		transition to_waypoint_from_manual first manual accept WaypointSelected then waypoint;
		transition to_orbit_from_manual first manual accept OrbitSelected then orbit;
		transition to_follow_from_manual first manual accept FollowSelected then follow;
		transition to_rtl_from_manual first manual accept RTLCommanded then rtl;
		transition to_landing_from_manual first manual accept LandingCommanded then landing;

		transition to_manual_from_attitude first attitudeHold accept ManualSelected then manual;
		transition to_gpshold_from_attitude first attitudeHold accept GPSHoldSelected then gpsHold;
		transition to_waypoint_from_attitude first attitudeHold accept WaypointSelected then waypoint;
		transition to_orbit_from_attitude first attitudeHold accept OrbitSelected then orbit;
		transition to_follow_from_attitude first attitudeHold accept FollowSelected then follow;
		transition to_rtl_from_attitude first attitudeHold accept RTLCommanded then rtl;
		transition to_landing_from_attitude first attitudeHold accept LandingCommanded then landing;

		transition to_manual_from_gpshold first gpsHold accept ManualSelected then manual;
		transition to_attitude_from_gpshold first gpsHold accept AttitudeHoldSelected then attitudeHold;
		transition to_waypoint_from_gpshold first gpsHold accept WaypointSelected then waypoint;
		transition to_orbit_from_gpshold first gpsHold accept OrbitSelected then orbit;
		transition to_follow_from_gpshold first gpsHold accept FollowSelected then follow;
		transition to_rtl_from_gpshold first gpsHold accept RTLCommanded then rtl;
		transition to_landing_from_gpshold first gpsHold accept LandingCommanded then landing;

		transition to_manual_from_waypoint first waypoint accept ManualSelected then manual;
		transition to_attitude_from_waypoint first waypoint accept AttitudeHoldSelected then attitudeHold;
		transition to_gpshold_from_waypoint first waypoint accept GPSHoldSelected then gpsHold;
		transition to_orbit_from_waypoint first waypoint accept OrbitSelected then orbit;
		transition to_follow_from_waypoint first waypoint accept FollowSelected then follow;
		transition to_rtl_from_waypoint first waypoint accept RTLCommanded then rtl;
		transition to_landing_from_waypoint first waypoint accept LandingCommanded then landing;

		transition to_manual_from_orbit first orbit accept ManualSelected then manual;
		transition to_attitude_from_orbit first orbit accept AttitudeHoldSelected then attitudeHold;
		transition to_gpshold_from_orbit first orbit accept GPSHoldSelected then gpsHold;
		transition to_waypoint_from_orbit first orbit accept WaypointSelected then waypoint;
		transition to_follow_from_orbit first orbit accept FollowSelected then follow;
		transition to_rtl_from_orbit first orbit accept RTLCommanded then rtl;
		transition to_landing_from_orbit first orbit accept LandingCommanded then landing;

		transition to_manual_from_follow first follow accept ManualSelected then manual;
		transition to_attitude_from_follow first follow accept AttitudeHoldSelected then attitudeHold;
		transition to_gpshold_from_follow first follow accept GPSHoldSelected then gpsHold;
		transition to_waypoint_from_follow first follow accept WaypointSelected then waypoint;
		transition to_orbit_from_follow first follow accept OrbitSelected then orbit;
		transition to_rtl_from_follow first follow accept RTLCommanded then rtl;
		transition to_landing_from_follow first follow accept LandingCommanded then landing;

		transition failsafe_rtl_c2loss first manual accept C2LinkLost then rtl;
		transition failsafe_rtl_c2loss_ah first attitudeHold accept C2LinkLost then rtl;
		transition failsafe_rtl_c2loss_gps first gpsHold accept C2LinkLost then rtl;
		transition failsafe_rtl_c2loss_wp first waypoint accept C2LinkLost then rtl;
		transition failsafe_rtl_c2loss_orbit first orbit accept C2LinkLost then rtl;
		transition failsafe_rtl_c2loss_follow first follow accept C2LinkLost then rtl;

		transition failsafe_rtl_lowbat first manual accept LowBattery then rtl;
		transition failsafe_rtl_lowbat_ah first attitudeHold accept LowBattery then rtl;
		transition failsafe_rtl_lowbat_gps first gpsHold accept LowBattery then rtl;
		transition failsafe_rtl_lowbat_wp first waypoint accept LowBattery then rtl;
		transition failsafe_rtl_lowbat_orbit first orbit accept LowBattery then rtl;
		transition failsafe_rtl_lowbat_follow first follow accept LowBattery then rtl;

		transition failsafe_rtl_sensor first manual accept CriticalSensorFailure then rtl;
		transition failsafe_rtl_sensor_ah first attitudeHold accept CriticalSensorFailure then rtl;
		transition failsafe_rtl_sensor_gps first gpsHold accept CriticalSensorFailure then rtl;
		transition failsafe_rtl_sensor_wp first waypoint accept CriticalSensorFailure then rtl;
		transition failsafe_rtl_sensor_orbit first orbit accept CriticalSensorFailure then rtl;
		transition failsafe_rtl_sensor_follow first follow accept CriticalSensorFailure then rtl;

		transition rtl_to_landing first rtl accept LandingCommanded then landing;
		transition rtl_recover_to_gpshold first rtl accept Recovered then gpsHold;
		transition landing_to_manual_disarm first landing accept DisarmCommanded then manual;
	}

}
