using UnityEngine;
using System.Collections;

public class ControlGUIScript : MonoBehaviour {

	public float Value = 0.5f;
	public float Fade = 0.01f;

	public GUIBarScript GBS;

	public Vector2 Offset;

	public Vector2 LabelOffSet;

	public string playText = "Play";
	public bool IsPlaying = false;

	void Start()
	{
		GBS = GetComponent<GUIBarScript>();
	}

	void OnGUI() 
	{
		if (GBS == null)
		{
			return;
		}


	}

	void Update () 
	{
		if (GBS == null)
		{
			return;
		}

	
		//GBS.Value = Value;


	}
}
