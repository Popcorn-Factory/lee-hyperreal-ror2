// Amplify Shader Pack
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class CameraDepthActivation : MonoBehaviour
{
	void Start ()
	{
		GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
	}	
}
