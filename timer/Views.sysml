package Views {
	import KitchenTimer::*;
	import KitchenTimerBehavior::*;

	view structure : GeneralView {
		doc /*
		 * Structure only: parts and ports on timerInstance.
		 * Filters follow SysML 7.26 (filter @SysML::Kind); Spec42 evaluates them on expose.
		 */
		expose KitchenTimer::timerInstance;
		filter @SysML::PartUsage or @SysML::PartDefinition
			or @SysML::PortUsage or @SysML::PortDefinition;
	}

	view connections : InterconnectionView {
		expose KitchenTimer::timerInstance;
	}

	view timerStateMachine : StateTransitionView {
		doc /* Timer modes: Idle, Running, Paused, Expired and transitions. */
		expose KitchenTimerBehavior::TimerStateMachine;
	}

}
