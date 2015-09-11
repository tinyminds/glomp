#pragma strict
private var tpc : UnityStandardAssets.Characters.ThirdPerson.ThirdPersonUserControl;
tpc = GameObject.FindObjectOfType(UnityStandardAssets.Characters.ThirdPerson.ThirdPersonUserControl);
public var impact: AudioClip;

function OnTriggerEnter (obj : Collider) {
	if(obj.gameObject.tag=="Glomp")
	{
		if(tpc.GetComponent(GlompCharacter).GlompSize<=tpc.GetComponent(GlompCharacter).DoorSize)
		{
			var thedoor = gameObject.FindWithTag("SF_Door");
			thedoor.GetComponent.<Animation>().Play("open");
			yield WaitForSeconds (1);
			thedoor.GetComponent.<Collider>().enabled=false;
		}
		else
		{
			AudioSource.PlayClipAtPoint(impact, transform.position,PlayerPrefs.GetFloat("AudioVolume",1));
		}
	}
}

function OnTriggerExit (obj : Collider) {
	if(obj.gameObject.tag=="Glomp")
	{
		if(tpc.GetComponent(GlompCharacter).GlompSize<=tpc.GetComponent(GlompCharacter).DoorSize)
		{
			var thedoor = gameObject.FindWithTag("SF_Door");
			thedoor.GetComponent.<Animation>().Play("close");
			thedoor.GetComponent.<Collider>().enabled=true;
		}

	}
	
}