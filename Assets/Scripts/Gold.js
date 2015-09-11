#pragma strict
private var tpc : UnityStandardAssets.Characters.ThirdPerson.ThirdPersonUserControl;
tpc = GameObject.FindObjectOfType(UnityStandardAssets.Characters.ThirdPerson.ThirdPersonUserControl);
public var persistantGameObject : GameObject;
public var ThisWorld : int;
public var ThisLevel : int;
public var starMat : Material;
private var usedStar : boolean = false;

function Start () {
	gameObject.transform.position = new Vector3(Random.Range(-9,9),70,Random.Range(-9,9));
	persistantGameObject = GameObject.Find("PersistantVars");
	ThisWorld = persistantGameObject.GetComponent(Persistance).TheWorld;
	ThisLevel = persistantGameObject.GetComponent(Persistance).TheLevel;
	var getPrefs : int = PlayerPrefs.GetInt ("world_" + ThisWorld + "_level_" + ThisLevel + "_gotGoldDrop", 0);
	if(getPrefs==1)
	{
		usedStar = true;
	}
	if(usedStar)
	{
		gameObject.GetComponent.<Renderer>().material = starMat;
		persistantGameObject.GetComponent(Persistance).gotGold = 1;
	}
}

function Update () {
}



function OnCollisionEnter(collision: Collision) 
{
	
	if(collision.gameObject.tag=="Glomp")
	{
	 	if(usedStar)
	 	{
	 		tpc.GetComponent(GlompCharacter).GlompScore = tpc.GetComponent(GlompCharacter).GlompScore + 10;
	 		tpc.GetComponent(GlompCharacter).BonusCounter = tpc.GetComponent(GlompCharacter).BonusCounter + 10;
	 	}
	 	persistantGameObject.GetComponent(Persistance).gotGold = 1;
		Destroy (gameObject);
	}
}