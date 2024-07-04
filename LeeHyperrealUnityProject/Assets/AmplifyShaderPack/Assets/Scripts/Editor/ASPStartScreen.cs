// Amplify Shader Pack
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using UnityEngine;
using UnityEditor;
using UnityEditor.PackageManager.Requests;
using UnityEngine.Networking;
using System;
using System.Collections;
using System.Collections.Generic;

namespace AmplifyShaderPack
{
	public class ASPStartScreen : EditorWindow
	{
		//private static readonly string HDRPSamples7to9GUID = "abf8c3e18e883894aa7a5cf7dc6a5408";
		//private static readonly string HDRPSamples10to11GUID = "312b55e12eefb9b4aba6ebeb4ad6f35a";
		//private static readonly string URPSamples10to11GUID = "47222e91b38f7f943a2c717aca57ed58";
		//private static readonly string URPSamples7to9GUID = "a4ba258cacd903245bb6a04777c45689";
		//private static readonly string BiRPSamplesGUID = "cc34b441a892177478d7932a061167f7";

		private static readonly string ChangeLogGUID = "c8b8d880514bcf14aa8b2bbb7d362e36";
	

		private static readonly string ASEIconGUID = "24f41dcf57cec2745a368c3504053d60";
		private static readonly string ASPIconGUID = "bc13bd608b59d9d4aa6c5efd2294b54e";

		public static readonly string ChangelogURL = "http://amplify.pt/Banner/ASPchangelog.json";

		private static readonly string HDRPCaralogueURL = "http://wiki.amplify.pt/index.php?title=Unity_Products:Amplify_Shader_Pack/HDRP";
		private static readonly string URPCatalogueURL = "http://wiki.amplify.pt/index.php?title=Unity_Products:Amplify_Shader_Pack/URP";
		private static readonly string BuiltinCatalogueURL = "http://wiki.amplify.pt/index.php?title=Unity_Products:Amplify_Shader_Pack/BuiltIn";


		private static readonly string DiscordURL = "https://discordapp.com/invite/EdrVAP5";
		private static readonly string ForumURL = "https://forum.unity.com/threads/best-tool-asset-store-award-amplify-shader-editor-node-based-shader-creation-tool.430959/";

		private static readonly string SiteURL = "http://amplify.pt/download/";
		private static readonly string ASPStoreURL = "https://assetstore.unity.com/packages/slug/202484";
		private static readonly string ASEStoreURL = "https://assetstore.unity.com/packages/tools/visual-scripting/amplify-shader-editor-68570?aid=1011lPwI&pubref=ShaderPack";
		private static readonly string BundleStoreURL = "https://assetstore.unity.com/packages/tools/visual-scripting/amplify-bundle-173849?aid=1011lPwI&pubref=ShaderPack";


		private static readonly GUIContent SamplesTitle = new GUIContent( "Shader Samples", "Import samples according to you project rendering pipeline" );
		private static readonly GUIContent ShaderCatalogueTitle = new GUIContent( "Shader Catalogue", "Check the online sample gallery of for each of the pipelines" );
		private static readonly GUIContent CommunityTitle = new GUIContent( "Community", "Need help? Reach us through our discord server or the offitial support Unity forum" );
		private static readonly GUIContent UpdateTitle = new GUIContent( "Latest Update", "Check the lastest additions, improvements and bug fixes done to ASP" );
		private static readonly GUIContent SRPTitle = new GUIContent( "SRP Version" , "Samples were created under a specific SRP version. Please check if yours is compatible." );
		private static readonly GUIContent ASPTitle = new GUIContent( "Amplify Shader Pack", "Are you using the latest version? Now you know" );

		private const string DisplayDialogTitle = "Import Sample";
		private const string DisplayDialogText = "This will import the samples for the selected pipeline, please make sure the pipeline is properly installed and set before importing the samples.\n\nContinue?";

		private static readonly GUIContent[] ASPBody =
		{
			new GUIContent("All shaders created and fully editable with Amplify Shader Editor."),
			new GUIContent("Check out the Amplify Creations Unity bundle and save over $50!"),
			new GUIContent(" Amplify Bundle"),
			new GUIContent("Amplify Shader Editor"),
		};

		private static readonly string SRPErrorMessage = "An incompatible SRP version was found in this project, valid versions are 10.x and above. Please note that it doesn't necessarily mean that shaders will fail to compile but they may require being recompiled to this version using Amplify Shader Editor";
		private const string HDPackageId = "com.unity.render-pipelines.high-definition";
		private const string UniversalPackageId = "com.unity.render-pipelines.universal";

		public const string OnlineVersionWarning = "Please enable \"Allow downloads over HTTP*\" in Player Settings to access latest version information via Start Screen.";

		//private static readonly string DownArrow = "\u25BC";

		private readonly Dictionary<string , bool> ValidVersions = new Dictionary<string , bool>
		{
			{ "7.7.1", true },
			{ "10.5.1", true }
		};

//#if UNITY_2019_3_OR_NEWER
//		private int DownButtonSize = 22;
//#else
//		private int DownButtonSize = 21;
//#endif

		private UnityWebRequest m_webRequest;

		private Vector2 m_scrollPosition = Vector2.zero;
		private ASPPreferences.ShowOption m_startup = ASPPreferences.ShowOption.Never;
		//private bool m_showURP = false;
		//private bool m_showHDRP = false;

		[NonSerialized]
		private Texture m_packageIcon = null;

		[NonSerialized]
		private Texture m_textIcon = null;

		[NonSerialized]
		private Texture m_webIcon = null;

		private GUIContent m_BuiltInbutton = null;
		private GUIContent m_HDRPbutton = null;
		private GUIContent m_URPbutton = null;
		//private GUIContent HDRP10To11button = null;
		//private GUIContent HDRP7To9button = null;
		//private GUIContent URP10To11button = null;
		//private GUIContent URP7To9button = null;

		private GUIContent m_HDRPCataloguebutton = null;
		private GUIContent m_URPCatalogueButton = null;
		private GUIContent m_BuiltInCataloguebutton = null;


		private GUIContent m_DiscordButton = null;
		private GUIContent m_ForumButton = null;

		private GUIContent m_ASEIcon = null;
		private GUIContent m_ASPIcon = null;
		private RenderTexture m_textIconRT;

		[NonSerialized]
		private GUIStyle m_buttonStyle = null;
		[NonSerialized]
		private GUIStyle m_buttonLeftStyle = null;
		[NonSerialized]
		private GUIStyle m_buttonRightStyle = null;
		[NonSerialized]
		private GUIStyle m_minibuttonStyle = null;
		[NonSerialized]
		private GUIStyle m_labelStyle = null;
		[NonSerialized]
		private GUIStyle m_srpLabelStyle = null;		
		[NonSerialized]
		private GUIStyle m_linkStyle = null;

		private GUIStyle m_noMarginLinkStyle = null;

		private ChangeLogInfo m_changeLog;
		private bool m_infoDownloaded = false;
		private string m_newVersion = string.Empty;

		[MenuItem( "Window/Amplify Shader Pack/Start Screen" , false , 1998 )]
		public static void Init()
		{
			ASPStartScreen window = (ASPStartScreen)GetWindow( typeof( ASPStartScreen ) , true , "Amplify Shader Pack Start Screen" );
			window.minSize = new Vector2( 660 , 700 );
			window.maxSize = new Vector2( 660 , 700 );
			window.Show();
		}

		private void OnEnable()
		{
			m_textIconRT = new RenderTexture( 16, 16, 0 );
			m_textIconRT.Create();

			m_startup = (ASPPreferences.ShowOption)EditorPrefs.GetInt( ASPPreferences.PrefStartUp, 0 );

			if( m_textIcon == null )
			{
				Texture icon = EditorGUIUtility.IconContent( "TextAsset Icon" ).image;
				var cache = RenderTexture.active;
				RenderTexture.active = m_textIconRT;
				Graphics.Blit( icon, m_textIconRT );
				RenderTexture.active = cache;
				m_textIcon = m_textIconRT;

				m_HDRPCataloguebutton = new GUIContent( " HDRP", m_textIcon );
				m_URPCatalogueButton = new GUIContent( " URP", m_textIcon );
				m_BuiltInCataloguebutton = new GUIContent( " Built-in", m_textIcon );
				
			}

			if( m_packageIcon == null )
			{
				m_packageIcon = EditorGUIUtility.IconContent( "BuildSettings.Editor.Small" ).image;
				//HDRP10To11button = new GUIContent( " HDRP Samples 10 to 11", packageIcon );
				//HDRP7To9button = new GUIContent( " HDRP Samples 7 to 9" , packageIcon );
				//URP10To11button = new GUIContent( " URP Samples 10 to 11", packageIcon );
				//URP7To9button = new GUIContent( " URP Samples 7 to 9" , packageIcon );
				m_BuiltInbutton = new GUIContent( " Built-In Samples" , m_packageIcon );
				m_HDRPbutton = new GUIContent( " HDRP Samples" , m_packageIcon );
				m_URPbutton = new GUIContent( " URP Samples" , m_packageIcon );
			}

			if( m_webIcon == null )
			{
				m_webIcon = EditorGUIUtility.IconContent( "BuildSettings.Web.Small" ).image;
				m_DiscordButton = new GUIContent( " Discord", m_webIcon );
				m_ForumButton = new GUIContent( " Unity Forum", m_webIcon );
			}

			if( m_changeLog == null )
			{
				var changelog = AssetDatabase.LoadAssetAtPath<TextAsset>( AssetDatabase.GUIDToAssetPath( ChangeLogGUID ) );
				string lastUpdate = string.Empty;
				if(changelog != null )
				{
					int oldestReleaseIndex = changelog.text.LastIndexOf( string.Format( "v{0}.{1}.{2}", VersionInfo.Major, VersionInfo.Minor, VersionInfo.Release ) );

					lastUpdate = changelog.text.Substring( 0, changelog.text.IndexOf( "\nv", oldestReleaseIndex + 25 ) );// + "\n...";
					lastUpdate = lastUpdate.Replace( "* ", "\u2022 " );
				}
				m_changeLog = new ChangeLogInfo( VersionInfo.FullNumber, lastUpdate );
			}

			if( m_ASEIcon == null )
			{
				m_ASEIcon = new GUIContent( AssetDatabase.LoadAssetAtPath<Texture2D>( AssetDatabase.GUIDToAssetPath( ASEIconGUID ) ) );
			}

			if( m_ASPIcon == null )
			{
				m_ASPIcon = new GUIContent( AssetDatabase.LoadAssetAtPath<Texture2D>( AssetDatabase.GUIDToAssetPath( ASPIconGUID ) ) );
			}

			ASPPackageManagerHelper2.RequestInfo( true );
		}

		private void OnDisable()
		{
			if( m_textIconRT != null )
			{
				m_textIconRT.Release();
				DestroyImmediate( m_textIconRT );
			}
		}

		public void OnGUI()
		{
			ASPPackageManagerHelper2.Update();

			if( !m_infoDownloaded )
			{
				m_infoDownloaded = true;

			#if UNITY_2022_1_OR_NEWER
				if ( PlayerSettings.insecureHttpOption == InsecureHttpOption.NotAllowed )
				{
					Debug.LogWarning( "[AmplifyShaderPack] " + OnlineVersionWarning );
				}
				else
			#endif
				{
					StartBackgroundTask( StartRequest( ChangelogURL, () =>
					{
						var temp = ChangeLogInfo.CreateFromJSON( m_webRequest.downloadHandler.text );
						if( temp != null && temp.Version >= m_changeLog.Version )
						{
							m_changeLog = temp;
						}
						
						int version = m_changeLog.Version;
						int major = version / 10000;
						int minor = version / 1000 - major * 10;
						int release = version / 100 - ( version / 1000 ) * 10;
						int revision = version - ( version / 100 ) * 100;
						m_newVersion = major + "." + minor + "." + release + ( revision > 0 ? "." + revision : "" );
						Repaint();
					} ) );
					}
			}

			if( m_buttonStyle == null )
			{
				m_buttonStyle = new GUIStyle( GUI.skin.button );
				m_buttonStyle.alignment = TextAnchor.MiddleLeft;
			}

			if( m_buttonLeftStyle == null )
			{
				m_buttonLeftStyle = new GUIStyle( "ButtonLeft" );
				m_buttonLeftStyle.alignment = TextAnchor.MiddleLeft;
				m_buttonLeftStyle.margin = m_buttonStyle.margin;
				m_buttonLeftStyle.margin.right = 0;
			}

			if( m_buttonRightStyle == null )
			{
				m_buttonRightStyle = new GUIStyle( "ButtonRight" );
				m_buttonRightStyle.alignment = TextAnchor.MiddleLeft;
				m_buttonRightStyle.margin = m_buttonStyle.margin;
				m_buttonRightStyle.margin.left = 0;
			}

			if( m_minibuttonStyle == null )
			{
				m_minibuttonStyle = new GUIStyle( "MiniButton" );
				m_minibuttonStyle.alignment = TextAnchor.MiddleLeft;
				m_minibuttonStyle.margin = m_buttonStyle.margin;
				m_minibuttonStyle.margin.left = 20;
				m_minibuttonStyle.normal.textColor = m_buttonStyle.normal.textColor;
				m_minibuttonStyle.hover.textColor = m_buttonStyle.hover.textColor;
			}

			if( m_labelStyle == null )
			{
				m_labelStyle = new GUIStyle( "BoldLabel" );
				m_labelStyle.margin = new RectOffset( 4, 4, 4, 4 );
				m_labelStyle.padding = new RectOffset( 2, 2, 2, 2 );
				m_labelStyle.fontSize = 13;
			}

			if( m_srpLabelStyle == null )
			{
				m_srpLabelStyle = new GUIStyle( "Label" );
			}

			if( m_linkStyle == null )
			{
				var inv = AssetDatabase.LoadAssetAtPath<Texture2D>( AssetDatabase.GUIDToAssetPath( "1004d06b4b28f5943abdf2313a22790a" ) ); // find a better solution for transparent buttons
				m_linkStyle = new GUIStyle();
				m_linkStyle.normal.textColor = new Color( 0.2980392f, 0.4901961f, 1f );
				m_linkStyle.hover.textColor = Color.white;
				m_linkStyle.active.textColor = Color.grey;
				m_linkStyle.margin.top = 3;
				m_linkStyle.margin.bottom = 2;
				m_linkStyle.hover.background = inv;
				m_linkStyle.active.background = inv;
			}

			if( m_noMarginLinkStyle == null )
			{
				m_noMarginLinkStyle = new GUIStyle( "BoldLabel" );
				m_noMarginLinkStyle.normal.textColor = new Color( 0.2980392f , 0.4901961f , 1f );
				m_noMarginLinkStyle.hover.textColor = Color.white;
				m_noMarginLinkStyle.active.textColor = Color.grey;
				m_noMarginLinkStyle.hover.background = m_linkStyle.hover.background;
				m_noMarginLinkStyle.active.background = m_linkStyle.active.background;
			}

			EditorGUILayout.BeginHorizontal( GUIStyle.none, GUILayout.ExpandWidth( true ) );
			{
				/////////////////////////////////////////////////////////////////////////////////////
				// LEFT COLUMN
				/////////////////////////////////////////////////////////////////////////////////////
				EditorGUILayout.BeginVertical( GUILayout.Width( 175 ) );
				{
					GUILayout.Label( SamplesTitle, m_labelStyle );
					//Old Dropdown HDRP button
					//{
					//	EditorGUILayout.BeginHorizontal();
					//	if( GUILayout.Button( HDRP10To11button , m_buttonLeftStyle ) )
					//		ImportSample( HDRP10To11button.text , HDRPSamples10to11GUID );

					//	if( GUILayout.Button( DownArrow , m_buttonRightStyle , GUILayout.Width( DownButtonSize ) , GUILayout.Height( DownButtonSize ) ) )
					//	{
					//		m_showHDRP = !m_showHDRP;
					//		m_showURP = false;
					//	}
					//	EditorGUILayout.EndHorizontal();

					//	if( m_showHDRP )
					//	{
					//		if( GUILayout.Button( HDRP7To9button , m_minibuttonStyle ) )
					//			ImportSample( HDRP7To9button.text , HDRPSamples7to9GUID );
					//	}
					//}


					//Old Dropdown URP button
					//{
					//	EditorGUILayout.BeginHorizontal();
					//	if( GUILayout.Button( URP10To11button , m_buttonLeftStyle ) )
					//		ImportSample( URP10To11button.text , URPSamples10to11GUID );

					//	if( GUILayout.Button( DownArrow , m_buttonRightStyle , GUILayout.Width( DownButtonSize ) , GUILayout.Height( DownButtonSize ) ) )
					//	{
					//		m_showURP = !m_showURP;
					//		m_showHDRP = false;
					//	}
					//	EditorGUILayout.EndHorizontal();
					//	if( m_showURP )
					//	{
					//		EditorGUILayout.BeginVertical();
					//		if( GUILayout.Button( URP7To9button , m_minibuttonStyle ) )
					//			ImportSample( URP7To9button.text , URPSamples7to9GUID );
					//		EditorGUILayout.EndVertical();
					//	}
					//}
					if( GUILayout.Button( m_HDRPbutton , m_buttonStyle ) )
					{
						if ( ASPPackageManagerHelper2.HDRPMatch != null )
						{
							if( EditorUtility.DisplayDialog( DisplayDialogTitle , DisplayDialogText , "Yes" , "No" ) )
							{
								ASPPackageManagerHelper.ImportSamples( ASPImportType.HDRP );
							}
						}
						else
						{
							EditorUtility.DisplayDialog( DisplayDialogTitle, "No compatible HDRP package was found on the current project.\n\nSamples will NOT be imported.", "OK" );
						}
					}

					if( GUILayout.Button( m_URPbutton , m_buttonStyle ) )
					{
						if ( ASPPackageManagerHelper2.URPMatch != null )
						{
							if( EditorUtility.DisplayDialog( DisplayDialogTitle , DisplayDialogText , "Yes" , "No" ) )
							{
								ASPPackageManagerHelper.ImportSamples( ASPImportType.URP );
							}
						}
						else
						{
							EditorUtility.DisplayDialog( DisplayDialogTitle, "No compatible URP package was found on the current project.\n\nSamples will NOT be imported.", "OK" );
						}
					}

					if( GUILayout.Button( m_BuiltInbutton , m_buttonStyle ) )
					{
						if( EditorUtility.DisplayDialog( DisplayDialogTitle , DisplayDialogText , "Yes" , "No" ) )
						{
							ASPPackageManagerHelper.ImportSamples( ASPImportType.BiRP );
						}
					}

					GUILayout.Space( 10 );

					GUILayout.Label( ShaderCatalogueTitle, m_labelStyle );
					if( GUILayout.Button( m_HDRPCataloguebutton, m_buttonStyle ) )
						Application.OpenURL( HDRPCaralogueURL );

					if( GUILayout.Button( m_URPCatalogueButton, m_buttonStyle ) )
						Application.OpenURL( URPCatalogueURL );

					if( GUILayout.Button( m_BuiltInCataloguebutton, m_buttonStyle ) )
						Application.OpenURL( BuiltinCatalogueURL );
				}
				EditorGUILayout.EndVertical();
				
				/////////////////////////////////////////////////////////////////////////////////////
				// RIGHT COLUMN
				/////////////////////////////////////////////////////////////////////////////////////
				EditorGUILayout.BeginVertical( GUILayout.Width( 650 - 175 - 9 ), GUILayout.ExpandHeight( true ) );
				{
					GUILayout.Space( 20 );
					GUILayout.BeginHorizontal();
					{
						GUILayout.BeginVertical();
						{
							GUILayout.Label( ASPBody[ 0 ] );
							GUILayout.Label( ASPBody[ 1 ] );
							GUILayout.BeginHorizontal(GUILayout.Width(100));

							if( GUILayout.Button( ASPBody[ 2 ] , m_noMarginLinkStyle ) )
								Application.OpenURL( BundleStoreURL );

							GUILayout.Label( "-" );

							if( GUILayout.Button( ASPBody[ 3 ] , m_noMarginLinkStyle ) )
								Application.OpenURL( ASEStoreURL );

							GUILayout.EndHorizontal();
						}
						GUILayout.EndVertical();

						GUILayout.FlexibleSpace();
						EditorGUILayout.BeginVertical();
						{
							GUILayout.Space( 7 );
							GUILayout.Label( m_ASEIcon );
						}
						EditorGUILayout.EndVertical();
					}
					GUILayout.EndHorizontal();

					GUILayout.Space( 13 );

					//Discord/Forum
					//GUILayout.Label( CommunityTitle, m_labelStyle );
					GUILayout.BeginHorizontal( GUILayout.ExpandWidth( true ) );
					{
						if( GUILayout.Button( m_DiscordButton, GUILayout.ExpandWidth( true ) ) )
						{
							Application.OpenURL( DiscordURL );
						}
						if( GUILayout.Button( m_ForumButton, GUILayout.ExpandWidth( true ) ) )
						{
							Application.OpenURL( ForumURL );
						}
					}
					bool hasSRPPackage = false;
					bool urpCompatible = ( ASPPackageManagerHelper2.URPMatch != null );
					bool hdrpCompatible = ( ASPPackageManagerHelper2.HDRPMatch != null );
					Color bufferColor = GUI.color;
					GUILayout.EndHorizontal();
					GUILayout.Label( SRPTitle , m_labelStyle );
					GUILayout.BeginHorizontal( GUILayout.Width( 300 ) );
					{
						if( ASPPackageManagerHelper2.URPPackageInfo != null )
						{
							if( !string.IsNullOrEmpty( ASPPackageManagerHelper2.URPPackageInfo.version ) )
							{
								hasSRPPackage = true;
								m_srpLabelStyle.normal.textColor = urpCompatible ? new Color( 0, 0.6f, 0 ) : new Color( 0.8f, 0, 0 );
								GUILayout.BeginHorizontal( GUILayout.Width( 150 ) );
								GUILayout.Label( "URP version: " + ASPPackageManagerHelper2.URPPackageInfo.version, m_srpLabelStyle );
								GUILayout.EndHorizontal();
							}
						}

						if( ASPPackageManagerHelper2.HDRPPackageInfo != null )
						{
							if( !string.IsNullOrEmpty( ASPPackageManagerHelper2.HDRPPackageInfo.version ) )
							{
								hasSRPPackage = true;
								m_srpLabelStyle.normal.textColor = hdrpCompatible ? new Color( 0, 0.6f, 0 ) : new Color( 0.8f, 0, 0 );
								GUILayout.BeginHorizontal( GUILayout.Width( 150 ) );
								GUILayout.Label( "HDRP version: " + ASPPackageManagerHelper2.HDRPPackageInfo.version, m_srpLabelStyle );
								GUILayout.EndHorizontal();
							}
						}

						if( !hasSRPPackage )
						{
							GUILayout.Label( "No SRP version installed" );
						}
					}
					GUILayout.EndHorizontal();
					GUI.color = bufferColor;

					if( ( ASPPackageManagerHelper2.HDRPPackageInfo != null && !hdrpCompatible ) || ( ASPPackageManagerHelper2.URPPackageInfo != null && !urpCompatible ) )
					{
						EditorGUILayout.HelpBox( SRPErrorMessage , MessageType.Warning );
					}

					GUILayout.Label( UpdateTitle, m_labelStyle );
					m_scrollPosition = GUILayout.BeginScrollView( m_scrollPosition, "ProgressBarBack", GUILayout.ExpandHeight( true ), GUILayout.ExpandWidth( true ) );
					GUILayout.Label( m_changeLog.LastUpdate, "WordWrappedMiniLabel", GUILayout.ExpandHeight( true ) );

					GUILayout.EndScrollView();

					EditorGUILayout.BeginHorizontal( GUILayout.ExpandWidth( true ) );
					{
						EditorGUILayout.BeginVertical();
						{
							GUILayout.Label( ASPTitle , m_labelStyle );

							GUILayout.Label( "Installed Version: " + VersionInfo.StaticToString() );

							if( m_changeLog.Version > VersionInfo.FullNumber )
							{
								var cache = GUI.color;
								GUI.color = Color.red;
								GUILayout.Label( "New version available: " + m_newVersion , "BoldLabel" );
								GUI.color = cache;
							}
							else
							{
								var cache = GUI.color;
								GUI.color = Color.green;
								GUILayout.Label( "You are using the latest version" , "BoldLabel" );
								GUI.color = cache;
							}

							EditorGUILayout.BeginHorizontal();
							{
								GUILayout.Label( "Download links:" );
								if( GUILayout.Button( "Amplify" , m_linkStyle ) )
									Application.OpenURL( SiteURL );
								GUILayout.Label( "-" );
								if( GUILayout.Button( "Asset Store" , m_linkStyle ) )
									Application.OpenURL( ASPStoreURL );
							}
							EditorGUILayout.EndHorizontal();
							GUILayout.Space( 7 );
						}
						EditorGUILayout.EndVertical();

						GUILayout.FlexibleSpace();
						EditorGUILayout.BeginVertical();
						{
							GUILayout.Space( 7 );
							GUILayout.Label( m_ASPIcon );
						}
						EditorGUILayout.EndVertical();
					}
					EditorGUILayout.EndHorizontal();
				}
				EditorGUILayout.EndVertical();
			}
			EditorGUILayout.EndHorizontal();


			EditorGUILayout.BeginHorizontal( "ProjectBrowserBottomBarBg", GUILayout.ExpandWidth( true ), GUILayout.Height(22) );
			{
				GUILayout.FlexibleSpace();
				EditorGUI.BeginChangeCheck();
				var cache = EditorGUIUtility.labelWidth;
				EditorGUIUtility.labelWidth = 100;
				m_startup = (ASPPreferences.ShowOption)EditorGUILayout.EnumPopup( "Show At Startup", m_startup, GUILayout.Width( 220 ) );
				EditorGUIUtility.labelWidth = cache;
				if( EditorGUI.EndChangeCheck() )
				{
					EditorPrefs.SetInt( ASPPreferences.PrefStartUp, (int)m_startup );
				}
			}
			EditorGUILayout.EndHorizontal();
			
			// Find a better way to update link buttons without repainting the window
			//Repaint();
		}

		IEnumerator StartRequest( string url, Action success = null )
		{
			using( m_webRequest = UnityWebRequest.Get( url ) )
			{
#if UNITY_2017_2_OR_NEWER
				yield return m_webRequest.SendWebRequest();
#else
				yield return www.Send();
#endif

				while( m_webRequest.isDone == false )
					yield return null;

				if( success != null )
					success();
			}
		}

		public static void StartBackgroundTask( IEnumerator update, Action end = null )
		{
			EditorApplication.CallbackFunction closureCallback = null;

			closureCallback = () =>
			{
				try
				{
					if( update.MoveNext() == false )
					{
						if( end != null )
							end();
						EditorApplication.update -= closureCallback;
					}
				}
				catch( Exception ex )
				{
					if( end != null )
						end();
					Debug.LogException( ex );
					EditorApplication.update -= closureCallback;
				}
			};

			EditorApplication.update += closureCallback;
		}
	}

	[Serializable]
	internal class ChangeLogInfo
	{
		public int Version;
		public string LastUpdate;

		public static ChangeLogInfo CreateFromJSON( string jsonString )
		{
			return JsonUtility.FromJson<ChangeLogInfo>( jsonString );
		}

		public ChangeLogInfo( int version, string lastUpdate )
		{
			Version = version;
			LastUpdate = lastUpdate;
		}
	}
}
