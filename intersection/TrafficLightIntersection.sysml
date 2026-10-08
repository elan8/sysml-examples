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

	satisfy requirement : NoConflictingGreensReq by intersectionInstance;
	satisfy requirement : ClearanceTimeReq by intersectionInstance;
	satisfy requirement : FailSafeReq by intersectionInstance;
	satisfy requirement : PhaseSequenceReq by intersectionInstance.controller;
	satisfy requirement : ModesReq by intersectionInstance.controller;
	satisfy requirement : VisibilityReq by intersectionInstance;
}
