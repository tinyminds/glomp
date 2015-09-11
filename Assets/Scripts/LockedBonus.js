#pragma strict

public var bonus1WorldUnlockCondition : int;
public var bonus1LevelUnlockCondition : int;
public var bonus2WorldUnlockCondition : int;
public var bonus2LevelUnlockCondition : int;
public var bonus3WorldUnlockCondition : int;
public var bonus3LevelUnlockCondition : int;
public var bonus4WorldUnlockCondition : int;
public var bonus4LevelUnlockCondition : int;
public var bonus5WorldUnlockCondition : int;
public var bonus5LevelUnlockCondition : int;
public var bonus6WorldUnlockCondition : int;
public var bonus6LevelUnlockCondition : int;
public var bonus7WorldUnlockCondition : int;
public var bonus7LevelUnlockCondition : int;
public var bonus1Obj : GameObject;
public var bonus2Obj : GameObject;
public var bonus3Obj : GameObject;
public var bonus4Obj : GameObject;
public var bonus5Obj : GameObject;
public var bonus6Obj : GameObject;
public var bonus7Obj : GameObject;
private var persistantGameObject : GameObject;
private var theWorld : int;
private var theLevel : int;

function Start () {
	persistantGameObject = GameObject.Find("PersistantVars");
	theWorld = persistantGameObject.GetComponent(Persistance).TheWorld;
	theLevel = persistantGameObject.GetComponent(Persistance).TheLevel;
	checkLocks();
}

function Update () {

}

function checkLocks()
{
print("checking locks");
	if((((theWorld)>=bonus7WorldUnlockCondition)&&(theLevel>=bonus7LevelUnlockCondition))||((bonus7WorldUnlockCondition==1)&&(theWorld>1)))
	{
		 //bonus7Obj.GetComponent(RectTransform).position.x=10000;
		 bonus7Obj.SetActive(false);
	}
	if((((theWorld)>=bonus6WorldUnlockCondition)&&(theLevel>=bonus6LevelUnlockCondition))||((bonus6WorldUnlockCondition==1)&&(theWorld>1)))
	{
		 //bonus6Obj.GetComponent(RectTransform).position.x=10000;
		 bonus6Obj.SetActive(false);
	}
	if((((theWorld)>=bonus5WorldUnlockCondition)&&(theLevel>=bonus5LevelUnlockCondition))||((bonus5WorldUnlockCondition==1)&&(theWorld>1)))
	{
		// bonus5Obj.GetComponent(RectTransform).position.x=10000;
		 bonus5Obj.SetActive(false);
	}
	if((((theWorld)>=bonus4WorldUnlockCondition)&&(theLevel>=bonus4LevelUnlockCondition))||((bonus4WorldUnlockCondition==1)&&(theWorld>1)))
	{
		 //bonus4Obj.GetComponent(RectTransform).position.x=10000;
		  bonus4Obj.SetActive(false);
	}
	if((((theWorld)>=bonus3WorldUnlockCondition)&&(theLevel>=bonus3LevelUnlockCondition))||((bonus3WorldUnlockCondition==1)&&(theWorld>1)))
	{
		 //bonus3Obj.GetComponent(RectTransform).position.x=10000;
		 bonus3Obj.SetActive(false);
	}
	if((((theWorld)>=bonus2WorldUnlockCondition)&&(theLevel>=bonus2LevelUnlockCondition))||((bonus2WorldUnlockCondition==1)&&(theWorld>1)))
	{
		 //bonus2Obj.GetComponent(RectTransform).position.x=10000;
		  bonus2Obj.SetActive(false);
	}
	if((((theWorld)>=bonus1WorldUnlockCondition)&&(theLevel>=bonus1LevelUnlockCondition))||((bonus1WorldUnlockCondition==1)&&(theWorld>1)))
	{
		 //bonus1Obj.GetComponent(RectTransform).position.x=10000;
		 bonus1Obj.SetActive(false);
	}
}
