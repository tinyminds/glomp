#pragma strict
public var GlompSize : float;
public var GlompHealth : float;
public var PopSize : float;
public var DoorSize : float;//
public var Level : int;
public var LevelsInWorld : int;
public var GlompScore : int;
public var bonusPanel : GameObject;
var explosionPrefab : GameObject;
public var HealthSlider: GUIBarScript;
public var SizeSlider : UnityEngine.UI.Slider;
public var ScoreText : UnityEngine.UI.Text;
public var GlompBonusPot : int;
public var BonusCounter : int = 0;
public var DoorPos : UnityEngine.UI.Image;
public var PlayerIcon : UnityEngine.UI.Image;
public var LevelText : UnityEngine.UI.Text;
public var BonusInBar : int;
public var BonusButton1 : GameObject;
public var BonusButton2 : GameObject;
public var BonusButton3 : GameObject;
public var BonusButton4 : GameObject;
public var BonusButton5 : GameObject;
public var BonusButton6 : GameObject;
public var BonusButton7 : GameObject;
public var BonusPotSlider : UnityEngine.UI.Slider;
var persistantGameObject : GameObject;
public var impact: AudioClip;
private var tooManyGameObject : GameObject[];
private var WorldLevel : int;
public var TeleportEffect : GameObject;
public var scoreMultiplierB : boolean = false;
public var healthMultiplierB : boolean = false;
public var zapShieldB : boolean = false;
public var zapCounterB : int = 0;
public var poop : GameObject;
private var hasCheckedLock : boolean = false;
public var GlompSkin : GameObject;

function Awake(){
	
	Screen.orientation = ScreenOrientation.AutoRotation;	
	DoorPos.rectTransform.sizeDelta = new Vector2(((100/5.8)*DoorSize), 43);
	tooManyGameObject = GameObject.FindGameObjectsWithTag("PersistantVars");
	if(tooManyGameObject.Length>1)
	{Destroy(tooManyGameObject[1]);}
	GlompSkin.GetComponent.<Renderer>().material = persistantGameObject.GetComponent(Persistance).GlompMatGame[PlayerPrefs.GetInt("GlompMaterial",1)-1];
	GlompSkin.GetComponent.<MeshFilter>().mesh = persistantGameObject.GetComponent(Persistance).GlompMeshGame[PlayerPrefs.GetInt("GlompBody",0)];
	LevelsInWorld = persistantGameObject.GetComponent(Persistance).LevelsInWorld;
	persistantGameObject = GameObject.Find("PersistantVars");
	ZoomIn();
	GlompSkin.AddComponent(CrumpleMesh);
	print("loading player prefs in glomp world "+PlayerPrefs.GetInt("WORLD_LEVEL",1));
	persistantGameObject.GetComponent(Persistance).TheWorld = PlayerPrefs.GetInt("WORLD_LEVEL",1);
	WorldLevel = PlayerPrefs.GetInt("WORLD_LEVEL",1);
	//print(WorldLevel + " world");
	//print(PlayerPrefs.GetInt("Game_LEVEL_"+WorldLevel,1)+ " level");
	if(PlayerPrefs.GetInt("Game_LEVEL_"+WorldLevel,1)>LevelsInWorld)
	{
		//starting th world fresh a it i finnished
		persistantGameObject.GetComponent(Persistance).TheLevel = 1;
		persistantGameObject.GetComponent(Persistance).TheBonusCounter = 0;
		persistantGameObject.GetComponent(Persistance).TheBonusSliderValue = 0;
		persistantGameObject.GetComponent(Persistance).TheGlompScore = 0;
		persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar = 0;
	}
	else
	{
		persistantGameObject.GetComponent(Persistance).TheLevel = PlayerPrefs.GetInt("Game_LEVEL_"+WorldLevel,1);
		persistantGameObject.GetComponent(Persistance).TheBonusCounter = PlayerPrefs.GetInt("TheBonusCounter_"+WorldLevel,0);
		persistantGameObject.GetComponent(Persistance).TheBonusSliderValue = PlayerPrefs.GetInt("TheBonusSliderValue_"+WorldLevel,0);
		persistantGameObject.GetComponent(Persistance).TheGlompScore = PlayerPrefs.GetInt("TheGlompScore_"+WorldLevel,0);
		persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar = PlayerPrefs.GetInt("BonusInBar_"+WorldLevel,0);
		//print(persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar + "stored bonus from persistanec");
	}
	Level = persistantGameObject.GetComponent(Persistance).TheLevel;
	GlompScore = persistantGameObject.GetComponent(Persistance).TheGlompScore;
	BonusCounter = persistantGameObject.GetComponent(Persistance).TheBonusCounter;
	BonusPotSlider.value = persistantGameObject.GetComponent(Persistance).TheBonusSliderValue;
	BonusInBar = persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar;
	
}


function Start () {
	//HealthValue = GetComponent(GUIBarScript);
}

function Update () {
	//print("HealthSlider.Value: "+HealthSlider.Value + "g health" + GlompHealth);
	HealthSlider.Value=GlompHealth;
	SizeSlider.value=GlompSize;
	ScoreText.text = GlompScore+"";
	LevelText.text = Level+"";
	PlayerIcon.rectTransform.sizeDelta = new Vector2(((100/5.8)*GlompSize), ((100/5.8)*GlompSize));
	if(GlompSize>DoorSize)
	{
	DoorPos.color = Color.red;
	}
	else
	{
	DoorPos.color =  new Color(0.5,0.8,0.8,0.8);
	}
	if(BonusCounter>=10)
	{
	BonusPotSlider.value=BonusPotSlider.value+1;
	BonusCounter=0;
	}
	if(BonusPotSlider.value==BonusPotSlider.maxValue)
	{
		//print("bonus popup, chose your bonus item, click it in the top bar to us it.");
		bonusPanel.SetActive(true);
		if(!hasCheckedLock)
		{
		bonusPanel.GetComponent(LockedBonus).checkLocks();
		hasCheckedLock = true;
		}
		Time.timeScale = 0;
		//BonusPotSlider.value=0;
	}
	if(GlompHealth==0)
	{
		print("die, shrivel anim");
		//die animation
		Instantiate(explosionPrefab, transform.position, transform.rotation);
		persistantGameObject.GetComponent(Persistance).isDead = true;
		persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar = 0;
		persistantGameObject.GetComponent(Persistance).gotGold = 0;
		Destroy(gameObject);
	}

	if(GlompSize>=PopSize)
	{
		print("pop too big");
		//animate pop
		
		Instantiate(explosionPrefab, transform.position, transform.rotation);
		persistantGameObject.GetComponent(Persistance).isDead = true;
		persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar = 0;
		persistantGameObject.GetComponent(Persistance).gotGold = 0;
		Destroy(gameObject);
	}
		if(GlompSize<=0.3)
	{
		print("pop to small");
		//animate pop
		Instantiate(explosionPrefab, transform.position, transform.rotation);
		persistantGameObject.GetComponent(Persistance).isDead = true;
		persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar = 0;
		persistantGameObject.GetComponent(Persistance).gotGold = 0;
		Destroy(gameObject);
	}
	if(persistantGameObject.GetComponent(Persistance).BonusNumClicked!=0)
	{
		if(BonusInBar!=0)
		{
			print(BonusInBar + "bonus we already have");
			//remove bonus already in bar if you get another one
			var buttonToHide : GameObject = eval("BonusButton"+BonusInBar);
			buttonToHide.SetActive(false);
			BonusInBar = persistantGameObject.GetComponent(Persistance).BonusNumClicked;
		}
		bonusIsClicked(persistantGameObject.GetComponent(Persistance).BonusNumClicked);
		bonusPanel.SetActive(false);
		//print("show bonus in topbar");
		var buttonToShow : GameObject = eval("BonusButton"+persistantGameObject.GetComponent(Persistance).BonusNumClicked);
		buttonToShow.SetActive(true);
		persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar = persistantGameObject.GetComponent(Persistance).BonusNumClicked;
		//print("save num to stored in bar");
		persistantGameObject.GetComponent(Persistance).BonusNumClicked=0;
		Time.timeScale = 1;
	}
	if(BonusInBar!=0)
	{
		var buttonToShow1 : GameObject = eval("BonusButton"+BonusInBar);
		buttonToShow1.SetActive(true);
	}
	
	if(persistantGameObject.GetComponent(Persistance).BonusNumInBar!=0)
	{
		//print("bonus used: "+persistantGameObject.GetComponent(Persistance).BonusNumInBar);
		eval("doBonusNumber"+persistantGameObject.GetComponent(Persistance).BonusNumInBar+"()");
		persistantGameObject.GetComponent(Persistance).BonusNumInBar = 0;
		BonusInBar = 0;
		persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar=0;
	}
}

function OnCollisionEnter( collision : Collision ) 
{
		if(collision.gameObject.tag=="Exit")
		{
			gotToTheExit();
		}
}

function gotToTheExit()
{
	PlayerPrefs.SetInt("Game_LEVEL_"+WorldLevel,Level+1);
	PlayerPrefs.SetInt("TheBonusCounter_"+WorldLevel,BonusCounter);
	PlayerPrefs.SetInt("TheBonusSliderValue_"+WorldLevel,BonusPotSlider.value);
	PlayerPrefs.SetInt("TheGlompScore_"+WorldLevel,GlompScore);
	PlayerPrefs.SetInt("BonusInBar_"+WorldLevel,persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar);
	PlayerPrefs.Save();
	//print("saved some prefs");
	if((persistantGameObject.GetComponent(Persistance).gotGold)&&(PlayerPrefs.GetInt ("world_" + WorldLevel+ "_level_" + Level + "_gotGoldDrop",0)==0))
	{PlayerPrefs.SetInt ("totalGold", (PlayerPrefs.GetInt ("totalGold", 0)+1));}
	PlayerPrefs.SetInt ("world_" + WorldLevel+ "_level_" + Level + "_gotGoldDrop", persistantGameObject.GetComponent(Persistance).gotGold);
	persistantGameObject.GetComponent(Persistance).gotGold = 0;
	persistantGameObject.GetComponent(Persistance).hasWon = true;
	persistantGameObject.GetComponent(Persistance).TheGlompScore = GlompScore;
	saveHighScore(WorldLevel, GlompScore);
	//print("score "+GlompScore);
	persistantGameObject.GetComponent(Persistance).TheBonusCounter = BonusCounter;
	persistantGameObject.GetComponent(Persistance).TheBonusSliderValue = BonusPotSlider.value;
	persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar = BonusInBar;
	persistantGameObject.GetComponent(Persistance).TheLevel = Level+1;
	Destroy(gameObject);
}


function ZoomIn()
{
		persistantGameObject.GetComponent(Persistance).ShowLevelStartPopUp = true;
		Time.timeScale = 0; 
		var t : float  = 20;
   		while( t > 5 )
    	{
        	t -= ( Time.deltaTime / 0.1f );
        	GameObject.Find("MainCamera").GetComponent(Camera).orthographicSize = t;
        	yield;
    	} 	
}

function bonusIsClicked ( bonusNum : int)
{
	BonusPotSlider.value=0;
}

function saveHighScore(world : int, score : int)
{
	if(PlayerPrefs.GetInt("TheGlompHighScore_"+world,0)<score)
	{
		PlayerPrefs.SetInt("TheGlompHighScore_"+world, score);
	}
}

function doBonusNumber1()
{
//Cell split
//strech and flatten, add another glomp, sounds
//halve glomp size (int not float)
//ai for other glomp
persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar = 0;
BonusButton1.SetActive(false);
}


function doBonusNumber2()
{
	//Star jumper
	print("start jump");
	var tempTime = gameObject.transform.position.y;
	StartCoroutine(jumpUp());
	print("jumping");
	persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar = 0;
	BonusButton2.SetActive(false);
}

function jumpUp()
{
 	 	var myCollider2 : CapsuleCollider = gameObject.transform.GetComponent(CapsuleCollider);

 	gameObject.transform.position.y = gameObject.transform.position.y+1.2;
 	yield WaitForSeconds(0.5f);
 	if(GlompSize>=0.6)
 	{
 		GlompSize = GlompSize - 0.2;
 		gameObject.transform.localScale = Vector3 (GlompSize,GlompSize,GlompSize);
 		myCollider2.radius =myCollider2.radius-0.006;
 	}
 	gameObject.transform.position.y = gameObject.transform.position.y+1.2;
 	yield WaitForSeconds(0.5f);
 	gameObject.transform.position.y = gameObject.transform.position.y+1.2;
 	if(GlompSize>=0.6)
 	{
 		GlompSize = GlompSize - 0.2;
 		gameObject.transform.localScale = Vector3 (GlompSize,GlompSize,GlompSize);
 		myCollider2.radius =myCollider2.radius-0.006;
 	}
 	yield WaitForSeconds(0.5f);
 	gameObject.transform.position.y = gameObject.transform.position.y+1.2;
 	yield WaitForSeconds(0.5f);
 	if(GlompSize>=0.6)
 	{
 		GlompSize = GlompSize - 0.2;
 		gameObject.transform.localScale = Vector3 (GlompSize,GlompSize,GlompSize);
 		myCollider2.radius =myCollider2.radius-0.006;
 	}


}
 
function doBonusNumber3()
{
	//Mega Poop
		if((Mathf.Round(GlompSize * 10)/10) - 0.6>=0.2)
	{GlompSize = (Mathf.Round(GlompSize * 10)/10) - 0.6;}
	else
	{GlompSize = 0.4;}
	GameObject.Instantiate(poop,gameObject.transform.position,gameObject.transform.rotation);
	GameObject.Instantiate(poop,gameObject.transform.position,gameObject.transform.rotation);
	GameObject.Instantiate(poop,gameObject.transform.position,gameObject.transform.rotation);
	gameObject.transform.localScale = Vector3 (GlompSize,GlompSize,GlompSize);
    var myCollider1 : CapsuleCollider = gameObject.transform.GetComponent(CapsuleCollider);
    myCollider1.radius =myCollider1.radius-0.006;
    
	persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar = 0;
	BonusButton3.SetActive(false);
}


function doBonusNumber4()
{
//Zap shield
zapShieldB = true;
zapCounterB = 1;
GameObject.Find("ZapShield").GetComponent.<Renderer>().enabled=true;
GameObject.Find("ZapShield").GetComponent.<Light>().enabled=true;
persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar = 0;
BonusButton4.SetActive(false);
}


function doBonusNumber5()
{
//Teleport escape
GameObject.Instantiate(TeleportEffect,gameObject.transform.position,gameObject.transform.rotation);
//add a sound to the prefab
gotToTheExit();
persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar = 0;
BonusButton5.SetActive(false);
}


function doBonusNumber6()
{
//health multiplier
healthMultiplierB=true;
persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar = 0;
BonusButton6.SetActive(false);
}


function doBonusNumber7()
{
//score multiplier
scoreMultiplierB = true;
persistantGameObject.GetComponent(Persistance).StoreBonusNumInBar = 0;
BonusButton7.SetActive(false);
}
