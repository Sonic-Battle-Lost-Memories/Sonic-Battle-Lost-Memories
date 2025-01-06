#base class for state machine states
#(right now only used as a "tag" to identify state machine states)
class_name StateMachineState
extends Node

var state_enabled: bool = true

func enable_state():
	state_enabled = true
func disable_state():
	state_enabled = false
func toggle_state():
	state_enabled = not state_enabled
