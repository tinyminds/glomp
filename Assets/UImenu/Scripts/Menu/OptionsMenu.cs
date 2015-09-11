using UnityEngine;
using System.Collections;
using UnityEngine.UI;
namespace FMG
{
	public class OptionsMenu : MonoBehaviour {



		public Text audioText;
		public string audioPrefix = "Audio: ";
		public string audioOff = "Off";

		public string audioOn = "On";

		public void Awake()
		{
			updateAudioText();
		}

		void updateAudioText()
		{
			float currentVol = Constants.getAudioVolume();
			if(currentVol==0)
			{
				audioText.text = audioPrefix  + audioOff;
			}else{
				audioText.text = audioPrefix  + audioOn;
				
			}

		}
		public void onCommand(string str)
		{
			if(str.Equals("DeleteData"))
			{
				PlayerPrefs.DeleteAll();
			}
			if(str.Equals("QualityNext"))
			{
				QualitySettings.IncreaseLevel();
			}
			if(str.Equals("QualityPrev"))
			{
				QualitySettings.DecreaseLevel();;
			}
			if(str.Equals("AudioToggle"))
			{
				float currentVol =  Constants.getAudioVolume();
				if(currentVol==0)
				{
					Constants.setAudioVolume(1);
				}else{
					Constants.setAudioVolume(0);
				}
				AudioVolume[] audioVolumes = (AudioVolume[])GameObject.FindObjectsOfType(typeof(AudioVolume));
				for(int i=0; i<audioVolumes.Length; i++)
				{
					audioVolumes[i].updateVolume();
				}

				updateAudioText();
			}
		}
	}
}