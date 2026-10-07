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

	satisfy requirement : TimerRangeReq by timerInstance.pcb.mcu;
	satisfy requirement : DisplayFormatReq by timerInstance.pcb.display;
	satisfy requirement : AccuracyReq by timerInstance.pcb.mcu;
	satisfy requirement : BuzzerAudibilityReq by timerInstance.buzzer;
	satisfy requirement : ButtonResponsivenessReq by timerInstance.pcb.mcu;
	satisfy requirement : StateConsistencyReq by timerInstance.pcb.mcu;
	satisfy requirement : BatteryRuntimeReq by timerInstance.battery;
}
