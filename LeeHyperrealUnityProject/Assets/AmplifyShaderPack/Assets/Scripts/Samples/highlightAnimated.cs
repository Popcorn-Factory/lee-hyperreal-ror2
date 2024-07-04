// Amplify Shader Pack
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using UnityEngine;

namespace TFHC_Shader_Samples
{

	public class highlightAnimated : MonoBehaviour
    {

        private Material mat;

        void Start()
        {
            mat = GetComponent<Renderer>().material;
        }

        void OnMouseEnter()
        {
            switchhighlighted(true);
		}

        void OnMouseExit()
        {
            switchhighlighted(false);
        }

        void switchhighlighted(bool highlighted)
        {
            mat.SetFloat("_Highlighted", (highlighted ? 1.0f : 0.0f));
        }

    }

}
