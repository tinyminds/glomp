using UnityEngine;
using System.Collections;
using UnityEngine.UI;


namespace FMG
{
	public class MainMenu : MonoBehaviour {
		public GameObject mainMenu;
		public GameObject levelSelectMenu;
		public GameObject optionsMenu;
		public GameObject creditsMenu;

		public bool useLevelSelect = true;
		public bool useExitButton = true;

		public GameObject exitButton;


		public void Awake()
		{
			if(useExitButton==false)
			{
				exitButton.SetActive(false);
			}
		}

		public void onCommand(string str)
		{
			if(str.Equals("LevelSelect"))
			{
				Debug.Log ("LevelSelect");
				if(useLevelSelect)
				{
					Constants.fadeInFadeOut(levelSelectMenu,mainMenu);
					mainMenu.SetActive(false);
					levelSelectMenu.SetActive(true);
					creditsMenu.SetActive(false);
					optionsMenu.SetActive(false);
				}else{
					Application.LoadLevel(1);
				}
			}

			if(str.Equals("LevelSelectBack"))
			{
				Constants.fadeInFadeOut(mainMenu,levelSelectMenu);
				mainMenu.SetActive(true);
				levelSelectMenu.SetActive(false);
				creditsMenu.SetActive(false);
				optionsMenu.SetActive(false);

			}
			if(str.Equals("Exit"))
			{
				Application.Quit();
			}
			if(str.Equals("Credits"))
			{
				Application.LoadLevel(1);
				//Constants.fadeInFadeOut(creditsMenu,mainMenu);
				//mainMenu.SetActive(false);
				//levelSelectMenu.SetActive(false);
				//creditsMenu.SetActive(true);
				//optionsMenu.SetActive(false);
			}
			if(str.Equals("CreditsBack"))
			{
				Constants.fadeInFadeOut(mainMenu,creditsMenu);
				mainMenu.SetActive(true);
				levelSelectMenu.SetActive(false);
				creditsMenu.SetActive(false);
				optionsMenu.SetActive(false);
			}

			
			if(str.Equals("OptionsBack"))
			{
				Constants.fadeInFadeOut(mainMenu,optionsMenu);
				mainMenu.SetActive(true);
				levelSelectMenu.SetActive(false);
				creditsMenu.SetActive(false);
				optionsMenu.SetActive(false);

			}
			if(str.Equals("Options"))
			{
				Constants.fadeInFadeOut(optionsMenu,mainMenu);
				mainMenu.SetActive(false);
				levelSelectMenu.SetActive(false);
				creditsMenu.SetActive(false);
				optionsMenu.SetActive(true);
			}


		}
	}
}
