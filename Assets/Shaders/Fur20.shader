Shader "Fur20"
{
	Properties
	{
		_FurLength ("Length", Float) = 1
		_FurDarkening ("Darkening", Float) = 0.1
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_NoiseTex ("Transparency (R)", 2D) = "white" {}
	}
	
	Category
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		SubShader
		{
			UsePass "FurBase/AMBIENT0"
			UsePass "FurBase/PPL0"
			UsePass "FurBase/SORTING20"
			
			UsePass "FurBase/AMBIENT1"
			UsePass "FurBase/PPL1"
			UsePass "FurBase/AMBIENT2"
			UsePass "FurBase/PPL2"
			UsePass "FurBase/AMBIENT3"
			UsePass "FurBase/PPL3"
			UsePass "FurBase/AMBIENT4"
			UsePass "FurBase/PPL4"
			UsePass "FurBase/AMBIENT5"
			UsePass "FurBase/PPL5"
			UsePass "FurBase/AMBIENT6"
			UsePass "FurBase/PPL6"
			UsePass "FurBase/AMBIENT7"
			UsePass "FurBase/PPL7"
			UsePass "FurBase/AMBIENT8"
			UsePass "FurBase/PPL8"
			UsePass "FurBase/AMBIENT9"
			UsePass "FurBase/PPL9"
			UsePass "FurBase/AMBIENT10"
			UsePass "FurBase/PPL10"
			
			UsePass "FurBase/AMBIENT11"
			UsePass "FurBase/PPL11"
			UsePass "FurBase/AMBIENT12"
			UsePass "FurBase/PPL12"
			UsePass "FurBase/AMBIENT13"
			UsePass "FurBase/PPL13"
			UsePass "FurBase/AMBIENT14"
			UsePass "FurBase/PPL14"
			UsePass "FurBase/AMBIENT15"
			UsePass "FurBase/PPL15"
			UsePass "FurBase/AMBIENT16"
			UsePass "FurBase/PPL16"
			UsePass "FurBase/AMBIENT17"
			UsePass "FurBase/PPL17"
			UsePass "FurBase/AMBIENT18"
			UsePass "FurBase/PPL18"
			UsePass "FurBase/AMBIENT19"
			UsePass "FurBase/PPL19"
			UsePass "FurBase/AMBIENT20"
			UsePass "FurBase/PPL20"
		}
	}
	
	FallBack "Diffuse"
}
