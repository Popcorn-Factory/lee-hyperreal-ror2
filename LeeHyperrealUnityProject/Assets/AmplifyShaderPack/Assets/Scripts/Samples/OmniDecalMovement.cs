// Amplify Shader Pack
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using UnityEngine;

[ExecuteInEditMode]
public class OmniDecalMovement : MonoBehaviour
{
	private Transform m_transform;
	private Vector3 m_speed = new Vector3( 0 , 0 , 1 );
	private void Awake()
	{
		m_transform = transform;
	}

	void Update()
	{
		m_transform.position += Time.deltaTime * m_speed;
		if( Mathf.Abs( m_transform.position.z ) > 2 )
			m_speed = -m_speed;
	}
}
