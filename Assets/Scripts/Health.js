#pragma strict
private var tpc : UnityStandardAssets.Characters.ThirdPerson.ThirdPersonUserControl;
tpc = GameObject.FindObjectOfType(UnityStandardAssets.Characters.ThirdPerson.ThirdPersonUserControl);
public var impact: AudioClip;
function Start () {

}

function Update () {

}

function OnCollisionEnter(collision: Collision) 
{
	if(collision.gameObject.tag=="Glomp")
	{
		AudioSource.PlayClipAtPoint(impact, transform.position,PlayerPrefs.GetFloat("AudioVolume",1));
		if(tpc.GetComponent(GlompCharacter).healthMultiplierB)
		{
		print("health multiplier is go");
		tpc.GetComponent(GlompCharacter).GlompHealth = (Mathf.Round(tpc.GetComponent(GlompCharacter).GlompHealth * 10)/10) + 0.1;
		}
		else
		{tpc.GetComponent(GlompCharacter).GlompHealth = (Mathf.Round(tpc.GetComponent(GlompCharacter).GlompHealth * 10)/10) + 0.05;}
		
		Destroy (gameObject);
	}
	
 }

	
