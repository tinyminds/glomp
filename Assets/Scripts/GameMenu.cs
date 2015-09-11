using UnityEngine;
using System.Collections;
namespace FMG
	{
	public class GameMenu : MonoBehaviour {
		public GameObject pauseMenu;
		public GameObject levelStart;
		public GameObject gameMenu;	
		public GameObject resultMenu;
		public GameObject deadMenu;	
		public GameObject wonMenu;
		public GameObject finalMenu;
		public GameObject bonusMenu;
		public UnityEngine.UI.Text EndWorldScore;
		public UnityEngine.UI.Text EndGameScore;
		public UnityEngine.UI.Text EndLevelScore;
		public UnityEngine.UI.Text LevelStartGoal;
		public UnityEngine.UI.Image CollectedStar;
		public BaseImage fadeOutScript;
		private bool m_gameover=false;
		public bool pauseWasPressed = false;
		private GameObject persistantGameObject;
		private int ThisLevel;
		private int ThisWorld;
		private int gotCollectedStar;
		private bool hasWonGame;
		private bool isNowDead;
		public void pausePressed ()
		{
			if(!pauseMenu.activeSelf)
			{
				Time.timeScale = 0;
				Constants.fadeInFadeOut(pauseMenu,gameMenu);
				pauseMenu.SetActive(true);	
				levelStart.SetActive(false);
				resultMenu.SetActive(false);
				deadMenu.SetActive(false);
				wonMenu.SetActive(false);
				finalMenu.SetActive(false);
				bonusMenu.SetActive(false);
				pauseWasPressed = false;
			}
			else
			{
				Time.timeScale = 1;
				Constants.fadeInFadeOut(gameMenu,pauseMenu);
				pauseMenu.SetActive(false);
				pauseWasPressed = true;
			}
		}

		public IEnumerator Do (int count, int menuID)
		{
			yield return new WaitForSeconds (1.5f);
			for(int i = 0;i <= count; i++)
			{
				if(menuID==1){EndLevelScore.text = "Level Score: "+i++;}
				if(menuID==2){EndWorldScore.text = "World Score: "+i++;}
				if(menuID==3){EndGameScore.text = "World Score: "+i++;}
				yield return new WaitForSeconds (1/count);
			}

			if (menuID == 1) 
			{
				EndLevelScore.text = "Level Score: " + count;
			}
			if (menuID == 2) 
			{
				EndWorldScore.text = "World Score: " + count;
			}
			if (menuID == 3) 
			{
				EndGameScore.text = "World Score: " + count;
			}
		}
		public void bonusChosen(int bonusNum)
		{
			//print ("bonus " + bonusNum);
			persistantGameObject.GetComponent<Persistance> ().BonusNumClicked = bonusNum;
		}

		public void bonusClicked(int bonusNum)
		{
			//print ("bonus huh? makey worky" + bonusNum);
			persistantGameObject.GetComponent<Persistance> ().BonusNumInBar = bonusNum;
			persistantGameObject.GetComponent<Persistance> ().StoreBonusNumInBar = bonusNum;
		}

		public void EndOfLevelSetPressed ()
		{

			Constants.fadeInFadeOut(resultMenu,gameMenu);
			resultMenu.SetActive(true);
			levelStart.SetActive(false);
			pauseMenu.SetActive(false);
			deadMenu.SetActive(false);
			wonMenu.SetActive(false);
			finalMenu.SetActive(false);
			bonusMenu.SetActive(false);
			StartCoroutine(Do (persistantGameObject.GetComponent<Persistance> ().TheGlompScore,2));
		}


		public void StartLevelPressed ()
		{
			Constants.fadeInFadeOut(levelStart,gameMenu);
			levelStart.SetActive(true);
			resultMenu.SetActive(false);
			pauseMenu.SetActive(false);
			deadMenu.SetActive(false);
			wonMenu.SetActive(false);
			finalMenu.SetActive(false);
			bonusMenu.SetActive(false);
			persistantGameObject.GetComponent<Persistance> ().ShowLevelStartPopUp=false;
			gotCollectedStar = PlayerPrefs.GetInt ("world_" + ThisWorld + "_level_" + ThisLevel + "_gotGoldDrop", 0);
			//world{n}_level{n}_gotGoldDrop = 1/0
			if (gotCollectedStar == 1) 
			{
				persistantGameObject.GetComponent<Persistance> ().gotGold = 1;
				CollectedStar.color = Color.yellow;
			}
			else
			{
				LevelStartGoal.text = "Collect the gold star.";
			}
		}

		public void ButtonStartLevel ()
		{
			Constants.fadeInFadeOut(gameMenu,levelStart);
			levelStart.SetActive(false);
			Time.timeScale = 1;
		}
		public void EndOfGameSetPressed ()
		{
			Constants.fadeInFadeOut(finalMenu,gameMenu);
			finalMenu.SetActive(true);
			levelStart.SetActive(false);
			resultMenu.SetActive(false);
			deadMenu.SetActive(false);
			wonMenu.SetActive(false);
			pauseMenu.SetActive(false);
			bonusMenu.SetActive(false);
			StartCoroutine(Do (persistantGameObject.GetComponent<Persistance> ().TheGlompScore,3));
		}

		public void isDead ()
		{
			Constants.fadeInFadeOut(deadMenu,gameMenu);
			deadMenu.SetActive(true);	
			levelStart.SetActive(false);
			resultMenu.SetActive(false);
			pauseMenu.SetActive(false);
			wonMenu.SetActive(false);
			finalMenu.SetActive(false);
			bonusMenu.SetActive(false);
		}

		public void wonLevel ()
		{
			Constants.fadeInFadeOut(wonMenu,gameMenu);
			wonMenu.SetActive(true);
			levelStart.SetActive(false);
			resultMenu.SetActive(false);
			deadMenu.SetActive(false);
			pauseMenu.SetActive(false);
			finalMenu.SetActive(false);
			bonusMenu.SetActive(false);
			StartCoroutine(Do (persistantGameObject.GetComponent<Persistance> ().TheGlompScore,1));
		}


		public void menuPressed()
		{
			StartCoroutine(useFadeOut(0));
		}

		public void deadRetry()
		{
			StartCoroutine(useFadeOut(Application.loadedLevel));
		}

		public void nextLevel()
		{
			int nextMaxLevel = persistantGameObject.GetComponent<Persistance>().TheLevel;
			Constants.setMaxLevel(nextMaxLevel, (Application.loadedLevel-1));
			StartCoroutine(useFadeOut(Application.loadedLevel));
		}

		public void sceneLevel()
		{
			int nextMaxWorld = Application.loadedLevel;
			Constants.setMaxWorld(nextMaxWorld);
			Constants.setMaxLevel(1, nextMaxWorld);
			persistantGameObject.GetComponent<Persistance>().TheLevel=1;
			persistantGameObject.GetComponent<Persistance>().isDead=false;
			persistantGameObject.GetComponent<Persistance>().hasWon=false;
			persistantGameObject.GetComponent<Persistance>().TheGlompScore = 0;
			persistantGameObject.GetComponent<Persistance>().TheBonusCounter = 0;
			persistantGameObject.GetComponent<Persistance>().TheBonusSliderValue = 0;
			persistantGameObject.GetComponent<Persistance>().StoreBonusNumInBar = 0;
			StartCoroutine(useFadeOut(Application.loadedLevel+1));
		}

		public void Awake()
		{
			persistantGameObject = GameObject.Find("PersistantVars");
			Screen.orientation = ScreenOrientation.AutoRotation;
		}

		public void Update()
		{

			ThisLevel = persistantGameObject.GetComponent<Persistance>().TheLevel;
			ThisWorld = persistantGameObject.GetComponent<Persistance>().TheWorld;
			isNowDead = persistantGameObject.GetComponent<Persistance>().isDead;
			hasWonGame = persistantGameObject.GetComponent<Persistance>().hasWon;
			if (persistantGameObject.GetComponent<Persistance> ().ShowLevelStartPopUp) 
			{
				StartLevelPressed();
			}

			if (isNowDead)
			{
				isDead();
				persistantGameObject.GetComponent<Persistance>().isDead=false;
			}
			//change this 10 to a var in grid generator
			if ((ThisLevel <= persistantGameObject.GetComponent<Persistance> ().LevelsInWorld) && (hasWonGame)) {
				//print ("the level in update in gm" + ThisLevel);
				wonLevel ();
				persistantGameObject.GetComponent<Persistance> ().hasWon = false;
			} 
			//and this
			else if ((ThisLevel > persistantGameObject.GetComponent<Persistance> ().LevelsInWorld) && (hasWonGame)) {
				//print(Application.levelCount + "what level now");
				//print(persistantGameObject.GetComponent<Persistance> ().TheWorld + "world num");
				if((Application.levelCount-2)==persistantGameObject.GetComponent<Persistance> ().TheWorld)
				{
					EndOfGameSetPressed ();
				}
				else
				{
					PlayerPrefs.SetInt("WORLD_LEVEL",persistantGameObject.GetComponent<Persistance> ().TheWorld+1);
					EndOfLevelSetPressed ();
				}
				m_gameover = true;
				persistantGameObject.GetComponent<Persistance> ().hasWon = false;
			}

		}

		public void onCommand(string str)
		{
			Debug.Log ("onCommandhh"+str);
			if(str.Equals("Restart"))
			{

				StartCoroutine(useFadeOut(Application.loadedLevel));
			}
			if(str.Equals("unlock"))
			{
				m_gameover=true;
				Time.timeScale = 1;
				Constants.fadeInFadeOut(resultMenu,gameMenu);

			}
			if(str.Equals("MainMenu"))
			{
				StartCoroutine(useFadeOut(0));
				print ("load main menu");
			}
			if(str.Equals("Next"))
			{
				int next = Application.loadedLevel+1;
				Debug.Log ("next " + next);
				StartCoroutine(useFadeOut(next));
			}

		}
		public IEnumerator useFadeOut(int sceneToLoad)
		{
			Time.timeScale = 1;
			
			if(fadeOutScript)
			{
				fadeOutScript.play();

				yield return new WaitForSeconds(fadeOutScript.playWaitTime);
			}
			Application.LoadLevel(sceneToLoad);
		}

	}
}