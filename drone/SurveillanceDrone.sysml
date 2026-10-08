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

	satisfy requirement : EnduranceReq by droneInstance;
	satisfy requirement : MaxAltitudeAGLReq by droneInstance;
	satisfy requirement : WindToleranceReq by droneInstance;
	satisfy requirement : VideoLatencyReq by droneInstance.communication;
	satisfy requirement : FailsafeReq by droneInstance.flightControl.flightController;
	satisfy requirement : GeofencingReq by droneInstance.flightControl;
	satisfy requirement : RemoteIDReq by droneInstance;
	satisfy requirement : GimbalPanTiltReq by droneInstance.gimbal;
	satisfy requirement : ControlModesReq by droneInstance.flightControl.flightController;
	satisfy requirement : OperatingTempReq by droneInstance;
}
