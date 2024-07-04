// Amplify Shader Pack
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using System;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;
using UnityEditor;
using UnityEditor.PackageManager.Requests;

namespace AmplifyShaderPack
{
	public enum ASPSRPBaseline
	{
		ASP_SRP_INVALID = 0,
		ASP_SRP_10 = 100000,
		ASP_SRP_11 = 110000,
		ASP_SRP_12 = 120000,
		ASP_SRP_13 = 130000,
		ASP_SRP_14 = 140000,
		ASP_SRP_15 = 150000,
        ASP_SRP_16 = 160000,
        ASP_SRP_17 = 170000
    }

	public class ASPSRPPackageDesc
	{
		public ASPSRPBaseline baseline = ASPSRPBaseline.ASP_SRP_INVALID;
		public string guidURP = string.Empty;
		public string guidHDRP = string.Empty;

		public ASPSRPPackageDesc( ASPSRPBaseline baseline, string guidURP, string guidHDRP )
		{
			this.baseline = baseline;
			this.guidURP = guidURP;
			this.guidHDRP = guidHDRP;
		}
	}

	[Serializable]
	[InitializeOnLoad]
	public static class ASPPackageManagerHelper2
	{
		private static string URPPackageId  = "com.unity.render-pipelines.universal";
		private static string HDRPPackageId = "com.unity.render-pipelines.high-definition";

		private static Dictionary<int, ASPSRPPackageDesc> m_srpPackageSupport = new Dictionary<int,ASPSRPPackageDesc>()
		{
			{ ( int )ASPSRPBaseline.ASP_SRP_10, new ASPSRPPackageDesc( ASPSRPBaseline.ASP_SRP_10, "409a6afa800412b418e2ff7a84801194", "1ac01ed79a181ea4b913bff141420cbf" ) },
			{ ( int )ASPSRPBaseline.ASP_SRP_11, new ASPSRPPackageDesc( ASPSRPBaseline.ASP_SRP_11, "409a6afa800412b418e2ff7a84801194", "1ac01ed79a181ea4b913bff141420cbf" ) },
			{ ( int )ASPSRPBaseline.ASP_SRP_12, new ASPSRPPackageDesc( ASPSRPBaseline.ASP_SRP_12, "576c965b42f20894da7b7405d682ac65", "0bacf8afbc03e384d849817d14bf7c1f" ) },
			{ ( int )ASPSRPBaseline.ASP_SRP_13, new ASPSRPPackageDesc( ASPSRPBaseline.ASP_SRP_13, "576c965b42f20894da7b7405d682ac65", "0bacf8afbc03e384d849817d14bf7c1f" ) },
			{ ( int )ASPSRPBaseline.ASP_SRP_14, new ASPSRPPackageDesc( ASPSRPBaseline.ASP_SRP_14, "7640552bf790cdd4982f86412ced542a", "04ecf131eb72f984b9ae503872cf17f9" ) },
			{ ( int )ASPSRPBaseline.ASP_SRP_15, new ASPSRPPackageDesc( ASPSRPBaseline.ASP_SRP_15, "c77a06ef3266a6c4690d6269f8977924", "53390a32e6d4c6b41a86f003242f44e4" ) },
            { ( int )ASPSRPBaseline.ASP_SRP_16, new ASPSRPPackageDesc( ASPSRPBaseline.ASP_SRP_16, "6a21139fc863b9845b73118098f69ab4", "4b0a078b4c12c2a4da53c2a643186373" ) },
            { ( int )ASPSRPBaseline.ASP_SRP_17, new ASPSRPPackageDesc( ASPSRPBaseline.ASP_SRP_17, "b933d009540881e4abed80d8947c24ab", "5f247ef6f47b55e49a6659df8f720384" ) },
        };

		private static ListRequest m_packageListRequest = null;

		private static bool m_requireUpdateList = false;

		private static UnityEditor.PackageManager.PackageInfo m_urpPackageInfo;
		private static UnityEditor.PackageManager.PackageInfo m_hdrpPackageInfo;

		public static UnityEditor.PackageManager.PackageInfo URPPackageInfo { get { return m_urpPackageInfo; } }
		public static UnityEditor.PackageManager.PackageInfo HDRPPackageInfo { get { return m_hdrpPackageInfo; } }
		
		private static ASPSRPPackageDesc m_urpMatch = null;
		private static ASPSRPPackageDesc m_hdrpHDRPMatch = null;

		public static ASPSRPPackageDesc URPMatch { get { return m_urpMatch; } }
		public static ASPSRPPackageDesc HDRPMatch { get { return m_hdrpHDRPMatch; } }
			
		static ASPPackageManagerHelper2()
		{
			RequestInfo( true );
		}

		static void WaitForPackageListBeforeUpdating()
		{
			if ( m_packageListRequest.IsCompleted )
			{
				Update();
				EditorApplication.update -= WaitForPackageListBeforeUpdating;
			}
		}

		public static void RequestInfo( bool updateWhileWaiting = false )
		{
			if ( !m_requireUpdateList )
			{
				m_requireUpdateList = true;
				m_packageListRequest = UnityEditor.PackageManager.Client.List( true );
				if ( updateWhileWaiting )
				{
					EditorApplication.update += WaitForPackageListBeforeUpdating;
				}
			}
		}

		private static readonly string SemVerPattern = @"^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$";

		private static int PackageVersionStringToCode( string version, out int major, out int minor, out int patch )
		{
			MatchCollection matches = Regex.Matches( version, SemVerPattern, RegexOptions.Multiline );

			bool validMatch = ( matches.Count > 0 && matches[ 0 ].Groups.Count >= 4 );
			major = validMatch ? int.Parse( matches[ 0 ].Groups[ 1 ].Value ) : 99;
			minor = validMatch ? int.Parse( matches[ 0 ].Groups[ 2 ].Value ) : 99;
			patch = validMatch ? int.Parse( matches[ 0 ].Groups[ 3 ].Value ) : 99;

			int versionCode;
			versionCode = major * 10000;
			versionCode += minor * 100;
			versionCode += patch;
			return versionCode;
		}

		private static void CodeToPackageVersionElements( int versionCode, out int major, out int minor, out int patch )
		{
			major = versionCode / 10000;
			minor = versionCode / 100 - major * 100;
			patch = versionCode - ( versionCode / 100 ) * 100;
		}

		private static int PackageVersionElementsToCode( int major, int minor, int patch )
		{
			return major * 10000 + minor * 100 + patch;
		}

		public static void Update()
		{
			if ( m_requireUpdateList )
			{
				if ( m_packageListRequest != null && m_packageListRequest.IsCompleted )
				{
					m_requireUpdateList = false;
					foreach ( UnityEditor.PackageManager.PackageInfo pi in m_packageListRequest.Result )
					{
						int version = PackageVersionStringToCode( pi.version, out int major, out int minor, out int patch );
						int baseline = PackageVersionElementsToCode( major, 0, 0 );
						ASPSRPPackageDesc match;

						if ( pi.name.Equals( URPPackageId ) && m_srpPackageSupport.TryGetValue( baseline, out match ) )
						{
							// Universal Rendering Pipeline
							m_urpMatch = match;
							m_urpPackageInfo = pi;							
						}
						else if ( pi.name.Equals( HDRPPackageId ) && m_srpPackageSupport.TryGetValue( baseline, out match ) )
						{
							// High-Definition Rendering Pipeline
							m_hdrpHDRPMatch = match;
							m_hdrpPackageInfo = pi;
						}
					}
				}
			}
		}

	}

	public enum ASPImportType
	{
		None,
		URP,
		HDRP,
		BiRP
	}

	public enum ASPRequestStatus
	{
		Success,
		Failed_Import_Running,
		Failed_Editor_Is_Playing
	}

	public static class AssetDatabaseEX
	{
		private static System.Type type = null;
		public static System.Type Type { get { return ( type == null ) ? type = System.Type.GetType( "UnityEditor.AssetDatabase, UnityEditor" ) : type; } }

		public static void ImportPackageImmediately( string packagePath )
		{
			AssetDatabaseEX.Type.InvokeMember( "ImportPackageImmediately" , BindingFlags.Static | BindingFlags.NonPublic | BindingFlags.InvokeMethod , null , null , new object[] { packagePath } );
		}
	}

	[Serializable]
	public static class ASPPackageManagerHelper
	{
		private static ASPImportType m_importingPackage = ASPImportType.None;

		private static readonly string BiRPSamplesGUID = "cc34b441a892177478d7932a061167f7";

		static void FailedPackageImport( string packageName , string errorMessage )
		{
			FinishImporter();
		}

		static void CancelledPackageImport( string packageName )
		{
			FinishImporter();
		}

		static void CompletedPackageImport( string packageName )
		{
			FinishImporter();
		}

		public static ASPRequestStatus ImportSamples( ASPImportType rpType )
		{
			if( Application.isPlaying )
				return ASPRequestStatus.Failed_Editor_Is_Playing;

			if( m_importingPackage != ASPImportType.None )
				return ASPRequestStatus.Failed_Import_Running;

			if ( rpType == ASPImportType.BiRP )
			{
				AssetDatabase.ImportPackage( AssetDatabase.GUIDToAssetPath( BiRPSamplesGUID ), false );
			}
			else if ( rpType == ASPImportType.URP )
			{
				StartImporting( AssetDatabase.GUIDToAssetPath( ASPPackageManagerHelper2.URPMatch.guidURP ) );
			}
			else if ( rpType == ASPImportType.HDRP && ASPPackageManagerHelper2.HDRPMatch != null )
			{
				StartImporting( AssetDatabase.GUIDToAssetPath( ASPPackageManagerHelper2.HDRPMatch.guidHDRP ) );
			}

			return ASPRequestStatus.Success;
		}

		private static void StartImporting( string packagePath )
		{
			AssetDatabase.importPackageCancelled += CancelledPackageImport;
			AssetDatabase.importPackageCompleted += CompletedPackageImport;
			AssetDatabase.importPackageFailed += FailedPackageImport;
			AssetDatabase.ImportPackage( packagePath , false );
		}

		public static void FinishImporter()
		{
			m_importingPackage = ASPImportType.None;
			AssetDatabase.importPackageCancelled -= CancelledPackageImport;
			AssetDatabase.importPackageCompleted -= CompletedPackageImport;
			AssetDatabase.importPackageFailed -= FailedPackageImport;
		}
	}
}
