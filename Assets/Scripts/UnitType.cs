// Stores the mesh and 
// the percentage of copy's the generator will create
// according to the density defined in GridGenerator
using UnityEngine;
using System.Collections;

[System.Serializable]
public class UnitType
{
	// Model or gameObject that gets instantiated
	public GameObject gameObject;

	// A value from 0 to 1 representing the percentage of the world that consists of this object
	// Example: ratio = 0.5 means 50% of all units will be this unit
	[Range(0, 1)]
	public float ratio;

	public UnitType() { }

}
