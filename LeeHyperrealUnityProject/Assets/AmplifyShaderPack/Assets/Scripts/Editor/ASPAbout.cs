// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using UnityEngine;
using UnityEditor;

namespace AmplifyShaderPack
{
	public class About : EditorWindow
	{
		private const string AboutImageGUID = "39aa3f6f8f9fd3f4da244b280ee4eec0";
		private Vector2 m_scrollPosition = Vector2.zero;
		private Texture2D m_aboutImage;

		[MenuItem( "Window/Amplify Shader Pack/About...", false, 2001 )]
		static void Init()
		{
			About window = (About)GetWindow( typeof( About ), true, "About Amplify Shader Pack" );
			window.minSize = new Vector2( 502, 290 );
			window.maxSize = new Vector2( 502, 290 );
			window.Show();
		}

		private void OnEnable()
		{
			m_aboutImage = AssetDatabase.LoadAssetAtPath<Texture2D>( AssetDatabase.GUIDToAssetPath( AboutImageGUID ) );
		}

		public void OnGUI()
		{
			m_scrollPosition = GUILayout.BeginScrollView( m_scrollPosition );

			GUILayout.BeginVertical();

			GUILayout.Space( 10 );

			GUILayout.BeginHorizontal();
			GUILayout.FlexibleSpace();
			GUILayout.Box( m_aboutImage, GUIStyle.none );

			if( Event.current.type == EventType.MouseUp && GUILayoutUtility.GetLastRect().Contains( Event.current.mousePosition ) )
				Application.OpenURL( "http://www.amplify.pt" );

			GUILayout.FlexibleSpace();
			GUILayout.EndHorizontal();

			GUIStyle labelStyle = new GUIStyle( EditorStyles.label );
			labelStyle.alignment = TextAnchor.MiddleCenter;
			labelStyle.wordWrap = true;

			GUILayout.Label( "\nAmplify Shader Pack " + VersionInfo.StaticToString(), labelStyle, GUILayout.ExpandWidth( true ) );

			GUILayout.Label( "\nCopyright (c) Amplify Creations, Lda. All rights reserved.\n", labelStyle, GUILayout.ExpandWidth( true ) );

			GUILayout.EndVertical();

			GUILayout.EndScrollView();
		}
	}
}
