// Upgrade NOTE: replaced 'PositionFog()' with multiply of UNITY_MATRIX_MVP by position
// Upgrade NOTE: replaced 'V2F_POS_FOG' with 'float4 pos : SV_POSITION'

Shader "FurBase"
{
	#warning Upgrade NOTE: SubShader commented out; uses Unity 2.x per-pixel lighting. You should rewrite shader into a Surface Shader.
/*SubShader
	{
		Pass
		{
			Name "AMBIENT0"
			Tags {"LightMode" = "Always"}
			/* Upgrade NOTE: commented out, possibly part of old style per-pixel lighting: Blend AppSrcAdd AppDstAdd */
			Fog { Color [_AddFog] }
			ZWrite On
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*20)*_Color;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL0"
			Tags {"LightMode" = "Pixel"}
			/* Upgrade NOTE: commented out, possibly part of old style per-pixel lighting: Blend AppSrcAdd AppDstAdd */
			Fog { Color [_AddFog] }
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*20)*_Color;
				
					return DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
				}
			ENDCG
		}
	
		Pass
		{
			Name "AMBIENT1"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*19)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL1"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*19)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT2"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*2;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*18)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL2"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*2;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*18)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT3"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*3;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*17)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL3"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*3;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*17)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT4"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*4;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*16)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL4"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*4;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*16)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT5"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*5;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*15)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL5"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*5;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*15)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT6"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*6;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*14)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL6"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*6;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*14)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT7"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*7;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*13)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL7"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*7;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*13)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT8"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*8;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*12)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL8"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*8;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*12)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT9"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*9;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*11)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL9"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*9;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*11)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT10"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*10;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*10)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL10"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*10;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*10)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT11"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*11;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*9)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL11"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*11;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*9)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT12"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*12;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*8)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL12"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*12;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*8)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT13"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*13;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*7)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL13"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*13;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*7)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT14"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*14;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*6)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL14"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*14;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*6)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT15"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*15;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*5)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL15"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*15;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*5)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT16"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*16;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*4)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL16"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*16;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*4)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT17"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*17;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*3)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL17"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*17;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*3)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT18"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*18;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*2)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL18"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*18;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*2)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT19"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*19;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*1)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL19"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*19;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*(1-_FurDarkening*1)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "AMBIENT20"
			Tags {"LightMode" = "Always"}
			Blend SrcAlpha OneMinusSrcAlpha
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*20;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "PPL20"
			Tags {"LightMode" = "Pixel"}
			Blend SrcAlpha One
			Fog { Color [_AddFog] }
			ZWrite Off
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord,lightdir,normal)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma multi_compile_builtin
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				#include "AutoLight.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					LIGHTING_COORDS
					float4 texcoord;
					float3 lightdir;
					float3 normal;
				};

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*20;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					o.normal = v.normal.xyz;
					o.lightdir = ObjSpaceLightDir(v.vertex);
					TRANSFER_VERTEX_TO_FRAGMENT(o);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					
					color = DiffuseLight(i.lightdir, normalize(i.normal), color, LIGHT_ATTENUATION(i));
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "SORTING10"
			Tags {"LightMode" = "Always"}
			/* Upgrade NOTE: commented out, possibly part of old style per-pixel lighting: Blend AppSrcAdd AppDstAdd */
			Fog { Color [_AddFog] }
			ZWrite On
			Cull Front
			ColorMask 0
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*10;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
		
		Pass
		{
			Name "SORTING20"
			Tags {"LightMode" = "Always"}
			/* Upgrade NOTE: commented out, possibly part of old style per-pixel lighting: Blend AppSrcAdd AppDstAdd */
			Fog { Color [_AddFog] }
			ZWrite On
			Cull Front
			ColorMask 0
			
			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11 and Xbox360; has structs without semantics (struct v2f members texcoord)
#pragma exclude_renderers d3d11 xbox360
				#pragma vertex vert
				#pragma fragment frag
				
				#pragma fragmentoption ARB_fog_exp2
				#pragma fragmentoption ARB_precision_hint_fastest
				
				#include "UnityCG.cginc"
				
				uniform sampler2D _MainTex;
				uniform float4 _MainTex_ST;
				uniform sampler2D _NoiseTex;
				uniform float4 _NoiseTex_ST;
				uniform float _FurLength;
				uniform float _FurDarkening;
				uniform float4 _Color;
				
				struct v2f
				{
					float4 pos : SV_POSITION;
					float4 texcoord;
				}; 

				v2f vert(appdata_base v)
				{
					v2f o;
					
					v.vertex.xyz += normalize(v.normal.xyz)*_FurLength*20;
					o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
					o.texcoord.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.texcoord.zw = TRANSFORM_TEX(v.texcoord, _NoiseTex);
					
					return o;
				}
			   
				float4 frag(v2f i) : COLOR
				{
					float4 color = tex2D(_MainTex, i.texcoord.xy)*_Color;
					float4 noise = tex2D(_NoiseTex, i.texcoord.zw);
					color.a = noise.r;
				
					return color;
				}
			ENDCG
		}
	}*/
}
