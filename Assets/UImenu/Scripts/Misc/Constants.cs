using UnityEngine;
using System.Collections;

namespace FMG 
{
	
	public class Constants  : MonoBehaviour 
	{
		public static float getAudioVolume()
		{
			return PlayerPrefs.GetFloat("AudioVolume",1);
		}
		public static void setAudioVolume(float vol)
		{
			 PlayerPrefs.SetFloat("AudioVolume",vol);
			 PlayerPrefs.Save();
		}
		public static int getMaxLevel(int val)
		{
			return PlayerPrefs.GetInt("MAX_LEVEL_"+val,0);
		}
		public static int getMaxWorld()
		{
			return PlayerPrefs.GetInt("MAX_World",1);
		}
		public static void setMaxLevel(int val, int val2)
		{
			print (val + " max level set in player prefs in world number:"+val2);
			int curMaxLevel = getMaxLevel(val2);
			if(val > curMaxLevel)
			{
				PlayerPrefs.SetInt("MAX_LEVEL_"+val2,val);
				PlayerPrefs.Save();
			}
		}

		public static void setMaxWorld(int val)
		{
			print (val + " max world set in player prefs");
			
			int curMaxWorld = getMaxWorld();
			if(val > curMaxWorld)
			{
				PlayerPrefs.SetInt("MAX_World",val);
				PlayerPrefs.Save();
			}
		}

		public static void slideOut(GameObject go,bool slideOut)
		{
			if(go)
			{
				Animator animator = go.GetComponent<Animator>();
				if(animator)
				{
					animator.SetBool("SlideOut",slideOut);
				}

			}
			
		}


		public static void fadeInFadeOut(GameObject go1,GameObject go2)
		{
			if(go1)
			{
				go1.SetActive(true);
			}

			if(go2)
			{
				go2.SetActive(true);
			}

			slideOut(go1,true);
			slideOut(go2,false);
			
		}	
	}
}