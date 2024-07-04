// Amplify Shader Pack
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using UnityEngine;

public class CustomRTRainUpdate : MonoBehaviour
{
	public CustomRenderTexture RainCustomRT;
	public int UpdateCount = 4;

	void Awake()
	{
		RainCustomRT.Initialize();
	}

	void Update()
	{
		RainCustomRT.Update( UpdateCount );
	}
}
