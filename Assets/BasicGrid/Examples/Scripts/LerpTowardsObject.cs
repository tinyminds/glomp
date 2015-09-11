using UnityEngine;
using System.Collections;

public class LerpTowardsObject : MonoBehaviour {

	public Transform targetObject;
	private Transform lerpObject;
	public float speed = 5;
	
	void Start() 
	{
		speed = speed/100;
		lerpObject = transform;
	}

	void Update() 
	{
		transform.position = Vector3.Lerp(lerpObject.position, targetObject.position, speed);
	}
}
