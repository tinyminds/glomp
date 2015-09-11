using UnityEngine;
using System.Collections;

public class ButtonNextLevel : MonoBehaviour 
{
	public void NextLevelButton()
	{
		Application.LoadLevel("Main");
	}

}
