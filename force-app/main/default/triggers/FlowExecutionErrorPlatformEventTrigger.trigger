trigger FlowExecutionErrorPlatformEventTrigger on FlowExecutionErrorEvent (after insert)
{
	FlowExecutionEventTriggerHandler.afterInsert(Trigger.new);
}