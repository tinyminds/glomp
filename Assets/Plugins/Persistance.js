#pragma strict
public var TheLevel : int;
public var TheWorld : int;
public var TheGlompScore : int;
public var TheBonusCounter : int;
public var TheBonusSliderValue : int;
public var hasWon : boolean;
public var isDead : boolean;
public var LevelsInWorld : int;
public var BonusNumClicked : int;
public var BonusNumInBar : int;
public var StoreBonusNumInBar : int;
public var GlompMatGame : Material [];
public var GlompMeshGame : Mesh [];
public var ShowLevelStartPopUp : boolean;
public var gotGold : int;

function Awake(){
DontDestroyOnLoad(transform.gameObject);
}


function Start () {

}

function Update () {
     if (Input.GetKey(KeyCode.Escape))
     {

          Application.Quit();
     }
}

