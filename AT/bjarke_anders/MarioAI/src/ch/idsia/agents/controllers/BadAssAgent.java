
package ch.idsia.agents.controllers;

import ch.idsia.agents.Agent;
import ch.idsia.benchmark.mario.engine.sprites.Mario;
import ch.idsia.benchmark.mario.environments.Environment;

public class BadAssAgent extends BasicMarioAIAgent implements Agent {
	int trueJumpCounter = 0;
	int trueSpeedCounter = 0;
	
	public BadAssAgent() {
	    super("BadAssAgent");
	    reset();
	}
	
	public void reset() {
	    action = new boolean[Environment.numberOfKeys];
	    action[Mario.KEY_RIGHT] = true;
	    trueJumpCounter = 0;
	    trueSpeedCounter = 0;
	}
	
	
	public boolean[] getAction() {
		action[Mario.KEY_SPEED] = false;
		
		// this Agent requires observation integrated in advance.
		
	    if (DangerOfAny() && getReceptiveFieldCellValue(marioEgoRow, marioEgoCol + 1) != 1)  {
	        if (isMarioAbleToJump || (!isMarioOnGround && action[Mario.KEY_JUMP])) {
	        	action[Mario.KEY_SPEED] = action[Mario.KEY_JUMP] = true;
	        }
	        ++trueJumpCounter;
	    }
	    else {
	        action[Mario.KEY_JUMP] = false;
	        trueJumpCounter = 0;
	    }
	
	    if (trueJumpCounter > 16) {
	        trueJumpCounter = 0;
	        action[Mario.KEY_JUMP] = false;
	    }
	    
	    return action;
	}
	
	private boolean DangerOfAny() {
		if ((getReceptiveFieldCellValue(marioEgoRow + 2, marioEgoCol + 1) == 0 && getReceptiveFieldCellValue(marioEgoRow + 1, marioEgoCol + 1) == 0) ||
            getReceptiveFieldCellValue(marioEgoRow, marioEgoCol + 1) != 0 ||
            getReceptiveFieldCellValue(marioEgoRow, marioEgoCol + 2) != 0 ||
            getEnemiesCellValue(marioEgoRow, marioEgoCol + 1) != 0 ||
            getEnemiesCellValue(marioEgoRow, marioEgoCol + 2) != 0)
            return true;
        else
            return false;
	}
}

