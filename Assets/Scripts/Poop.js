#pragma strict

function Start () {

}

function Update () {

}

function OnCollisionEnter(collision: Collision) 
{
	if(collision.gameObject.name=="Quad")
	{
		var t = 0.0f;
   		var start = new Vector3( 0.47f, 0.29f, 0.48f );
      	 var end = Vector3( 0.01f, 0.001f, 0.01f );
   		while( t < 0.6f )
    	{
        	t += ( Time.deltaTime / 2.0f );
        	gameObject.transform.localScale = Vector3.Lerp( start, end, t );
        	yield;
    	}
		Destroy (gameObject);
	}
 }