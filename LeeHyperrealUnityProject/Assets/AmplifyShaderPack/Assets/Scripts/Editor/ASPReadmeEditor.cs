// Amplify Shader Pack
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using UnityEngine;
using UnityEditor;
using System.IO;
using System.Reflection;
using UnityEditor.ProjectWindowCallback;
using System.Collections.Generic;
namespace AmplifyShaderPack
{
	public class DoCreateASPReadme : EndNameEditAction
	{
		public override void Action( int instanceId , string pathName , string resourceFile )
		{
			UnityEngine.Object obj = EditorUtility.InstanceIDToObject( instanceId );
			AssetDatabase.CreateAsset( obj , AssetDatabase.GenerateUniqueAssetPath( pathName ) );
		}
	}


	[CustomEditor( typeof( ASPReadme ) )]
	[InitializeOnLoad]
	public class ASPReadmeEditor : Editor
	{
		static float m_bigSpace = 16f;
		static float m_propertySpace = 5f;

		static void LoadLayout()
		{
			var assembly = typeof( EditorApplication ).Assembly;
			var windowLayoutType = assembly.GetType( "UnityEditor.WindowLayout" , true );
			var method = windowLayoutType.GetMethod( "LoadWindowLayout" , BindingFlags.Public | BindingFlags.Static );
			method.Invoke( null , new object[] { Path.Combine( Application.dataPath , "TutorialInfo/Layout.wlt" ) , false } );
		}


		protected override void OnHeaderGUI()
		{
			var readme = (ASPReadme)target;
			Init();

			var iconWidth = Mathf.Min( EditorGUIUtility.currentViewWidth / 3f - 20f , 128f );

			GUILayout.BeginHorizontal( "In BigTitle" );
			{
				GUILayout.Label( readme.Icon , GUILayout.Width( iconWidth ) , GUILayout.Height( iconWidth ) );
				string postFix = string.Empty;
				switch( readme.RPType )
				{
					default:
					case ASPReadme.SampleRPType.Builtin: postFix = " ( Built-in )"; break;
					case ASPReadme.SampleRPType.HDRP: postFix = " ( HDRP )"; break;
					case ASPReadme.SampleRPType.URP: postFix = " ( URP )"; break;
					case ASPReadme.SampleRPType.None: postFix = string.Empty; break;
				}
				GUILayout.Label( readme.Title + postFix , TitleStyle );
			}
			GUILayout.EndHorizontal();
		}

		void DrawSection( ASPReadme.ASPSection section )
		{
			if( !string.IsNullOrEmpty( section.Heading ) )
			{
				GUILayout.Label( section.Heading , HeadingStyle );
			}
			if( !string.IsNullOrEmpty( section.Text ) )
			{
				GUILayout.Label( section.Text , BodyStyle );
			}
			if( !string.IsNullOrEmpty( section.LinkText ) )
			{
				if( LinkLabel( new GUIContent( section.LinkText ) ) )
				{
					Application.OpenURL( section.Url );
				}
			}
		}
		private const string PropertyFormat = "<b>{0}:</b> {1}";
		void DrawProperty( ASPReadme.ASPSection section )
		{
			GUILayout.Label( string.Format( PropertyFormat , section.Heading , section.Text ) , BodyStyle );
		}

		private const string ASEText = "This shader is fully editable with Amplify Shader Editor:";
		private const string ASETextMultiple = "These shaders are fully editable with Amplify Shader Editor:";

		private readonly GUIContent ASEAffiliateLinkText = new GUIContent( "Learn More" );
		private const string ASEAffiliateLinkURL = @"https://assetstore.unity.com/packages/tools/visual-scripting/amplify-shader-editor-68570?aid=1011lPwI&pubref=ShaderPack";

		private const string SRPText0 = "This sample was built on SRP {0}, you need Amplify Shader Editor to update to other SRP distributions:";
		private const string SRPText1 = "<color=yellow>Warning - </color>Using this sample without updating on other SRP distributions will likely result in pink shaders or inconsistencies. Please update by opening and saving the shader in the editor.";

		public override void OnInspectorGUI()
		{
			var readme = (ASPReadme)target;
			Init();
			//Header + Description
			DrawSection( readme.Description );
			GUILayout.Space( m_bigSpace );

			//Main Properties
			DrawSection( readme.PropertiesHeader );
			GUILayout.Space( m_bigSpace );

			if( readme.Properties != null )
			{
				for( int i = 0 ; i < readme.Properties.Length ; i++ )
				{
					DrawProperty( readme.Properties[ i ] );
					GUILayout.Space( m_propertySpace );
				}
			}

			// AdditionalProperties
			if( readme.AdditionalProperties != null && readme.AdditionalProperties.Length > 0 )
			{
				GUILayout.Space( m_bigSpace );
				for( int i = 0 ; i < readme.AdditionalProperties.Length ; i++ )
				{
					DrawSection( readme.AdditionalProperties[ i ].BlockHeader );
					GUILayout.Space( m_bigSpace );
					for( int j = 0 ; j < readme.AdditionalProperties[ i ].BlockContent.Length ; j++ )
					{
						DrawProperty( readme.AdditionalProperties[ i ].BlockContent[ j ] );
						GUILayout.Space( m_propertySpace );
					}
				}
			}

			// AdditionalScripts
			if( readme.AdditionalScripts != null && readme.AdditionalScripts.Length > 0 )
			{
				GUILayout.Space( m_bigSpace );
				for( int i = 0 ; i < readme.AdditionalScripts.Length ; i++ )
				{
					DrawSection( readme.AdditionalScripts[ i ].BlockHeader );
					GUILayout.Space( m_bigSpace );
					for( int j = 0 ; j < readme.AdditionalScripts[ i ].BlockContent.Length ; j++ )
					{
						DrawProperty( readme.AdditionalScripts[ i ].BlockContent[ j ] );
						GUILayout.Space( m_propertySpace );
					}
				}
			}

			if( readme.RPType != ASPReadme.SampleRPType.None )
			{
				//Affilliate
				GUILayout.Space( m_bigSpace );
				{
					if( readme.AdditionalProperties != null && readme.AdditionalProperties.Length > 0 )
					{
						GUILayout.Label( ASETextMultiple , BodyStyle );
					}
					else
					{
						GUILayout.Label( ASEText , BodyStyle );
					}
					if( LinkLabel( new GUIContent( ASEAffiliateLinkText ) ) )
					{
						Application.OpenURL( ASEAffiliateLinkURL );
					}
				}
			}
		}

		bool m_Initialized;

		GUIStyle LinkStyle { get { return m_LinkStyle; } }
		[SerializeField] GUIStyle m_LinkStyle;

		GUIStyle TitleStyle { get { return m_TitleStyle; } }
		[SerializeField] GUIStyle m_TitleStyle;

		GUIStyle HeadingStyle { get { return m_HeadingStyle; } }
		[SerializeField] GUIStyle m_HeadingStyle;

		GUIStyle BodyStyle { get { return m_BodyStyle; } }
		[SerializeField] GUIStyle m_BodyStyle;

		void Init()
		{
			if( m_Initialized )
				return;
			m_BodyStyle = new GUIStyle( EditorStyles.label );
			m_BodyStyle.wordWrap = true;
			m_BodyStyle.fontSize = 14;
			m_BodyStyle.richText = true;

			m_TitleStyle = new GUIStyle( m_BodyStyle );
			m_TitleStyle.fontSize = 26;

			m_HeadingStyle = new GUIStyle( m_BodyStyle );
			m_HeadingStyle.fontStyle = FontStyle.Bold;
			m_HeadingStyle.fontSize = 18;

			m_LinkStyle = new GUIStyle( m_BodyStyle );
			m_LinkStyle.wordWrap = false;
			// Match selection color which works nicely for both light and dark skins
			m_LinkStyle.normal.textColor = new Color( 0x00 / 255f , 0x78 / 255f , 0xDA / 255f , 1f );
			m_LinkStyle.stretchWidth = false;

			m_Initialized = true;
		}

		bool LinkLabel( GUIContent label , params GUILayoutOption[] options )
		{
			var position = GUILayoutUtility.GetRect( label , LinkStyle , options );

			Handles.BeginGUI();
			Handles.color = LinkStyle.normal.textColor;
			Handles.DrawLine( new Vector3( position.xMin , position.yMax ) , new Vector3( position.xMax , position.yMax ) );
			Handles.color = Color.white;
			Handles.EndGUI();

			EditorGUIUtility.AddCursorRect( position , MouseCursor.Link );

			return GUI.Button( position , label , LinkStyle );
		}

		static void SetMaterialProperties( ASPReadme asset , UnityEngine.Object selectedObject )
		{
			Material mat = selectedObject as Material;
			Shader shader;
			if( mat != null )
			{
				shader = mat.shader;
			}
			else
			{
				shader = selectedObject as Shader;
			}

			if( shader != null )
			{
				int propertyCount = shader.GetPropertyCount();
				List<ASPReadme.ASPSection> availableProperties = new List<ASPReadme.ASPSection>();
				for( int i = 0 ; i < propertyCount ; i++ )
				{
					if( !shader.GetPropertyFlags( i ).HasFlag( UnityEngine.Rendering.ShaderPropertyFlags.HideInInspector ) )
					{
						availableProperties.Add( new ASPReadme.ASPSection( shader.GetPropertyDescription( i ) , string.Empty , string.Empty , string.Empty ) );
					}
				}

				if( availableProperties.Count > 0 )
				{
					asset.Properties = availableProperties.ToArray();
				}
				availableProperties.Clear();
				availableProperties = null;
			}
		}

		//[MenuItem( "Assets/Create/ASPReadme Builtin" , false , 83 )]
		static void CreateASPReadmeBuiltin()
		{
			ASPReadme asset = ScriptableObject.CreateInstance<ASPReadme>();
			SetMaterialProperties( asset , Selection.activeObject );
			var endNameEditAction = ScriptableObject.CreateInstance<DoCreateASPReadme>();
			ProjectWindowUtil.StartNameEditingIfProjectWindowExists( asset.GetInstanceID() , endNameEditAction , "Readme.asset"/*assetPathAndName*/, AssetPreview.GetMiniThumbnail( asset ) , null );
		}

		//[MenuItem( "Assets/Create/ASPReadme HDRP" , false , 83 )]
		static void CreateASPReadmeHDRP()
		{
			ASPReadme asset = ScriptableObject.CreateInstance<ASPReadme>();
			SetMaterialProperties( asset , Selection.activeObject );
			asset.RPType = ASPReadme.SampleRPType.HDRP;
			var endNameEditAction = ScriptableObject.CreateInstance<DoCreateASPReadme>();
			ProjectWindowUtil.StartNameEditingIfProjectWindowExists( asset.GetInstanceID() , endNameEditAction , "Readme.asset"/*assetPathAndName*/, AssetPreview.GetMiniThumbnail( asset ) , null );
		}

		//[MenuItem( "Assets/Create/ASPReadme URP" , false , 83 )]
		static void CreateASPReadmeURP()
		{
			ASPReadme asset = ScriptableObject.CreateInstance<ASPReadme>();
			SetMaterialProperties( asset , Selection.activeObject );
			asset.RPType = ASPReadme.SampleRPType.URP;
			var endNameEditAction = ScriptableObject.CreateInstance<DoCreateASPReadme>();
			ProjectWindowUtil.StartNameEditingIfProjectWindowExists( asset.GetInstanceID() , endNameEditAction , "Readme.asset"/*assetPathAndName*/, AssetPreview.GetMiniThumbnail( asset ) , null );
		}
	}
}
