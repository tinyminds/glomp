// Add this script to an empty GameObject
// Add a model or object, the ratio of this unitType to the total amount of unitTypes, and/or materials in the inspector
// The object ratio manager calculates the amount of unitTypes in the world for each unitType
// On startup, one random gameObject with one or multiple random materials gets created
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class UnitGenerator : MonoBehaviour
{
		// List of unitTypes
		// Must be assigned in inspector
		public List <UnitType>		unitTypes = new List<UnitType> ();

		// List of materials
		// If none assigned, models will appear with their original material
		// If assigned, materials from the array will randomly get assigned to objects
		public List <Material>		unitMaterials = new List <Material> ();

		// If checked, objects with multiple meshes are colored with a different material for each mesh
		public bool 				isMulticolor;
		// If checked, each mesh in an object gets a different color
		public bool 				mashUpMaterials;
		[Range(0, 1)]
		public float 				mashUpRange = 1f;
		//If checked, the unit generator can be placed in the scene
		public bool 				standAlone = false;

		void Start ()
		{

				//Validate the given values in the inspector
				ValidateValues ();
				
				//If unit generator is placed in the scene a random mesh is spawned
				//If unit generator was assigned to the world generator it checks the ratio's
				int unitTypeIndex = 0;
				if (standAlone) {
						//Get random index
						unitTypeIndex = Random.Range (0, unitTypes.Count);
				} else {
						//Get index of next to spawn object
						unitTypeIndex = UnitRatioManager.GetNextUnitTypeIndex ();	
				}

				//Get random material from materials
				int rMat = Random.Range (0, unitMaterials.Count);

				//Create units depending on the added materials
				if (unitMaterials.Count != 0) {
						// Create objects with the added materials
						CreateUnitWithRandomMat (unitTypes [unitTypeIndex].gameObject, unitMaterials [rMat]);
				} else {
						//If no materials are added the original materials are used
						CreateUnit (unitTypes [unitTypeIndex].gameObject);
				}

				Destroy (this.gameObject);

		}

		// Check values
		void ValidateValues ()
		{
				if (unitTypes.Count == 0) {
						Debug.LogError ("No unit types are added to the list " + unitTypes);
				}

				mashUpRange = Mathf.Clamp (mashUpRange, 0, 1f);

				foreach (Material m in unitMaterials) {
						if (m == null)
								Debug.LogError ("Missing material in Unit Materials");
				}

		}

		// Creates an object assigned to the unitTypes list and adds a material from unitMaterials
		void CreateUnitWithRandomMat (GameObject go, Material m)
		{
				// Create new unit from unitTypes and set the UnitGenerator as parent
				GameObject unit = Instantiate (go, transform.position, transform.rotation) as GameObject;
				unit.transform.parent = transform.parent;

				// Add material
				FindMeshRendererAndAssignRandomMaterial (unit.transform, m);
		}

		// Creates an object without adding a new material
		void CreateUnit (GameObject go)
		{

				// Create new unit from unitTypes and set the UnitGenerator as parent
				GameObject unit = Instantiate (go, transform.position, transform.rotation) as GameObject;
				unit.transform.parent = transform.parent;

				// Check if object has own material
				FindMeshRendererAndCheckForMaterial (unit.transform);
		
		}

		// Recursively searched through an object and checks if a material is present
		void FindMeshRendererAndCheckForMaterial (Transform searchTroughObject)
		{
				//Check if object has mesh renderer
				if (searchTroughObject.GetComponent <MeshRenderer> () != null) {

						for (int i = 0; i < searchTroughObject.GetComponent<MeshRenderer> ().materials.Length; i++) {

								// If unassigned material found, log warning
								if (searchTroughObject.GetComponent<MeshRenderer> ().materials [i].name.Contains ("Default")) {
										Debug.LogWarning (searchTroughObject.name + " has no original material. A default material is assigned");
								}
						}
						return;
				} else {
			
						// If no mesh renderer is found, check in children in searchThroughObject
						foreach (Transform t in searchTroughObject) {
								FindMeshRendererAndCheckForMaterial (t);
						}
				}
		}
		 
		int depth = 0;
		//Recursively searches through all objects and colors anything with a mesh renderer
		void FindMeshRendererAndAssignRandomMaterial (Transform searchTroughObject, Material m)
		{

				// Current depth of the recursive method
				depth++;

				//If searchTroughObject has a mesh renderer, all it's materials will get set to new materals
				if (searchTroughObject.GetComponent <MeshRenderer> () != null) {

						// Warn for unnecessary use of Multicolor 
						if (depth == 1 && isMulticolor)
								Debug.LogWarning ("Multicolor can not be applied to an object with one mesh.");
							
						//Create a new array the size of searchThroughObject materials array
						Material[] newMaterials = new Material[searchTroughObject.GetComponent<MeshRenderer> ().materials.Length];

						for (int i = 0; i < searchTroughObject.GetComponent<MeshRenderer> ().materials.Length; i++) {

								// If isMulticolor is checked, a random material from unitMaterials gets added to newMaterials
								// If not checked, the array is filled with the same material
								Material tempMat = isMulticolor ? unitMaterials [Random.Range (0, unitMaterials.Count)] : m;
								
								if (mashUpMaterials) {
										tempMat = MashUpMaterial (tempMat);
								}

								newMaterials [i] = tempMat;
						}

						//Replace the old materials array for the new materials array
						searchTroughObject.GetComponent<MeshRenderer> ().materials = newMaterials;

						return;
				} else {
						
						//If no mesh renderer is found, check in children in searchThroughObject
						foreach (Transform t in searchTroughObject) {
								FindMeshRendererAndAssignRandomMaterial (t, m);
						}
				}
		}

		// Creates different shades of the materials' color
		Material MashUpMaterial (Material sourceMaterial)
		{
				Material m = new Material (sourceMaterial);
				float random = Random.Range (0f, mashUpRange);
				Color c = new Color (random, random, random);
				m.SetColor ("_Color", sourceMaterial.color + c);
				return m;
		}

}
