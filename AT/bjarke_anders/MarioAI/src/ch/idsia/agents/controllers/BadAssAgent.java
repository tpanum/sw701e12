
package ch.idsia.agents.controllers;

import java.util.ArrayList;

import ch.idsia.agents.Agent;
import ch.idsia.benchmark.mario.engine.sprites.Mario;
import ch.idsia.benchmark.mario.environments.Environment;

public class BadAssAgent extends BasicMarioAIAgent implements Agent {
	ArrayList<Integer> history;
	boolean shoot;
	int stuckCount;
	boolean stuck;
	int repeatMax;

	public BadAssAgent() {
		super("BadAssAgent");
		reset();
	}

	public void reset() {
		action = new boolean[Environment.numberOfKeys];
		action[Mario.KEY_RIGHT] = true;
		shoot = false;
		history = new ArrayList<Integer>(10);
		stuckCount = 0;
		stuck = false;
		repeatMax = 15;
	}


	public boolean[] getAction() {

		action[Mario.KEY_SPEED] = false;
		action[Mario.KEY_LEFT] = false;
		action[Mario.KEY_RIGHT] = true;
		int current = 0;
		boolean enemies = false;

		if (history.size() >= repeatMax) {
			int occurrence = history.get(0);
			if (occurrence != 0) {
				if (!stuck) {
					stuck = true;
					for (int i = 1; i < repeatMax; i++) {
						if (occurrence != history.get(i)) {
							stuck = false;
							break;
						}
					}
				}
			}
		}

		if (stuck && stuckCount < 3) {
			action[Mario.KEY_JUMP] = isMarioAbleToJump || !isMarioOnGround;
			action[Mario.KEY_SPEED] = false;
			System.out.println("Stuck");
			stuckCount++;
		}
		else {
			if (stuck && stuckCount > 30) {
				stuck = false;
				stuckCount = 0;
			}
			else {
				stuckCount++;
			}
			if (CoinAbove()) {
				action[Mario.KEY_RIGHT] = false;
				action[Mario.KEY_LEFT] = false;
				action[Mario.KEY_JUMP] = isMarioAbleToJump || !isMarioOnGround;
				current = 8;
			}
			else if (CoinBelow() && !stuck) {
				action[Mario.KEY_RIGHT] = false;
				action[Mario.KEY_LEFT] = false;
				current = 9;
			}
			else if (EnemyBelow() && !stuck) {
				action[Mario.KEY_RIGHT] = false;
				action[Mario.KEY_LEFT] = false;
				if (shoot) {
					shoot = false;
				} else {
					shoot = true;
				}
				current = 2;
				enemies = true;
			}
			else if (EnemyBelowLeft() && !stuck) {
				action[Mario.KEY_RIGHT] = false;
				action[Mario.KEY_LEFT] = true;
				action[Mario.KEY_JUMP] = isMarioAbleToJump || !isMarioOnGround;
				if (shoot) {
					shoot = false;
				} else {
					shoot = true;
				}
				current = 1;
				enemies = true;
			}
			else if (CoinBehind() && !stuck) {
				action[Mario.KEY_RIGHT] = false;
				action[Mario.KEY_LEFT] = true;
				if (ObstructionBehind()) {
					action[Mario.KEY_JUMP] = isMarioAbleToJump || !isMarioOnGround;
				}
				current = 7;
			}
			else if (EnemyAboveRight()) {
				action[Mario.KEY_RIGHT] = false;
				action[Mario.KEY_LEFT] = true;
				current = 3;
				enemies = true;
			}
			else if (EnemyAhead()) {
				action[Mario.KEY_JUMP] = isMarioAbleToJump || !isMarioOnGround;
				if (shoot) {
					shoot = false;
				} else {
					shoot = true;
				}
				current = 4;
				enemies = true;
			}
			else if (EnemyBelowRight()) {
				action[Mario.KEY_JUMP] = isMarioAbleToJump || !isMarioOnGround;
				if (shoot) {
					shoot = false;
				} else {
					shoot = true;
				}
				current = 5;
				enemies = true;
			}
			else if (ObstructionAhead()) {
				action[Mario.KEY_JUMP] = isMarioAbleToJump || !isMarioOnGround;
				action[Mario.KEY_SPEED] = false;
				current = 6;
			} 
			else {
				action[Mario.KEY_JUMP] = false;
				action[Mario.KEY_SPEED] = false;
				System.out.println("Default");
				current = 0;
			}
		}

		history.add(0, current);
		if (history.size() > repeatMax) {
			history.remove(repeatMax);
		}
		if (enemies && !stuck) {
			action[Mario.KEY_SPEED] = shoot;
		}

		return action;
	}

	private boolean DangerOfAny() {
		if ((getReceptiveFieldCellValue(marioEgoRow + 2, marioEgoCol + 1) == 0 && getReceptiveFieldCellValue(marioEgoRow + 1, marioEgoCol + 1) == 0) ||
				getReceptiveFieldCellValue(marioEgoRow, marioEgoCol + 1) != 0 ||
				getReceptiveFieldCellValue(marioEgoRow, marioEgoCol + 2) != 0 ||
				getEnemiesCellValue(marioEgoRow, marioEgoCol + 1) != 0 ||
				getEnemiesCellValue(marioEgoRow, marioEgoCol + 2) != 0) {
			return true;
		} else {
			return false;
		}
	}

	private boolean ObstructionAhead() {
		if (
				getReceptiveFieldCellValue(marioEgoRow, marioEgoCol + 1) == -24 ||
				getReceptiveFieldCellValue(marioEgoRow - 1, marioEgoCol + 1) == -24 ||
				getReceptiveFieldCellValue(marioEgoRow - 2, marioEgoCol + 1) == -24 ||
				getReceptiveFieldCellValue(marioEgoRow, marioEgoCol + 1) == -60 ||
				getReceptiveFieldCellValue(marioEgoRow - 1, marioEgoCol + 1) == -60 ||
				getReceptiveFieldCellValue(marioEgoRow - 2, marioEgoCol + 1) == -60 ||
				getReceptiveFieldCellValue(marioEgoRow, marioEgoCol + 1) == -85 ||
				getReceptiveFieldCellValue(marioEgoRow - 1, marioEgoCol + 1) == -85 ||
				getReceptiveFieldCellValue(marioEgoRow - 2, marioEgoCol + 1) == -85
				) {
			System.out.println("Obstruction Ahead");
			return true;
		} else {
			return false;
		}
	}
	
	private boolean ObstructionBehind() {
		if (
				getReceptiveFieldCellValue(marioEgoRow, marioEgoCol - 1) == -24 ||
				getReceptiveFieldCellValue(marioEgoRow - 1, marioEgoCol - 1) == -24 ||
				getReceptiveFieldCellValue(marioEgoRow, marioEgoCol - 1) == -60 ||
				getReceptiveFieldCellValue(marioEgoRow - 1, marioEgoCol - 1) == -60 ||
				getReceptiveFieldCellValue(marioEgoRow, marioEgoCol - 1) == -85 ||
				getReceptiveFieldCellValue(marioEgoRow - 1, marioEgoCol - 1) == -85
				) {
			System.out.println("Obstruction Behind");
			return true;
		} else {
			return false;
		}
	}

	private boolean EnemyAboveRight() {
		if (getEnemiesCellValue(marioEgoRow - 1, marioEgoCol + 1) != 0 || 
				
				getEnemiesCellValue(marioEgoRow - 2, marioEgoCol + 1) != 0 ||

				getEnemiesCellValue(marioEgoRow - 3, marioEgoCol + 1) != 0) {
			System.out.println("Above Right");
			return true;
		} else {
			return false;
		}
	}

	private boolean EnemyBelowLeft() {
		if (getEnemiesCellValue(marioEgoRow, marioEgoCol - 1) != 0 || 
				getEnemiesCellValue(marioEgoRow, marioEgoCol - 2) != 0 ||
				getEnemiesCellValue(marioEgoRow, marioEgoCol - 3) != 0 ||

				getEnemiesCellValue(marioEgoRow + 1, marioEgoCol - 1) != 0 || 
				getEnemiesCellValue(marioEgoRow + 1, marioEgoCol - 2) != 0 ||
				getEnemiesCellValue(marioEgoRow + 1, marioEgoCol - 3) != 0 ||

				getEnemiesCellValue(marioEgoRow + 2, marioEgoCol - 1) != 0 || 
				getEnemiesCellValue(marioEgoRow + 2, marioEgoCol - 2) != 0 || 
				getEnemiesCellValue(marioEgoRow + 2, marioEgoCol - 3) != 0 ||

				getEnemiesCellValue(marioEgoRow + 3, marioEgoCol - 1) != 0 || 
				getEnemiesCellValue(marioEgoRow + 3, marioEgoCol - 2) != 0 ||
				getEnemiesCellValue(marioEgoRow + 3, marioEgoCol - 3) != 0 ||

				getEnemiesCellValue(marioEgoRow + 4, marioEgoCol - 1) != 0 || 
				getEnemiesCellValue(marioEgoRow + 4, marioEgoCol - 2) != 0 ||
				getEnemiesCellValue(marioEgoRow + 4, marioEgoCol - 3) != 0 ||

				getEnemiesCellValue(marioEgoRow + 5, marioEgoCol - 1) != 0 || 
				getEnemiesCellValue(marioEgoRow + 5, marioEgoCol - 2) != 0 ||
				getEnemiesCellValue(marioEgoRow + 5, marioEgoCol - 3) != 0) {
			System.out.println("Below Left");
			return true;
		} else {
			return false;
		}
	}

	private boolean EnemyBelow() {
		if (getEnemiesCellValue(marioEgoRow, marioEgoCol) != 0 || 
				getEnemiesCellValue(marioEgoRow + 1, marioEgoCol) != 0 ||
				getEnemiesCellValue(marioEgoRow + 2, marioEgoCol) != 0 ||
				getEnemiesCellValue(marioEgoRow + 3, marioEgoCol) != 0 ||
				getEnemiesCellValue(marioEgoRow + 4, marioEgoCol) != 0 ||
				getEnemiesCellValue(marioEgoRow + 5, marioEgoCol) != 0) {
			System.out.println("Below");
			return true;
		} else {
			return false;
		}
	}
	
	private boolean EnemyAhead() {
		if (getEnemiesCellValue(marioEgoRow - 1, marioEgoCol + 1) != 0 || 
				getEnemiesCellValue(marioEgoRow - 1, marioEgoCol + 2) != 0 || 
				getEnemiesCellValue(marioEgoRow - 1, marioEgoCol + 3) != 0 ||
				
				getEnemiesCellValue(marioEgoRow - 2, marioEgoCol + 1) != 0 || 
				getEnemiesCellValue(marioEgoRow - 2, marioEgoCol + 2) != 0 || 
				getEnemiesCellValue(marioEgoRow - 2, marioEgoCol + 3) != 0) {
			System.out.println("Ahead");
			return true;
		} else {
			return false;
		}
	}

	private boolean EnemyBelowRight() {
		if (getEnemiesCellValue(marioEgoRow, marioEgoCol + 1) != 0 || 
				getEnemiesCellValue(marioEgoRow, marioEgoCol + 2) != 0 ||
				getEnemiesCellValue(marioEgoRow, marioEgoCol + 3) != 0 ||

				getEnemiesCellValue(marioEgoRow + 1, marioEgoCol + 1) != 0 || 
				getEnemiesCellValue(marioEgoRow + 1, marioEgoCol + 2) != 0 ||
				getEnemiesCellValue(marioEgoRow + 1, marioEgoCol + 3) != 0 ||

				getEnemiesCellValue(marioEgoRow + 2, marioEgoCol + 1) != 0 || 
				getEnemiesCellValue(marioEgoRow + 2, marioEgoCol + 2) != 0 || 
				getEnemiesCellValue(marioEgoRow + 2, marioEgoCol + 3) != 0 ||

				getEnemiesCellValue(marioEgoRow + 3, marioEgoCol + 1) != 0 || 
				getEnemiesCellValue(marioEgoRow + 3, marioEgoCol + 2) != 0 || 
				getEnemiesCellValue(marioEgoRow + 3, marioEgoCol + 3) != 0 ||

				getEnemiesCellValue(marioEgoRow + 4, marioEgoCol + 1) != 0 || 
				getEnemiesCellValue(marioEgoRow + 4, marioEgoCol + 2) != 0 ||
				getEnemiesCellValue(marioEgoRow + 4, marioEgoCol + 3) != 0 ||

				getEnemiesCellValue(marioEgoRow + 5, marioEgoCol + 1) != 0 || 
				getEnemiesCellValue(marioEgoRow + 5, marioEgoCol + 2) != 0 || 
				getEnemiesCellValue(marioEgoRow + 5, marioEgoCol + 3) != 0) {
			System.out.println("Below Right");
			return true;
		} else {
			return false;
		}
	}
	
	private boolean CoinBehind() {
		if (getReceptiveFieldCellValue(marioEgoRow, marioEgoCol - 1) == 2 ||
				getReceptiveFieldCellValue(marioEgoRow, marioEgoCol - 2) == 2 ||
				getReceptiveFieldCellValue(marioEgoRow, marioEgoCol - 3) == 2 ||
				getReceptiveFieldCellValue(marioEgoRow, marioEgoCol - 4) == 2 ||
				
				getReceptiveFieldCellValue(marioEgoRow - 1, marioEgoCol - 1) == 2 ||
				getReceptiveFieldCellValue(marioEgoRow - 1, marioEgoCol - 2) == 2 ||
				getReceptiveFieldCellValue(marioEgoRow - 1, marioEgoCol - 3) == 2 ||
				getReceptiveFieldCellValue(marioEgoRow - 1, marioEgoCol - 4) == 2 ||
				
				getReceptiveFieldCellValue(marioEgoRow + 1, marioEgoCol - 1) == 2 ||
				getReceptiveFieldCellValue(marioEgoRow + 1, marioEgoCol - 2) == 2 ||
				getReceptiveFieldCellValue(marioEgoRow + 1, marioEgoCol - 3) == 2 ||
				getReceptiveFieldCellValue(marioEgoRow + 1, marioEgoCol - 4) == 2) {
			System.out.println("Coin Behind");
			return true;
		}
		return false;
	}
	
	private boolean CoinBelow() {
		if (getReceptiveFieldCellValue(marioEgoRow + 1, marioEgoCol) == 2 ||
				
				getReceptiveFieldCellValue(marioEgoRow + 2, marioEgoCol) == 2) {
			System.out.println("Coin Below");
			return true;
		}
		return false;
	}
	
	private boolean CoinAbove() {
		if (getReceptiveFieldCellValue(marioEgoRow, marioEgoCol) == 2 ||
				
				getReceptiveFieldCellValue(marioEgoRow - 1, marioEgoCol) == 2 ||
				
				getReceptiveFieldCellValue(marioEgoRow - 2, marioEgoCol) == 2) {
			System.out.println("Coin Above");
			return true;
		}
		return false;
	}
}

