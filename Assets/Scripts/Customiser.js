#pragma strict
public var GlompMat1 : Material;
public var GlompMat2 : Material;
public var GlompMat3 : Material;
public var GlompMat4 : Material;
public var GlompMat5 : Material;
public var GlompMat6 : Material;
public var GlompMat7 : Material;
public var GlompMat8 : Material;
public var GlompMat9 : Material;
public var GlompMat10 : Material;
public var GlompMat11 : Material;
public var Bodies : Mesh [];
public var NameInput : UI.InputField;
public var MeshPanel : GameObject;
public var MaterialPanel : GameObject;


function Start () {
	Screen.orientation = ScreenOrientation.Portrait;
}
function Awake()
{
	gameObject.GetComponent.<Renderer>().material = eval("GlompMat"+PlayerPrefs.GetInt("GlompMaterial",1));
	NameInput.text = PlayerPrefs.GetString("GlompName","Name Your Glomp...");
	Destroy (GetComponent (CrumpleMesh));
	gameObject.GetComponent.<MeshFilter>().mesh=Bodies[PlayerPrefs.GetInt("GlompBody",0)];
	gameObject.AddComponent(CrumpleMesh);
}
function Update () {

}

function backButton()
{
	Application.LoadLevel(0);
}

function setMaterial(theMaterialNum : int)
{
	gameObject.GetComponent.<Renderer>().material = eval("GlompMat"+theMaterialNum);
	PlayerPrefs.SetInt("GlompMaterial",theMaterialNum);
}

function SaveName()
{
	PlayerPrefs.SetString("GlompName",NameInput.text);
}

function setMeshes(theMeshNum : int)
{
	print(theMeshNum);
	Destroy (GetComponent (CrumpleMesh));
	gameObject.GetComponent.<MeshFilter>().mesh=Bodies[theMeshNum];
	gameObject.AddComponent(CrumpleMesh);
	PlayerPrefs.SetInt("GlompBody",theMeshNum);
}

function toggleMeshes()
{
 	MeshPanel.SetActive(true);
 	MaterialPanel.SetActive(false);
}

function toggleMaterials()
{
 	MeshPanel.SetActive(false);
 	MaterialPanel.SetActive(true);
}



