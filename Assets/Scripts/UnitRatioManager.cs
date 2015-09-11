// Processes assigned unit types in UnitGenerator
// Calculates the percentages of copy's of each unitType
// Keeps track of all to generate objects
using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class UnitRatioManager
{
		private static List<int> unitTypeIndexes = new List<int> ();
		private static int totalAmountToGenerate = 0;

		public static void ParseUnitTypes (List<UnitType> assignedUnitTypes)
		{
				ValidateRatios (assignedUnitTypes);

				int currentUnitTypeIndex = 0;

				foreach (UnitType u in assignedUnitTypes) {
						int amountToGenerate = CalculateAmount (u.ratio);

						for (int i = 0; i < amountToGenerate; i++) {
								unitTypeIndexes.Add (currentUnitTypeIndex);
						}

						currentUnitTypeIndex++;
				}
		}

		private static void ValidateRatios (List<UnitType> assignedUnitTypes)
		{
				float[] newRatios = new float[assignedUnitTypes.Count];
				float newRatio = 0f;
				float sum = 0; 

				for (int i = 0; i < assignedUnitTypes.Count; i++) {
						sum = sum + assignedUnitTypes [i].ratio;
				}

				if (sum == 0) {

						Debug.LogWarning ("All UnitTypes have a ratio of 0. The ratio's are set to default.");

						newRatio = 1f / assignedUnitTypes.Count;

						for (int i = 0; i < newRatios.Length; i++) {
								newRatios [i] = newRatio;
						}

				} else if (sum < 1) {

						float multiplyWith = 1 / sum;

						for (int i = 0; i < newRatios.Length; i++) {
								newRatio = assignedUnitTypes [i].ratio * multiplyWith;
								newRatios [i] = newRatio;
						}
				}

				if (sum < 1) {

						for (int i = 0; i < assignedUnitTypes.Count; i++) {
								assignedUnitTypes [i].ratio = newRatios [i];
						}
				}
		}

		public static int GetNextUnitTypeIndex ()
		{
				int r = Random.Range(0, unitTypeIndexes.Count);
				int nextUnitTypeIndex = unitTypeIndexes [r];
				unitTypeIndexes.RemoveAt(r);
				return nextUnitTypeIndex;
		}

		//Calculates amount with given ratio
		private static int CalculateAmount (float ratio)
		{
				int newAmount = Mathf.CeilToInt (totalAmountToGenerate * ratio);
				return newAmount;
		}

		public static void SetTotalAmountToGenerate (int amount)
		{
				totalAmountToGenerate = amount;
		}

}
