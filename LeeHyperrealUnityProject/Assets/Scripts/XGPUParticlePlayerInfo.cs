using System;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class XGPUParticlePlayerInfo
{
	[Serializable]
	public struct CompressShortsVec3
	{
		public ushort data1;

		public uint data2;

		public short TransformToShort(float f)
		{
			return 0;
		}

		public float TransformToFloat(short s)
		{
			return 0f;
		}

		public void FromVector3(Vector3 f)
		{
		}

		public Vector3 ToVector3()
		{
			return default(Vector3);
		}
	}

	[Serializable]
	public struct CompressShortsVec4
	{
		public uint data1;

		public uint data2;

		public short TransformToShort(float f)
		{
			return 0;
		}

		public float TransformToFloat(short s)
		{
			return 0f;
		}

		public void FromVector4(Vector4 f)
		{
		}

		public Vector4 ToVector4()
		{
			return default(Vector4);
		}
	}

	[Serializable]
	public struct CompressBytes
	{
		public uint data;

		public byte TransformToByte(float t)
		{
			return 0;
		}

		public void FromVecMinus(Vector4 vec)
		{
		}

		public void FromVec(Vector4 vec)
		{
		}

		public float TransformToFloat(byte b)
		{
			return 0f;
		}

		public void ErrorClamp1(ref float t)
		{
		}

		public Vector4 DecodeVecMinus(bool errorClamp = false)
		{
			return default(Vector4);
		}

		public Vector4 DecodeVec(bool errorClamp = false)
		{
			return default(Vector4);
		}
	}

	public static bool UploadMeshWhenInit;

	public static bool GPUParticleUploadWhenUse;

	public bool UseCompressedData;

	public int StartFrame;

	public int EndFrame;

	public Vector3 boundsCenter;

	public Vector3 boundsSize;

	public List<Vector3> Vertex;

	public List<Vector3> Normal;

	public List<Vector4> Tangent;

	public List<Vector4> Uv1;

	public List<Vector4> Uv2;

	public List<Vector4> Uv3;

	public List<Color> Color;

	public List<int> Index;

	public Mesh PreBuildMesh;

	private Mesh XMesh;

	public string Name;

	public List<CompressShortsVec3> CVertex;

	public List<CompressShortsVec3> CNormal;

	public List<CompressShortsVec4> CTangent;

	public List<CompressBytes> CUV1;

	public List<CompressShortsVec4> CUV2;

	public List<CompressBytes> CUV3;

	public List<Vector2> CNewUV3Time;

	public List<bool> CNewUV3Mark;

	public List<CompressBytes> CColor;

	private bool CompressAlive;

	public List<ushort> CIndex;

	public Mesh Mesh
	{
		get
		{
			if (PreBuildMesh)
				return PreBuildMesh;
			else
				return XMesh;
		}
	}

	public bool IsAlive()
	{
		if(PreBuildMesh)
			return true;
		else
		{
			return Vertex.Count> 0;
		}
	}

	public void Destroy()
	{
		if (!PreBuildMesh)
		{
			if (!UseCompressedData)
			{
				if (XMesh)
				{
					GameObject.Destroy(XMesh);
					XMesh = null;
				}
				return;
			}
			
		}
	}

	public bool Encode()
	{
		return false;
	}

	private bool IsValidate(float s)
	{
		return Mathf.Abs(s)<300;
	}

	private bool IsValidate(Vector3 i)
	{
		return IsValidate(i.x)&&IsValidate(i.y)&&IsValidate(i.z);
	}

	private bool IsValidate(Vector4 i)
	{
        return IsValidate(i.x) && IsValidate(i.y) && IsValidate(i.z)&&IsValidate(i.w);
    }

	private bool CanEncode()
	{
		return false;
	}

	private void Decode()
	{
	}

	private List<Vector3> DecodeList(List<CompressShortsVec3> c)
	{
		return null;
	}

	private List<Vector4> DecodeList(List<CompressBytes> c, bool minus, bool errorClamp = false)
	{
		return null;
	}

	private List<Vector4> DecodeList(List<CompressShortsVec4> c)
	{
		return null;
	}

	private List<CompressShortsVec4> EncodeList(List<Vector4> c)
	{
		return null;
	}

	private List<CompressShortsVec3> EncodeList(List<Vector3> c)
	{
		return null;
	}

	private List<CompressBytes> EncodeList(List<Vector4> c, bool minus)
	{
		return null;
	}

	private List<CompressBytes> EncodeColor(List<Color> c)
	{
		return null;
	}

	private List<Color> DecodeColor(List<CompressBytes> c)
	{
		return null;
	}

	public List<int> DecodeIndex(List<ushort> c)
	{
		return null;
	}

	private List<ushort> EncodeIndex(List<int> c)
	{
		return null;
	}

	public void Initialize(string name)
	{
		if (PreBuildMesh)
		{
			PreBuildMesh.name = name;
			Mesh.UploadMeshData(true);
			return;
		}
	}

	public Vector3 GetValidVec3(Vector3 bound, ref bool result)
	{
		return default(Vector3);
	}

	public void SetMeshInfo(Mesh mesh)
	{
	}
}
