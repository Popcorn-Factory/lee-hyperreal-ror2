// Amplify Shader Pack
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using System;
using UnityEngine;
namespace AmplifyShaderPack
{
	public class ASPReadme : ScriptableObject
	{
		public enum SampleRPType
		{
			Builtin,
			HDRP,
			URP,
			None
		}

		public Texture2D Icon;
		public string Title;
		public ASPSection Description;

		public ASPSection PropertiesHeader;
		public ASPSection[] Properties;

		public ASPBlock[] AdditionalProperties;
		public ASPBlock[] AdditionalScripts;

		public bool LoadedLayout;

		public SampleRPType RPType = SampleRPType.Builtin;

		public ASPReadme()
		{
			Description = new ASPSection( string.Empty , "Place description here" , string.Empty , string.Empty );
			PropertiesHeader = new ASPSection( "Properties" , string.Empty , string.Empty , string.Empty );
		}

		[Serializable]
		public class ASPSection
		{
			public string Heading, Text, LinkText, Url;
			public ASPSection( string heading , string text , string linkText , string url )
			{
				Heading = heading;
				Text = text;
				LinkText = linkText;
				Url = url;
			}
		}

		[Serializable]
		public class ASPBlock
		{
			public ASPSection BlockHeader;
			public ASPSection[] BlockContent;
		}
	}
}
