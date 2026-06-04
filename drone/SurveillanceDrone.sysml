/*
 * Surveillance Quadrotor Drone — aggregator: instance, requirement satisfaction, imports.
 */
package SurveillanceDrone {
	doc /* Root package for a broad surveillance-drone teaching example. */

	import SurveillanceDronePorts::*;
	import SurveillanceDroneStructure::*;
	import SurveillanceDroneBehavior::*;
	import SurveillanceDroneRequirements::*;

	part droneInstance : SurveillanceQuadrotorDrone;

	satisfy EnduranceReq by droneInstance;
	satisfy MaxAltitudeAGLReq by droneInstance;
	satisfy WindToleranceReq by droneInstance;
	satisfy VideoLatencyReq by droneInstance.communication;
	satisfy FailsafeReq by droneInstance.flightControl.flightController;
	satisfy GeofencingReq by droneInstance.flightControl;
	satisfy RemoteIDReq by droneInstance;
	satisfy GimbalPanTiltReq by droneInstance.gimbal;
	satisfy ControlModesReq by droneInstance.flightControl.flightController;
	satisfy OperatingTempReq by droneInstance;
}
