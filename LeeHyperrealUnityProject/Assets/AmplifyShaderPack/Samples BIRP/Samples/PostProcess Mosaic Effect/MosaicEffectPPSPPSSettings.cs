// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( MosaicEffectPPSPPSRenderer ), PostProcessEvent.AfterStack, "Mosaic Effect" )]
public sealed class MosaicEffectPPSPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Tile Size" )]
	public FloatParameter _TileSize = new FloatParameter { value = 10f };
	[Tooltip( "Radius Tweak" )]
	public FloatParameter _RadiusTweak = new FloatParameter { value = 0.9f };
	[Tooltip( "In Between Color" )]
	public ColorParameter _InBetweenColor = new ColorParameter { value = new Color(0f,0f,0f,0f) };
}

public sealed class MosaicEffectPPSPPSRenderer : PostProcessEffectRenderer<MosaicEffectPPSPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "AmplifyShaderPack/Samples BIRP/PostProcess Mosaic Effect" ) );
		sheet.properties.SetFloat( "_TileSize", settings._TileSize );
		sheet.properties.SetFloat( "_RadiusTweak", settings._RadiusTweak );
		sheet.properties.SetColor( "_InBetweenColor", settings._InBetweenColor );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
