using UnityEngine;
using System.Collections;
using UnityEngine.UI;
namespace FMG
	{
	public class LevelSelect : MonoBehaviour {

		private GameObject constantsGameObject;
		public GameObject levelButton;
		public GameObject levellevelButton;
		public GameObject levelStar;
		public Vector3 startPos = new Vector3(0,0,0);
		public Vector3 offset = new Vector3(0,0,0);
		private Vector3[] holdPos;
		private Vector3 starPos;
		private string[] starPosStr;
		private Color levelButColour;
		public int nomPerRow = 1;
		public int nomPerCol = 1;
		public int levelIndex = 0;
		private int m_nomPages = 0;
		private GameObject[] tooManyGameObject;

		private GameObject[] m_pages;

		public bool useLockedButtons = true;

		private ButtonToggle m_buttonToggle;

		private Button[] m_orgButtons;
		void Awake () {
           
           tooManyGameObject = GameObject.FindGameObjectsWithTag("PersistantVars");
			constantsGameObject = GameObject.Find("Constants");
            if(tooManyGameObject.Length>1)
            {Destroy(tooManyGameObject[1]);}
            //Text texttemp = gameObject.GetComponentInChildren<Text>();
            //texttemp.text = Application.levelCount + "";
            //levelButton = Resources.Load("Button") as GameObject;
            int cellsPerPage = 1;//nomPerCol * nomPerRow;
            print(Application.levelCount);
			int tmpNomLevels = Application.levelCount-2-Application.loadedLevel;
      
            while (tmpNomLevels > 0)
			{
				tmpNomLevels-=cellsPerPage;
				m_nomPages++;
			}
			m_pages = new GameObject[m_nomPages];
			int offset = 0;
			for(int i=0 ;i<m_nomPages; i++)
			{
				m_pages[i] = spawnButtons(offset);
				if(i!=0)
				{
					m_pages[i].SetActive(false);
				}
				offset += cellsPerPage;
			}
			m_buttonToggle = gameObject.GetComponent<ButtonToggle>();
			m_orgButtons = m_buttonToggle.buttons;
			changePage(m_pages[0]);


		}
		public void onCommand(string str)
		{
			if(str.Equals("LevelSelectNext"))
			{
				m_pages[levelIndex].SetActive(false);
				levelIndex++;
				if(levelIndex>m_pages.Length-1)
				{
					levelIndex=0;
				}

				m_pages[levelIndex].SetActive(true);
				changePage(m_pages[levelIndex]);

			}
			
			if(str.Equals("LevelSelectPrev"))
			{
				m_pages[levelIndex].SetActive(false);
				levelIndex--;
				if(levelIndex<0)
				{
					levelIndex=m_pages.Length-1;
				}
				m_pages[levelIndex].SetActive(true);
				changePage(m_pages[levelIndex]);
			}
			//Debug.Log ("levelIndex " + levelIndex);
		}
		void changePage(GameObject go)
		{
			Button[] pageButtons = go.GetComponentsInChildren<Button>();
			int n = pageButtons.Length;
			int m = m_orgButtons.Length; 
			Button[] newButtons = new Button[m+n];
			int k=0;
			for(int i=0; i<pageButtons.Length; i++){
				newButtons[k] = pageButtons[i];
				k++;
			}
			for(int i=0; i<m; i++)
			{
				newButtons[k] = m_orgButtons[i];
				k++;
			}
			m_buttonToggle.buttons = newButtons;
		}
		GameObject spawnButtons(int indexoffset)
		{
			int n = indexoffset + 1;
			GameObject newPage = new GameObject();
			newPage.transform.parent = transform;
			newPage.transform.localPosition =  Vector3.zero;
			newPage.transform.localScale=new Vector3(1,1,1);


			Vector3 pos = startPos;
			//for(int i=0; i<nomPerRow; i++)
			//{
				pos.x = 10;
				pos.y = 20;
				//for(int j=0; j<nomPerCol; j++)
				//{
					if (n < Application.levelCount - 1 - Application.loadedLevel) {
				GameObject newObject = (GameObject)Instantiate (levelButton, Vector3.zero, Quaternion.identity);
				newObject.transform.SetParent (newPage.transform);

			//	Button button = newObject.GetComponent<Button> ();
			//	if (useLockedButtons && n > Constants.getMaxLevel ()) {
			//		button.interactable = false;
			//	}

				//LevelButton lb = newObject.GetComponent<LevelButton> ();
				//lb.levelIndex = n + Application.loadedLevel + 1;

				Text text = newObject.GetComponentInChildren<Text> ();
				text.text = constantsGameObject.GetComponent<LevelConstants> ().World_Name [(n - 1)];
				Text HighScoreText = newObject.GetComponentsInChildren<Text> () [1];
				HighScoreText.text = "HighScore: " + PlayerPrefs.GetInt ("TheGlompHighScore_" + n.ToString (), 0);
				Image newMenuImage = constantsGameObject.GetComponent<LevelConstants> ().world_menu_image [(n - 1)];	
				newObject.GetComponentsInChildren<Image> () [0].sprite = newMenuImage.GetComponent<Image> ().sprite;
				RectTransform rt = newObject.GetComponent<RectTransform> ();
				rt.localPosition = pos;
				rt.localScale = new Vector3 (1, 1, 1);
				switch (n) {
				case 1:
					holdPos = constantsGameObject.GetComponent<LevelConstants> ().World_1_Level_menuPos;
					starPosStr = constantsGameObject.GetComponent<LevelConstants> ().World_1_Level_starPos;
					levelButColour = constantsGameObject.GetComponent<LevelConstants> ().World_1_Level_Button_Colour;
					break;
				case 2:
					holdPos = constantsGameObject.GetComponent<LevelConstants> ().World_2_Level_menuPos;
					starPosStr = constantsGameObject.GetComponent<LevelConstants> ().World_2_Level_starPos;
					levelButColour = constantsGameObject.GetComponent<LevelConstants> ().World_2_Level_Button_Colour;
					break;
				case 3:
					holdPos = constantsGameObject.GetComponent<LevelConstants> ().World_3_Level_menuPos;
					starPosStr = constantsGameObject.GetComponent<LevelConstants> ().World_3_Level_starPos;
					levelButColour = constantsGameObject.GetComponent<LevelConstants> ().World_3_Level_Button_Colour;
					break;
				case 4:
					holdPos = constantsGameObject.GetComponent<LevelConstants> ().World_4_Level_menuPos;
					starPosStr = constantsGameObject.GetComponent<LevelConstants> ().World_4_Level_starPos;
					levelButColour = constantsGameObject.GetComponent<LevelConstants> ().World_4_Level_Button_Colour;
					break;
				case 5:
					holdPos = constantsGameObject.GetComponent<LevelConstants> ().World_5_Level_menuPos;
					starPosStr = constantsGameObject.GetComponent<LevelConstants> ().World_5_Level_starPos;
					levelButColour = constantsGameObject.GetComponent<LevelConstants> ().World_5_Level_Button_Colour;
					break;
				case 6:
					holdPos = constantsGameObject.GetComponent<LevelConstants> ().World_6_Level_menuPos;
					starPosStr = constantsGameObject.GetComponent<LevelConstants> ().World_6_Level_starPos;
					levelButColour = constantsGameObject.GetComponent<LevelConstants> ().World_6_Level_Button_Colour;
					break;
				case 7:
					holdPos = constantsGameObject.GetComponent<LevelConstants> ().World_7_Level_menuPos;
					starPosStr = constantsGameObject.GetComponent<LevelConstants> ().World_7_Level_starPos;
					levelButColour = constantsGameObject.GetComponent<LevelConstants> ().World_7_Level_Button_Colour;
					break;
				case 8:
					holdPos = constantsGameObject.GetComponent<LevelConstants> ().World_8_Level_menuPos;
					starPosStr = constantsGameObject.GetComponent<LevelConstants> ().World_8_Level_starPos;
					levelButColour = constantsGameObject.GetComponent<LevelConstants> ().World_8_Level_Button_Colour;
					break;
				case 9:
					holdPos = constantsGameObject.GetComponent<LevelConstants> ().World_9_Level_menuPos;
					starPosStr = constantsGameObject.GetComponent<LevelConstants> ().World_9_Level_starPos;
					levelButColour = constantsGameObject.GetComponent<LevelConstants> ().World_9_Level_Button_Colour;
					break;
				case 10:
					holdPos = constantsGameObject.GetComponent<LevelConstants> ().World_10_Level_menuPos;
					starPosStr = constantsGameObject.GetComponent<LevelConstants> ().World_10_Level_starPos;
					levelButColour = constantsGameObject.GetComponent<LevelConstants> ().World_10_Level_Button_Colour;
					break;
				}
				int NumOfLevels = constantsGameObject.GetComponent<LevelConstants> ().world_numOfLevels [(n - 1)];
				for (int i = 1; i <=NumOfLevels; i++) {

					if(starPosStr[(i-1)]=="t")
					{
						starPos = new Vector3(20,30,0);
					}
					if(starPosStr[(i-1)]=="b")
					{
						starPos = new Vector3(-20,-30,0);
					}
					GameObject newButtonObject = (GameObject)Instantiate (levellevelButton, holdPos[(i-1)], Quaternion.identity);
					newButtonObject.transform.SetParent (newObject.transform, false);
					Text text2 = newButtonObject.GetComponentInChildren<Text> ();
					text2.text = i+"";
					GameObject newStarObject = (GameObject)Instantiate (levelStar, starPos, Quaternion.identity);
					newStarObject.transform.SetParent (newButtonObject.transform, false);
					if(PlayerPrefs.GetInt("world_"+n+"_level_"+i+"_gotGoldDrop",0)>0)
					{
					Image colourStar = newStarObject.GetComponentInChildren<Image> ();
					colourStar.color = Color.yellow;
					}
					Button button = newButtonObject.GetComponent<Button> ();
					//if a world hasn't been unlocked lock all buttons
					if (n > Constants.getMaxWorld ()) 
					{
						button.interactable = false;
					}
					if((i>1)&&(i > Constants.getMaxLevel(n)))
					{
						button.interactable = false;
					}


					LevelLevelButton llb = newButtonObject.GetComponent<LevelLevelButton> ();
					llb.WorldInt = n + Application.loadedLevel;
					llb.levelInt = i;
					//if World_useLevelButtonImage
					//World_levelButtonImage
					if(constantsGameObject.GetComponent<LevelConstants> ().World_uselevelButtonColour[(n - 1)])
					{
						Image colourImage = newButtonObject.GetComponentInChildren<Image> ();
						colourImage.color = levelButColour;
					}
				}
			}
			return newPage;
		}
		

	}
}