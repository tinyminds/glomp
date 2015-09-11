#pragma strict
private var tpc : UnityStandardAssets.Characters.ThirdPerson.ThirdPersonUserControl;
tpc = GameObject.FindObjectOfType(UnityStandardAssets.Characters.ThirdPerson.ThirdPersonUserControl);
function Start () {

}

function Update () {

}

function OnCollisionEnter(collision: Collision) 
{
	
	if(collision.gameObject.tag=="Glomp")
	{
		//make it a bunch of random splat noises/
		var impact : AudioClip = tpc.GetComponent(GlompCharacter).impact;
		tpc.GetComponent(GlompCharacter).GlompSize =  (Mathf.Round(tpc.GetComponent(GlompCharacter).GlompSize * 10)/10) + 0.2;
		//absorbing animation
		tpc.transform.localScale = Vector3 (tpc.GetComponent(GlompCharacter).GlompSize,tpc.GetComponent(GlompCharacter).GlompSize,tpc.GetComponent(GlompCharacter).GlompSize);
		var myCollider : CapsuleCollider = tpc.transform.GetComponent(CapsuleCollider);
    	myCollider.radius =myCollider.radius+0.002;
		AudioSource.PlayClipAtPoint(impact, tpc.transform.position,PlayerPrefs.GetFloat("AudioVolume",1));
		Destroy (gameObject);
		if(tpc.GetComponent(GlompCharacter).scoreMultiplierB)
		{
		print("score multiplier a go go");
		tpc.GetComponent(GlompCharacter).GlompScore = tpc.GetComponent(GlompCharacter).GlompScore + 2;
		}
		else
		{tpc.GetComponent(GlompCharacter).GlompScore = tpc.GetComponent(GlompCharacter).GlompScore + 1;}
		tpc.GetComponent(GlompCharacter).BonusCounter = tpc.GetComponent(GlompCharacter).BonusCounter + 1;
	}
 }