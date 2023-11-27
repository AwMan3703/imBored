package utility;

// Finite-State Machine, used to switch between functions to be called on update like FlxSprite's update()
class FSM
{
	public var activeState:Float->Void;

	public function new(initialState:Float->Void)
	{
		activeState = initialState;
	}

	public function setState(newState:Float->Void)
	{
		activeState = newState;
	}

	public function update(elapsed:Float)
	{
		activeState(elapsed);
	}
}
