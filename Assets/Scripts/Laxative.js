#pragma strict
private var tpc : UnityStandardAssets.Characters.ThirdPerson.ThirdPersonUserControl;
public var poop : GameObject;
tpc = GameObject.FindObjectOfType(UnityStandardAssets.Characters.ThirdPerson.ThirdPersonUserControl);
function Start () {

}

function Update () {

}

function OnCollisionEnter(collision: Collision) 
{
	if(collision.gameObject.tag=="Glomp")
	{
	
			tpc.GetComponent(GlompCharacter).GlompSize =  (Mathf.Round(tpc.GetComponent(GlompCharacter).GlompSize * 10)/10) - 0.2;
			GameObject.Instantiate(poop,tpc.transform.position,tpc.transform.rotation);
			tpc.transform.localScale = Vector3 (tpc.GetComponent(GlompCharacter).GlompSize,tpc.GetComponent(GlompCharacter).GlompSize,tpc.GetComponent(GlompCharacter).GlompSize);
			var myCollider : CapsuleCollider = tpc.transform.GetComponent(CapsuleCollider);
    		myCollider.radius =myCollider.radius-0.002;
			Destroy (gameObject);
		
	}
 }