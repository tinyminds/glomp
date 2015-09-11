using UnityEngine;
using System.Collections;
namespace FMG
{
	public class LevelLevelButton : MonoBehaviour {
		public int WorldInt=0;
		public int levelInt=0;

		public void onClick()
		{
			print ("click");	
			PlayerPrefs.SetInt("Game_LEVEL_"+WorldInt,levelInt);
				PlayerPrefs.SetInt("WORLD_LEVEL",WorldInt);
			print ("loading");	
			Application.LoadLevelAsync(WorldInt+1);
		}

	}
}