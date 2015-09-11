// Add this script to an empty gameObject
// Adjust the variables as desired
// On startup, a grid of gameObjects will be created
using UnityEngine;
using System.Collections;
//in here i could put a level number, this would give the percentages of food/pain/pill/health
public class GridGenerator : MonoBehaviour
{
		// Orientation of the grid
		// Horizontal generates postions over the X-axis and Z-axis
		// Vertical generates postions over the X-axis and Y-axis
		public enum Orientation
		{ 
				horizontal,
				vertical 
		}

		// Rotation for all generated objects
		// If horizontal orientation, objects are rotated around the Y-axis
		// If vertical orientation, objects are rotated around the Z-axis
		public enum RotationType
		{
				none,
				degrees90,
				random
		}

		// GameObject that will get copied on the world grid
		public 		GameObject 		spawnObject;
	// Creates a vertical or horizontal grid
		public 		Orientation 	orientation;
		// NOTE: UnitSizeWidth and UnitSizeLength do NOT scale the object
		// they define the dimensions of the space in which each object is placed
		public 		float 			tileSizeWidth;
		public		float			tileSizeLength;
		// WidthInUnits and LengthInUnits define the dimensions of the world grid in units
		public 		int 			WidthInTiles;
		public 		int 			LengthInTiles;
		// Delays the spawning of objects. 
		public 		float 			delay;
		// Rotate the objects
		public 		RotationType	rotationSpawnObject;
		// Defines the density of the world
		[Range(0, 1)]
		public 		float 			density = 1f;
		// If checked, a simple border is added to the worldedges, adjust bounderieHeight to adjust the border height
		public 		bool 			generateBounderies = false;
		public 		float 			bounderieHeight;
		public 		float 			bounderieWallWidth = 0;
		// If checked, a background is added to the world and the background material can be adjusted
		public 		bool 			generateBackground = false;
		public 		Material[]      backgroundMaterial;

		public 		GameObject		door;
		// If bounderies and/or background is created, the padding can be set to add space between the objects and the worldedge
		public 		float			padding = 0;

		// Private variables
		private 	float 			_posX, _posYZ = 0;
		private 	float[,] 		_positions;
		private 	bool[] 			_generated;
		private 	int 			_worldSize;
		private 	float 			_bounderieWidth;
		private 	float 			_bounderieLength;
		private 	float 			_distFromMid = 0;
		private 	int 			_currentSpawnObject;
		private 	int 			_amountGenerated;
		private 	int 			_amountToGenerate;
		private 	float 			ThisLevel;

		void Awake (){
		GameObject persistantGameObject = GameObject.Find("PersistantVars");
		ThisLevel = persistantGameObject.GetComponent<Persistance>().TheLevel;
		print ("the level from grid generator" + ThisLevel);
		density = density + (ThisLevel/100);
	}
	
		void Start ()
		{
				
				// Check if given values are valid
				//print (density);
				ValidateAllValues ();

				// Calculate variables with the given values
				_worldSize = WidthInTiles * LengthInTiles;
				_bounderieWidth = (WidthInTiles * tileSizeWidth) + (padding * 2);
				_bounderieLength = (LengthInTiles * tileSizeLength) + (padding * 2);

				// Create array of booleans to check if unit is spawned
				_generated = new bool[_worldSize];

				// Calculate density
				SetAmountToGenerate ();

				// If the given spanwObject is a Unit Generator 
				// the amount to generate gets set in the ObjectRatioManager
				// and the objects and their ratio's are parsed to the ObjectRatioManager
			
					if (spawnObject.GetComponent<UnitGenerator> () != null) {
						UnitRatioManager.SetTotalAmountToGenerate (_amountToGenerate);
						UnitRatioManager.ParseUnitTypes (spawnObject.GetComponent<UnitGenerator> ().unitTypes);
					}

				

				// Create a array for all possible positions
				CalculatePositions ();

				// Check whether the world spawns at once or with a delay
				if (delay != 0) {
						StartCoroutine ("SpawnUnitsWithDelay");
				} else {
						SpawnUnitsAtOnce ();
				}
				
				// If checked add bounderies
				if (generateBounderies)
						CreateBounderies ();

				// If checked add a background
				if (generateBackground)
						CreateBackground ();
		}

		// Clamp values and give warnings
		void ValidateAllValues ()
		{
				//Clamp all values
				ClampValues ();

				//Warn for empty scene
				if (density == 0)
						Debug.LogWarning ("Density is 0. No objects get spawned.");
				if (tileSizeWidth == 0 && tileSizeLength == 0)
						Debug.LogWarning ("unitSizeWidth and UnitSizeLength are both 0. No objects get spawned.");
		}

		// Clamp values to avoid too big world
		void ClampValues ()
		{
				density = Mathf.Clamp (density, 0, 1);
				tileSizeWidth = Mathf.Clamp (tileSizeWidth, 0, 1000);
				tileSizeLength = Mathf.Clamp (tileSizeLength, 0, 1000);
				WidthInTiles = Mathf.Clamp (WidthInTiles, 1, 1000);
				LengthInTiles = Mathf.Clamp (LengthInTiles, 1, 1000);
				padding = Mathf.Clamp (padding, 0, 1000);
				bounderieHeight = Mathf.Clamp (bounderieHeight, 0, 10000);
				bounderieWallWidth = Mathf.Clamp (bounderieWallWidth, 0, 10000);
				
		}

		// Calculate density of the objects that get spawned
		void SetAmountToGenerate ()
		{
				_amountToGenerate = Mathf.CeilToInt ((float)_worldSize * density);

		}

		// Generate an array of arrays with position values, calculated with the given dimensions of the grid

		//make a space to spawn creature grid width - boundry by grid width - (boundy + padding)
		void CalculatePositions ()
		{

				// Create two dimensional array for positions on the grid
				_positions = new float[_worldSize, 2];

				// Calculate start position of the y coordinate or z coordinate depending on the orientation
				_posYZ = - (LengthInTiles + 1) * tileSizeLength / 2;

				// Loop trough _positions and add x and y/z coordinates
				for (int i = 0; i < _worldSize-2; i++) {

						_posX = ((i % WidthInTiles) * tileSizeWidth) - (WidthInTiles - 1) * tileSizeWidth / 2;
						
						if (i % WidthInTiles == 0)
								_posYZ += tileSizeLength;

						_positions [i, 0] = _posX;
						_positions [i, 1] = _posYZ;
						//print (_posX + " pos x");
						//print (_posYZ + " pos yz");
				}
		}

		//If delay is not 0, this co-routine starts
		IEnumerator SpawnUnitsWithDelay ()
		{
				int currentUnitIndex = Random.Range (0, _worldSize);
		
				while (true) {

						//If already generated increase curUnitIndex
						while (_generated [currentUnitIndex]) {

								int tempInt = currentUnitIndex;
								tempInt += 1;
								tempInt = ValidateSpawnIndexNumber (tempInt);
								currentUnitIndex = tempInt;
						}

						CreateUnit (currentUnitIndex);
						currentUnitIndex += Random.Range (1, _worldSize);
						currentUnitIndex = ValidateSpawnIndexNumber (currentUnitIndex);

						//Check if density is reached, if so stop spawning
						if (_amountGenerated == _amountToGenerate) {
								StopCoroutine ("SpawnUnitsWithDelay");
						}
			
						yield return new WaitForSeconds (delay);
				}
		}

		// If delay is 0, all units spawn at once
		void SpawnUnitsAtOnce ()
		{
				int currentUnitIndex = Random.Range (0, _worldSize);

				// Spawn until density is reached
				while (_amountGenerated != _amountToGenerate) {

						// Make sure randomly generated currentUnitIndex is smaller then the positions-array size
						currentUnitIndex = ValidateSpawnIndexNumber (currentUnitIndex);

						// Check if unit is already generated
						if (!_generated [currentUnitIndex]) {
								// If not generated the unit gets generated
								CreateUnit (currentUnitIndex);
								currentUnitIndex = currentUnitIndex + Random.Range (1, _worldSize);
				
						} else {
								// If already generated increase currentUnitIndex
								currentUnitIndex += 1;
						}
				}
		}

		// This is where an object is actually created in the scene
		void CreateUnit (int i)
		{
				// Mark unit as generated
				_generated [i] = true;
				// Increase amount currently generated
				_amountGenerated++;

				Vector3 newPosition = new Vector3 (0, 0, 0);

				// Assign calculated positions from the positions array to newPosition according to the orientation
				switch (orientation) {
				case Orientation.vertical:
						newPosition = new Vector3 (_positions [i, 0], _positions [i, 1], -spawnObject.transform.position.y);
						break;
				case Orientation.horizontal:
						newPosition = new Vector3 (_positions [i, 0], spawnObject.transform.position.y+0.5f, _positions [i, 1]);
						//print (spawnObject.transform.position.y);			
						break;
				}

				// Create the assigned spawnObject and set WorldGenerator as parent
				GameObject newSpawnObject = Instantiate (spawnObject, newPosition, spawnObject.transform.localRotation) as GameObject;
				newSpawnObject.transform.parent = transform;

				ApplyRotation (newSpawnObject, newPosition);
		}

		// Rotates object according to the rotationType defined in the inspector
		void ApplyRotation (GameObject go, Vector3 rotationPoint)
		{
				// Set angle for the rotation 
				int spawnObjectRotationAngle = 0;
	
				switch (rotationSpawnObject) {
				case RotationType.none:
						// Angle is 0
						spawnObjectRotationAngle = 0;
						break;
				case RotationType.degrees90:
						// Angle is 0, 90, 180 or 270
						spawnObjectRotationAngle = 90 * Random.Range (0, 4);
						break;
				case RotationType.random:
						// Angle is random
						spawnObjectRotationAngle = Random.Range (0, 360);
						break;
				}
	
				// Apply rotation to the object according to the orientation
				if (orientation == Orientation.horizontal)
						go.transform.RotateAround (rotationPoint, Vector3.up, spawnObjectRotationAngle);
				if (orientation == Orientation.vertical)
						go.transform.RotateAround (rotationPoint, Vector3.forward, spawnObjectRotationAngle);
		}
	
		// Create bounderies if generateBounderies is checked
		void CreateBounderies ()
		{
				
				for (int i = 0; i < 4; i++) {

						// Create four cubes and set WorldGenerator as their parent
						GameObject bounderie = GameObject.CreatePrimitive (PrimitiveType.Cube);
						bounderie.transform.parent = transform;

						// Calculate top- and bottombounderies' position and scale
						if (i % 2 == 0) {
	
								_distFromMid = (i == 0) ? _bounderieLength / 2 : -(_bounderieLength / 2);

								if (orientation == Orientation.horizontal) {
								if(i==0)
								{	
									float DoorXPos = Random.Range(-((_bounderieWidth/2)-4f),((_bounderieWidth/2)-2f));
									Instantiate(door,new Vector3(DoorXPos, 0.5f,(_distFromMid)),Quaternion.identity);
									bounderie.transform.localScale = new Vector3 (0, 0, 0);

								}
								else
								{
									bounderie.transform.position = new Vector3 (0, bounderieHeight / 2, _distFromMid);
									bounderie.transform.localScale = new Vector3 (_bounderieWidth, bounderieHeight, bounderieWallWidth);
									bounderie.GetComponent<MeshRenderer> ().enabled = false;
								}
								
						}
								if (orientation == Orientation.vertical) {
								bounderie.transform.position = new Vector3 (0, _distFromMid, -bounderieHeight / 2);
								bounderie.transform.localScale = new Vector3 (_bounderieWidth, bounderieWallWidth, bounderieHeight);
								bounderie.GetComponent<MeshRenderer> ().enabled = false;
								}
						}

						// Calculate left- and rightbounderies' position and scale
						if (i % 2 == 1) {

								_distFromMid = (i == 1) ? _bounderieWidth / 2 : -_bounderieWidth / 2;

								if (orientation == Orientation.horizontal) {
										bounderie.transform.localScale = new Vector3 (bounderieWallWidth, bounderieHeight, _bounderieLength);
										bounderie.transform.position = new Vector3 (_distFromMid, bounderieHeight / 2, 0);
										bounderie.GetComponent<MeshRenderer> ().enabled = false;
								}

								if (orientation == Orientation.vertical) {
									bounderie.transform.localScale = new Vector3 (bounderieWallWidth, _bounderieLength, bounderieHeight);
									bounderie.transform.position = new Vector3 (_distFromMid, 0, -bounderieHeight / 2);
									bounderie.GetComponent<MeshRenderer> ().enabled = false;
								}
						}
				}

		}

		// Create background if generateBackground is checked
		void CreateBackground ()
		{

				// Create quad and set WorldGenerator as parent
				GameObject background = GameObject.CreatePrimitive (PrimitiveType.Quad);
				background.transform.parent = transform;
				// Scale background
				background.transform.localScale = new Vector3 (_bounderieWidth, _bounderieLength, 1);

				// Rotate 90 degrees if orientation is horizontal
				if (orientation == Orientation.horizontal) {
						background.transform.RotateAround (transform.position, Vector3.left, -90);
				}


		background.GetComponent<MeshRenderer> ().material = backgroundMaterial[(int)ThisLevel-1];

		}

		// Make sure the index of the next to spawn unit is smaller than the array size
		int ValidateSpawnIndexNumber (int index)
		{
				if (index >= _worldSize) {
						index -= _worldSize;
				}
				return index;
		}
}
