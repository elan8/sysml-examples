/*
 * Traffic Light Intersection — aggregator: instance, requirement satisfaction, imports.
 */
package TrafficLightIntersection {
	doc /* Root package for a compact traffic-light-controller teaching example. */

	import TrafficLightIntersectionPorts::*;
	import TrafficLightIntersectionStructure::*;
	import TrafficLightIntersectionBehavior::*;
	import TrafficLightIntersectionRequirements::*;

	part intersectionInstance : TrafficLightIntersection;

	satisfy NoConflictingGreensReq by intersectionInstance;
	satisfy ClearanceTimeReq by intersectionInstance;
	satisfy FailSafeReq by intersectionInstance;
	satisfy PhaseSequenceReq by intersectionInstance.controller;
	satisfy ModesReq by intersectionInstance.controller;
	satisfy VisibilityReq by intersectionInstance;
}
