﻿using UnityEngine;
using System.Collections;
using UnityEngine.UI;

namespace FMG
	{
	public class LevelUnlocker : MonoBehaviour {
		public Text levelText;
		// Use this for initialization
		void Start () {

			levelText.text  = "Unlock level: " + Application.loadedLevel;
			//if(Application.loadedLevel< Constants.getMaxLevel() )
			//{
			//	levelText.color = Color.blue;
			//	Destroy(gameObject);
			//}
		}

		public void unlock()
		{
			print ("we are in unlock");
			int nextMaxWorld = Application.loadedLevel+1;
			//Constants.setMaxWorld(nextMaxWorld);
			Debug.Log ("unlock" + nextMaxWorld);
			Destroy(gameObject);

		}
		
		public void unlockLevel(int val)
		{
			int nextMaxLevel = val + 1;
			//Constants.setMaxLevel(nextMaxLevel);
			Debug.Log ("unlock" + nextMaxLevel);
			Destroy(gameObject);
			
		}
	}
}