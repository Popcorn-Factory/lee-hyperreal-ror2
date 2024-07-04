// Amplify Shader Pack
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

namespace AmplifyShaderPack
{
	public class ASPPreferences
	{
		public enum ShowOption
		{
			Always = 0,
			OnNewVersion = 1,
			Never = 2
		}

		private static readonly GUIContent StartUp = new GUIContent( "Show start screen on Unity launch", "You can set if you want to see the start screen everytime Unity launchs, only just when there's a new version available or never." );
		public static readonly string PrefStartUp = "ASPLastSession" + Application.productName;
		public static ShowOption GlobalStartUp = ShowOption.Always;

		private static bool PrefsLoaded = false;

#if UNITY_2019_1_OR_NEWER
		[SettingsProvider]
		public static SettingsProvider ImpostorsSettings()
		{
			var provider = new SettingsProvider( "Preferences/Amplify Shader Pack", SettingsScope.User )
			{
				guiHandler = ( string searchContext ) =>
				{
					PreferencesGUI();
				},

				keywords = new HashSet<string>( new[] { "start", "screen", "import", "shader", "templates", "macros", "macros", "define", "symbol" } ),

			};
			return provider;
		}
#else
		[PreferenceItem( "Amplify Shader Pack" )]
#endif
		public static void PreferencesGUI()
		{
			if( !PrefsLoaded )
			{
				LoadDefaults();
				PrefsLoaded = true;
			}

			var cache = EditorGUIUtility.labelWidth;
			EditorGUIUtility.labelWidth = 250;
			{
				EditorGUI.BeginChangeCheck();
				GlobalStartUp = (ShowOption)EditorGUILayout.EnumPopup( StartUp , GlobalStartUp );
				if( EditorGUI.EndChangeCheck() )
				{
					EditorPrefs.SetInt( PrefStartUp , (int)GlobalStartUp );
				}
			}
			
			EditorGUILayout.BeginHorizontal();
			GUILayout.FlexibleSpace();
			if( GUILayout.Button( "Reset and Forget All" ) )
			{
				EditorPrefs.DeleteKey( PrefStartUp );
				GlobalStartUp = ShowOption.Always;
			}
			EditorGUILayout.EndHorizontal();
			EditorGUIUtility.labelWidth = cache;
		}

		public static void LoadDefaults()
		{
			GlobalStartUp = (ShowOption)EditorPrefs.GetInt( PrefStartUp, 0 );
		}
	}
}
