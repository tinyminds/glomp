using UnityEngine;
using System.Collections;

public class FreezeAxis : MonoBehaviour 
{
	public bool freezeX;
	public bool freezeY;
	public bool freezeZ;

	private float fixedX = 0;
	private float fixedY = 0;
	private float fixedZ = 0;
	
	void Start () 
	{
		if(freezeX) fixedX = transform.position.x;
		if(freezeY) fixedY = transform.position.y;
		if(freezeZ) fixedZ = transform.position.z;
	}

	void Freeze() 
	{
		float newX, newY, newZ;
		newX = freezeX ? fixedX : transform.position.x;
		newY = freezeY ? fixedY : transform.position.y;
		newZ = freezeZ ? fixedZ : transform.position.z;
		
		transform.position = new Vector3(newX, newY, newZ);
	}
	
	void Update ()
	{
		Freeze();
	}
}
