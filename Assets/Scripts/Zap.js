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
		tpc.GetComponent(GlompCharacter).GlompSize = (Mathf.Round(tpc.GetComponent(GlompCharacter).GlompSize * 10)/10) - 0.2;
		AudioSource.PlayClipAtPoint(impact, transform.position,PlayerPrefs.GetFloat("AudioVolume",1));
		tpc.transform.localScale = Vector3 (tpc.GetComponent(GlompCharacter).GlompSize,tpc.GetComponent(GlompCharacter).GlompSize,tpc.GetComponent(GlompCharacter).GlompSize);
		
		if((tpc.GetComponent(GlompCharacter).zapShieldB)&&(tpc.GetComponent(GlompCharacter).zapCounterB<=5))
		{
			print("zap shield number "+tpc.GetComponent(GlompCharacter).zapCounterB);
			tpc.GetComponent(GlompCharacter).zapCounterB = tpc.GetComponent(GlompCharacter).zapCounterB +1;
			var theZapShield : GameObject = GameObject.Find("ZapShield");
			//print((tpc.GetComponent(GlompCharacter).zapCounterB-1)*0.2f+" scale x");
			//print(tpc.GetComponent(GlompCharacter).zapCounterB-1);
			theZapShield.transform.localScale=Vector3(1-((tpc.GetComponent(GlompCharacter).zapCounterB-1)*0.2f),theZapShield.transform.localScale.y,1-((tpc.GetComponent(GlompCharacter).zapCounterB-1)*0.2f));
		}
		else
		{
			if(tpc.GetComponent(GlompCharacter).GlompHealth<=0.1)
			{tpc.GetComponent(GlompCharacter).GlompHealth=0;}
			else
			{tpc.GetComponent(GlompCharacter).GlompHealth = (Mathf.Round(tpc.GetComponent(GlompCharacter).GlompHealth * 10)/10) - 0.1;}
			
			tpc.transform.position.y = tpc.transform.position.y + 1.5;
		}
		if(tpc.GetComponent(GlompCharacter).zapCounterB==6)
		{
		GameObject.Find("ZapShield").GetComponent.<Renderer>().enabled=false;
		GameObject.Find("ZapShield").GetComponent.<Light>().enabled=false;
		tpc.GetComponent(GlompCharacter).zapShieldB=false;
		}
		var myCollider : CapsuleCollider = tpc.transform.GetComponent(CapsuleCollider);
    	myCollider.radius =myCollider.radius-0.002;
		Destroy (gameObject);
	}

 }