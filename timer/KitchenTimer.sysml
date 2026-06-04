/*
 * Kitchen Timer — aggregator: instance, requirement satisfaction, imports.
 */
package KitchenTimer {
	doc /* Root package for the kitchen timer teaching example. */

	import KitchenTimerPorts::*;
	import KitchenTimerStructure::*;
	import KitchenTimerBehavior::*;
	import KitchenTimerRequirements::*;

	part timerInstance : KitchenTimer;

	satisfy TimerRangeReq by timerInstance.pcb.mcu;
	satisfy DisplayFormatReq by timerInstance.pcb.display;
	satisfy AccuracyReq by timerInstance.pcb.mcu;
	satisfy BuzzerAudibilityReq by timerInstance.buzzer;
	satisfy ButtonResponsivenessReq by timerInstance.pcb.mcu;
	satisfy StateConsistencyReq by timerInstance.pcb.mcu;
	satisfy BatteryRuntimeReq by timerInstance.battery;
}
