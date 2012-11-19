/*
 * Copyright (c) 2009-2010, Sergey Karakovskiy and Julian Togelius
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the Mario AI nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

package ch.idsia.agents.controllers;

import ch.idsia.agents.Agent;
import ch.idsia.benchmark.mario.engine.level.Level;
import java.util.ArrayList; 
import ch.idsia.benchmark.mario.engine.sprites.Mario;
import ch.idsia.benchmark.mario.environments.Environment;

/**
 * Created by IntelliJ IDEA.
 * User: Sergey Karakovskiy, sergey.karakovskiy@gmail.com
 * Date: Apr 8, 2009
 * Time: 4:03:46 AM
 */

public class MasterAgent extends BasicMarioAIAgent implements Agent
{
int trueJumpCounter = 0;
int trueSpeedCounter = 0;
ArrayList<String> actions = new ArrayList<String>();
ArrayList<String> temp = new ArrayList<String>();
int actionCounter = 1;
boolean stuck = false;
int stuckCounter = 0;
int killcount = 0;


public MasterAgent()
{
    super("MasterAgent");
    reset();
}

public void reset()
{
    action = new boolean[Environment.numberOfKeys];
    action[Mario.KEY_RIGHT] = false;
    action[Mario.KEY_LEFT] = false;
    action[Mario.KEY_SPEED] = false;
    trueJumpCounter = 0;
    trueSpeedCounter = 0;
}

private boolean DangerOfAny()
{

        if ((getReceptiveFieldCellValue(marioEgoRow + 2, marioEgoCol + 1) == 0 &&
            getReceptiveFieldCellValue(marioEgoRow + 1, marioEgoCol + 1) == 0) ||
            getReceptiveFieldCellValue(marioEgoRow, marioEgoCol + 1) != 0 ||
            getReceptiveFieldCellValue(marioEgoRow, marioEgoCol + 2) != 0 ||
            getEnemiesCellValue(marioEgoRow, marioEgoCol + 1) != 0 ||
            getEnemiesCellValue(marioEgoRow, marioEgoCol + 2) != 0)
            return true;
        else
            return false;
}

public boolean enemyAhead(){
	
	return (getEnemiesCellValue(marioEgoRow, marioEgoCol + 2) != 0 &&
			getEnemiesCellValue(marioEgoRow, marioEgoCol + 2) != 91|| 
			getEnemiesCellValue(marioEgoRow, marioEgoCol + 3) != 0 &&
			getEnemiesCellValue(marioEgoRow, marioEgoCol + 3) != 91||
			getEnemiesCellValue(marioEgoRow, marioEgoCol + 4) != 0 &&
			getEnemiesCellValue(marioEgoRow, marioEgoCol + 4) != 91);
}

public boolean enemyBehind(){
	return (getEnemiesCellValue(marioEgoRow, marioEgoCol - 2) != 0 &&
			getEnemiesCellValue(marioEgoRow, marioEgoCol - 2) != 91||
			getEnemiesCellValue(marioEgoRow, marioEgoCol - 3) != 0 &&
			getEnemiesCellValue(marioEgoRow, marioEgoCol - 3) != 91||
			getEnemiesCellValue(marioEgoRow, marioEgoCol - 4) != 0 &&
			getEnemiesCellValue(marioEgoRow, marioEgoCol - 4) != 91);
}

public boolean enemyBelowLeft(){
	
	return (!isMarioAbleToJump &&
			(getEnemiesCellValue(marioEgoRow +1, marioEgoCol -1) != 0 &&
			getEnemiesCellValue(marioEgoRow +1, marioEgoCol -1) != 91||
			getEnemiesCellValue(marioEgoRow +2, marioEgoCol -1) != 0 &&
			getEnemiesCellValue(marioEgoRow +2, marioEgoCol -1) != 91||
			getEnemiesCellValue(marioEgoRow +3, marioEgoCol -1) != 0 &&
			getEnemiesCellValue(marioEgoRow +3, marioEgoCol -1) != 91||
			getEnemiesCellValue(marioEgoRow +4, marioEgoCol -1) != 0 &&
			getEnemiesCellValue(marioEgoRow +4, marioEgoCol -1) != 91||
			getEnemiesCellValue(marioEgoRow +5, marioEgoCol -1) != 0 &&
			getEnemiesCellValue(marioEgoRow +5, marioEgoCol -1) != 91||
			getEnemiesCellValue(marioEgoRow +1, marioEgoCol -2) != 0 &&
			getEnemiesCellValue(marioEgoRow +1, marioEgoCol -2) != 91||
			getEnemiesCellValue(marioEgoRow +2, marioEgoCol -2) != 0 &&
			getEnemiesCellValue(marioEgoRow +2, marioEgoCol -2) != 91||
			getEnemiesCellValue(marioEgoRow +3, marioEgoCol -2) != 0 &&
			getEnemiesCellValue(marioEgoRow +3, marioEgoCol -2) != 91||
			getEnemiesCellValue(marioEgoRow +4, marioEgoCol -2) != 0 &&
			getEnemiesCellValue(marioEgoRow +4, marioEgoCol -2) != 91||
			getEnemiesCellValue(marioEgoRow +5, marioEgoCol -2) != 0 &&
			getEnemiesCellValue(marioEgoRow +5, marioEgoCol -2) != 91||
			getEnemiesCellValue(marioEgoRow +1, marioEgoCol -3) != 0 &&
			getEnemiesCellValue(marioEgoRow +1, marioEgoCol -3) != 91||
			getEnemiesCellValue(marioEgoRow +2, marioEgoCol -3) != 0 &&
			getEnemiesCellValue(marioEgoRow +2, marioEgoCol -3) != 91||
			getEnemiesCellValue(marioEgoRow +3, marioEgoCol -3) != 0 &&
			getEnemiesCellValue(marioEgoRow +3, marioEgoCol -3) != 91||
			getEnemiesCellValue(marioEgoRow +4, marioEgoCol -3) != 0 &&
			getEnemiesCellValue(marioEgoRow +4, marioEgoCol -3) != 91||
			getEnemiesCellValue(marioEgoRow +5, marioEgoCol -3) != 0) &&
			getEnemiesCellValue(marioEgoRow +5, marioEgoCol -3) != 91);
}

public boolean enemyBelowRight(){
	return (!isMarioAbleToJump &&
			(getEnemiesCellValue(marioEgoRow +1, marioEgoCol +1) != 0 &&
			getEnemiesCellValue(marioEgoRow +1, marioEgoCol +1) != 91||
			getEnemiesCellValue(marioEgoRow +2, marioEgoCol +1) != 0 &&
			getEnemiesCellValue(marioEgoRow +2, marioEgoCol +1) != 91||
			getEnemiesCellValue(marioEgoRow +3, marioEgoCol +1) != 0 &&
			getEnemiesCellValue(marioEgoRow +3, marioEgoCol +1) != 91||
			getEnemiesCellValue(marioEgoRow +4, marioEgoCol +1) != 0 &&
			getEnemiesCellValue(marioEgoRow +4, marioEgoCol +1) != 91||
			getEnemiesCellValue(marioEgoRow +5, marioEgoCol +1) != 0 &&
			getEnemiesCellValue(marioEgoRow +5, marioEgoCol +1) != 91||
			getEnemiesCellValue(marioEgoRow +1, marioEgoCol +2) != 0 &&
			getEnemiesCellValue(marioEgoRow +1, marioEgoCol +2) != 91||
			getEnemiesCellValue(marioEgoRow +2, marioEgoCol +2) != 0 &&
			getEnemiesCellValue(marioEgoRow +2, marioEgoCol +2) != 91||
			getEnemiesCellValue(marioEgoRow +3, marioEgoCol +2) != 0 &&
			getEnemiesCellValue(marioEgoRow +3, marioEgoCol +2) != 91||
			getEnemiesCellValue(marioEgoRow +4, marioEgoCol +2) != 0 &&
			getEnemiesCellValue(marioEgoRow +4, marioEgoCol +2) != 91||
			getEnemiesCellValue(marioEgoRow +5, marioEgoCol +2) != 0 &&
			getEnemiesCellValue(marioEgoRow +5, marioEgoCol +2) != 91||
			getEnemiesCellValue(marioEgoRow +1, marioEgoCol +3) != 0 &&
			getEnemiesCellValue(marioEgoRow +1, marioEgoCol +3) != 91||
			getEnemiesCellValue(marioEgoRow +2, marioEgoCol +3) != 0 &&
			getEnemiesCellValue(marioEgoRow +2, marioEgoCol +3) != 91||
			getEnemiesCellValue(marioEgoRow +3, marioEgoCol +3) != 0 &&
			getEnemiesCellValue(marioEgoRow +3, marioEgoCol +3) != 91||
			getEnemiesCellValue(marioEgoRow +4, marioEgoCol +3) != 0 &&
			getEnemiesCellValue(marioEgoRow +4, marioEgoCol +3) != 91||
			getEnemiesCellValue(marioEgoRow +5, marioEgoCol +3) != 0) &&
			getEnemiesCellValue(marioEgoRow +5, marioEgoCol +3) != 91);
}
public boolean enemyBelow(){
	return (!isMarioAbleToJump &&
			(getEnemiesCellValue(marioEgoRow +1, marioEgoCol) != 0 &&
			getEnemiesCellValue(marioEgoRow +1, marioEgoCol) != 91|| 
			getEnemiesCellValue(marioEgoRow +2, marioEgoCol) != 0 &&
			getEnemiesCellValue(marioEgoRow +2, marioEgoCol) != 91||
			getEnemiesCellValue(marioEgoRow +3, marioEgoCol) != 0 &&
			getEnemiesCellValue(marioEgoRow +3, marioEgoCol) != 91||
			getEnemiesCellValue(marioEgoRow +4, marioEgoCol) != 0 &&
			getEnemiesCellValue(marioEgoRow +4, marioEgoCol) != 91));
}

public boolean[] getAction()
{
		
	if(stuck){
		action[Mario.KEY_RIGHT] = true;
    	action[Mario.KEY_LEFT] = false;
    	action[Mario.KEY_SPEED] = false;
    	action[Mario.KEY_JUMP] = isMarioAbleToJump || !isMarioOnGround;
    	actions.add("default");
    	stuckCounter++;
    	System.out.println("stuck");
    	if(stuckCounter == 14){
    		stuckCounter = 0;
    		stuck = false;
    	}
	}
	else if(enemyBehind()){
		action[Mario.KEY_RIGHT] = false;
		action[Mario.KEY_LEFT] = true;
    	action[Mario.KEY_SPEED] = false;//true
    	action[Mario.KEY_JUMP] = isMarioAbleToJump || !isMarioOnGround;
    	//System.out.println("Behind");
    	actions.add("enemyBehind");
    	actionCounter++;
	}
	else if (enemyAhead()){
		action[Mario.KEY_RIGHT] = false;
		action[Mario.KEY_LEFT] = false;
    	action[Mario.KEY_SPEED] = false;//true
    	action[Mario.KEY_JUMP] = isMarioAbleToJump || !isMarioOnGround;
    	//System.out.println("Ahead");
    	actions.add("enemyAhead");
    	actionCounter++;
	}
	else if (enemyBelowLeft()){
		action[Mario.KEY_RIGHT] = false;
		action[Mario.KEY_LEFT] = true;
    	action[Mario.KEY_SPEED] = false;
    	action[Mario.KEY_JUMP] = true;
    	//action[Mario.KEY_JUMP] = isMarioAbleToJump || !isMarioOnGround;
    	//System.out.println("BelowLeft");
    	actions.add("enemyBelowLeft");
    	actionCounter++;
	}
	else if (enemyBelowRight()){
		action[Mario.KEY_RIGHT] = true;
		action[Mario.KEY_LEFT] = false;
    	action[Mario.KEY_SPEED] = false;
    	action[Mario.KEY_JUMP] = true;
    	//action[Mario.KEY_JUMP] = isMarioAbleToJump || !isMarioOnGround;
    	//System.out.println("BelowRight");
    	actions.add("enemyBelowRight");
    	actionCounter++;
	}
	else if (enemyBelow()){
		action[Mario.KEY_RIGHT] = false;
		action[Mario.KEY_LEFT] = false;
    	action[Mario.KEY_SPEED] = false;
    	action[Mario.KEY_JUMP] = false;
    	//action[Mario.KEY_JUMP] = isMarioAbleToJump || !isMarioOnGround;
    	//System.out.println("Below");
    	actions.add("enemyBelow");
    	actionCounter++;
	}
	else {
		action[Mario.KEY_RIGHT] = true;
    	action[Mario.KEY_LEFT] = false;
    	action[Mario.KEY_SPEED] = false;
    	action[Mario.KEY_JUMP] = isMarioAbleToJump || !isMarioOnGround;
    	//actions.add("default");
    	//System.out.println("default");
	}
	
	System.out.println(getEnemiesCellValue(marioEgoRow+1, marioEgoCol));
	int count = 50;
	
	if(actions.size() % count == 0 && actions.size() > 0){
		if(killcount == getKillsTotal){
			stuck = true;
		}
		killcount = getKillsTotal;
	}
    return action;
}
}