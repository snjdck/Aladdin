using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using System.IO;
using System;
using UnityEngine.Assertions;

public class BmdImporter {

	[MenuItem("Model/Import")]
	static void Load () {
		_Load(EditorUtility.OpenFilePanel("Load bmd file", Application.dataPath, "*"));
	}

	[MenuItem("Model/Import All")]
	static void LoadAll () {
		_LoadAll(EditorUtility.OpenFolderPanel("Load all models", "", ""));
	}

	static void _Load(string path){
		_Load(path, Path.GetDirectoryName(path));
	}

	static void _Load(string path, string basePath){
		var bytes = File.ReadAllBytes(path);
		var parser = new Parser(path, basePath);
		parser.Parse(bytes);

		parser.SavePrefab();
		GameObject.DestroyImmediate(parser.go);
	}

	static void _LoadAll (string path) {
		_LoadAll(path, path);
	}

	static void _LoadAll (string path, string basePath) {
		foreach (string file in Directory.EnumerateFiles(path)){
			if(file.EndsWith(".bmd")){
				_Load(file, basePath);
			}
		}

		foreach (string file in Directory.EnumerateDirectories(path)){
			_LoadAll(file, basePath);
		}
	}
}

static class GameObjectExt
{
	static private void CheckFolder(string path)
	{
		if(path.Contains("."))
			path = Path.GetDirectoryName(path);
		if(AssetDatabase.IsValidFolder(path))
			return;
		string dir = Path.GetDirectoryName(path);
		CheckFolder(dir);
		AssetDatabase.CreateFolder(dir, Path.GetFileName(path));
	}

	static public void SavePrefab(this Parser go)
	{
		string path = string.Format("Assets/MU_Prefabs{1}/{0}.prefab", go.name, go.prefix);
		CheckFolder(path);
		PrefabUtility.CreatePrefab(path, go.go);
	}

	static public void SaveMesh(this Parser go, Mesh mesh)
	{
		if(mesh == null) return;
		string path = string.Format("Assets/MU_Prefabs{1}/{0}/Mesh.asset", go.name, go.prefix);
		CheckFolder(path);
		AssetDatabase.CreateAsset(mesh, path);
	}

	static public void SaveMaterial(this Parser go, Material material)
	{
		string path = string.Format("Assets/MU_Prefabs{2}/{0}/Material/{1}.mat", go.name, material.name, go.prefix);
		CheckFolder(path);
		AssetDatabase.CreateAsset(material, path);
	}

	static public void SaveAnimationClip(this Parser go, AnimationClip clip)
	{
		string path = string.Format("Assets/MU_Prefabs{2}/{0}/AnimationClip/{1}.anim", go.name, clip.name, go.prefix);
		CheckFolder(path);
		AssetDatabase.CreateAsset(clip, path);
	}
}


static class ByteExt
{
	static public string GetString(this byte[] buffer, ref int offset)
	{
		var count = 0;
		while(buffer[offset+count] != 0)
		{
			++count;
			if(count >= 32) break;
		}
		var value = System.Text.Encoding.ASCII.GetString(buffer, offset, count);
		offset += 32;
		return value;
	}

	static public UInt16 ToUInt16(this byte[] buffer, ref int offset)
	{
		var value = BitConverter.ToUInt16(buffer, offset);
		offset += 2;
		return value;
	}

	static public Int16 ToInt16(this byte[] buffer, ref int offset)
	{
		var value = BitConverter.ToInt16(buffer, offset);
		offset += 2;
		return value;
	}

	static public float ToSingle(this byte[] buffer, ref int offset)
	{
		var value = BitConverter.ToSingle(buffer, offset);
		offset += 4;
		return value;
	}

	static public Vector3 ToVector3(this byte[] buffer, ref int offset)
	{
		var x = buffer.ToSingle(ref offset);
		var y = buffer.ToSingle(ref offset);
		var z = buffer.ToSingle(ref offset);
		return new Vector3(x, y, z);
	}

	static public Vector2 ToVector2(this byte[] buffer, ref int offset)
	{
		var x = buffer.ToSingle(ref offset);
		var y = buffer.ToSingle(ref offset);
		return new Vector2(x, 1 - y);
	}

	static byte[] keyList = {0xd1, 0x73, 0x52, 0xf6, 0xd2, 0x9a, 0xcb, 0x27, 0x3e, 0xaf, 0x59, 0x31, 0x37, 0xb3, 0xe7, 0xa2};

	static public int Decode(this byte[] buffer)
	{
		if(buffer[3] == 0xA)
		{
			return 4;
		}
		if(buffer[3] != 0xC)
		{
			return 0;
		}

		int keyIndex = 0;
		int offset = 0x5E;

		for(int i = 8, n = buffer.Length; i < n; ++i)
		{
			byte value = buffer[i];
			buffer[i] = (byte)((value ^ keyList[keyIndex]) - offset);
			keyIndex = (keyIndex + 1) & 0xF;
			offset = (value + 0x3D) & 0xFF;
		}

		return 8;
	}
}


public class Parser
{
	public GameObject go;
	public string name;
	public string prefix;

	private bool isStaticMesh;
	private float timeScale = 0.5f;

	public Parser(string path, string basePath)
	{
		var fullname = path.Substring(basePath.Length);
		name = Path.GetFileNameWithoutExtension(fullname);
		prefix = Path.GetDirectoryName(fullname).Replace('\\', '/');
		go = new GameObject(name);
	}

	public void Parse(byte[] buffer)
	{
		int offset = buffer.Decode();
		buffer.GetString(ref offset);
		var subMeshCount = buffer.ToUInt16(ref offset);
		var boneCount = buffer.ToUInt16(ref offset);
		var animationCount = buffer.ToUInt16(ref offset);
		Debug.LogFormat("{0} {1} {2}", subMeshCount, boneCount, animationCount);

		var materials = new Material[subMeshCount];
		var mesh = CreateMesh(buffer, ref offset, subMeshCount, boneCount, materials);

		var keyFrameCountList = new UInt16[animationCount];
		var clipList = new AnimationClip[animationCount];

		CreateAnimations(buffer, ref offset, animationCount, keyFrameCountList, clipList);
		this.isStaticMesh = (boneCount == 1 && animationCount == 1 && keyFrameCountList[0] == 1);
		Transform[] bones = CreateBones(buffer, ref offset, boneCount, keyFrameCountList, clipList);

		Assert.AreEqual(buffer.Length, offset);

		if(isStaticMesh){
			if(mesh == null) return;
			go.AddComponent<MeshRenderer>();
			go.AddComponent<MeshFilter>();

			var combine = new CombineInstance[subMeshCount];
			for(var i=0; i<subMeshCount; ++i){
				combine[i] = new CombineInstance();
				combine[i].mesh = mesh;
				combine[i].subMeshIndex = i;
				combine[i].transform = bones[0].localToWorldMatrix;
			}
			mesh = new Mesh();
			mesh.CombineMeshes(combine, false, true, false);
			go.GetComponent<MeshFilter>().sharedMesh = mesh;
			go.GetComponent<MeshRenderer>().materials = materials;
			this.SaveMesh(mesh);
			foreach(var bone in bones){
				if(bone == null)continue;
				GameObject.DestroyImmediate(bone.gameObject);
			}
		}else{
			go.AddComponent<SkinnedMeshRenderer>();
			go.AddComponent<Animation>();

			var renderer = go.GetComponent<SkinnedMeshRenderer>();
			var animation = go.GetComponent<Animation>();

			renderer.sharedMesh = mesh;
			renderer.bones = bones;
			renderer.materials = materials;

			this.SaveMesh(mesh);

			for(var j = 0; j < animationCount; ++j){
				clipList[j].EnsureQuaternionContinuity();
				this.SaveAnimationClip(clipList[j]);
			}
			
			AnimationUtility.SetAnimationClips(animation, clipList);
			animation.clip = clipList[0];
		}
	}
	//*
	private BoneWeight CreateBoneWeight(int boneIndex)
	{
		BoneWeight weight = new BoneWeight();
		weight.boneIndex0 = boneIndex;
		weight.weight0 = 1;
		return weight;
	}

	private Matrix4x4[] CalcBindposes(int boneCount)
	{
		var bindposes = new Matrix4x4[boneCount];
		for(var i = 0; i < boneCount; ++i)
		{
			bindposes[i] = Matrix4x4.identity;
		}
		return bindposes;
	}
	
	private int[] CreateTriangles(int triangleCount)
	{
		int[] triangles = new int[triangleCount * 3];
		for(var j = triangles.Length - 1; j >= 0; --j)
		{
			triangles[j] = j;
		}
		return triangles;
	}

	private Mesh CreateMesh(byte[] buffer, ref int offset, int subMeshCount, int boneCount, Material[] materials)
	{
		if(subMeshCount <= 0) return null;
		var mesh = new Mesh();
		mesh.subMeshCount = subMeshCount;

		var offsetList = new UInt16[subMeshCount];

		var vertexList = new List<Vector3>();
		var normalList = new List<Vector3>();
		var uvList = new List<Vector2>();
		var boneWeightList = new List<BoneWeight>();

		for(var i = 0; i < subMeshCount; ++i)
		{
			var vertexCount = buffer.ToUInt16(ref offset);
			var normalCount = buffer.ToUInt16(ref offset);
			var uvCount = buffer.ToUInt16(ref offset);
			var triangleCount = buffer.ToUInt16(ref offset);
			offset += 2;

			offsetList[i] = triangleCount;

			var vertexArray = new Vector3[vertexCount];
			var weightArray = new BoneWeight[vertexCount];
			var normalArray = new Vector3[normalCount];
			var uvArray = new Vector2[uvCount];
			var triangleArray = new int[triangleCount * 3];

			for(var j = 0; j < vertexCount; ++j)
			{
				UInt16 boneIndex = buffer.ToUInt16(ref offset);
				offset += 2;
				vertexArray[j] = buffer.ToVector3(ref offset);
				weightArray[j] = CreateBoneWeight(boneIndex);
			}
			for(var j = 0; j < normalCount; ++j)
			{
				offset += 4;
				normalArray[j] = buffer.ToVector3(ref offset);
				offset += 4;
			}
			for(var j = 0; j < uvCount; ++j)
			{
				uvArray[j] = buffer.ToVector2(ref offset);
			}

			for(var j = 0; j < triangleCount; ++j)
			{
				offset += 2;
				for(var k = 0; k < 3; ++k)
				{
					UInt16 index = buffer.ToUInt16(ref offset);
					vertexList.Add(vertexArray[index]);
					boneWeightList.Add(weightArray[index]);
					triangleArray[j * 3 + k] = index;
				}
				offset += 2;
				for(var k = 0; k < 3; ++k)
				{
					UInt16 index = buffer.ToUInt16(ref offset);
					normalList.Add(normalArray[index]);
				}
				offset += 2;
				for(var k = 0; k < 3; ++k)
				{
					UInt16 index = buffer.ToUInt16(ref offset);
					uvList.Add(uvArray[index]);
				}
				offset += 40;
			}

			var texName = buffer.GetString(ref offset);
			texName = string.Format("Assets/MU_Textures{0}/{1}", prefix, texName);
			Material material = new Material(Shader.Find("Legacy Shaders/Diffuse"));
			material.name = i.ToString();
			material.mainTexture = AssetDatabase.LoadAssetAtPath<Texture2D>(texName);
			materials[i] = material;
			this.SaveMaterial(material);
		}

		mesh.vertices = vertexList.ToArray();
		mesh.normals = normalList.ToArray();
		mesh.boneWeights = boneWeightList.ToArray();
		mesh.uv = uvList.ToArray();

		var total = 0;
		for(var i = 0; i < subMeshCount; ++i)
		{
			var triangleCount = offsetList[i];
			mesh.SetTriangles(CreateTriangles(triangleCount), i, true, total);
			total += triangleCount * 3;
		}

		mesh.bindposes = CalcBindposes(boneCount);

		return mesh;
	}

	private void CreateAnimations(byte[] buffer, ref int offset, int animationCount, UInt16[] keyFrameCountList, AnimationClip[] clipList)
	{
		for(var i = 0; i < animationCount; ++i)
		{
			var clip = new AnimationClip();
			clip.name = i.ToString();
			clip.legacy = true;
			clip.wrapMode = WrapMode.Loop;
			clipList[i] = clip;

			var keyFrameCount = buffer.ToUInt16(ref offset);
			keyFrameCountList[i] = keyFrameCount;
			if(buffer[offset++] == 0) continue;
			offset += 12 * keyFrameCount;
		}
	}

	private Transform[] CreateBones(byte[] buffer, ref int offset, int boneCount, UInt16[] keyFrameCountList, AnimationClip[] clipList)
	{
		var bones = new Transform[boneCount];
		var animationCount = keyFrameCountList.Length;
		for(var i = 0; i < boneCount; ++i)
		{
			if(buffer[offset++] != 0) continue;

			var boneName = buffer.GetString(ref offset);
			var bonePID = buffer.ToInt16(ref offset);

			var boneTransform = new GameObject(boneName).transform;
			bones[i] = boneTransform;
			boneTransform.SetParent((bonePID >= 0) ? bones[bonePID] : go.transform, false);

			var bonePath = AnimationUtility.CalculateTransformPath(boneTransform, go.transform);

			for(var j = 0; j < animationCount; ++j)
			{
				var keyFrameCount = keyFrameCountList[j];
				var curvePX = new AnimationCurve();
				var curvePY = new AnimationCurve();
				var curvePZ = new AnimationCurve();
				var curveRX = new AnimationCurve();
				var curveRY = new AnimationCurve();
				var curveRZ = new AnimationCurve();
				var curveRW = new AnimationCurve();

				for(var k = 0; k < keyFrameCount; ++k)
				{
					var position = buffer.ToVector3(ref offset);
					var time = k * timeScale;
					curvePX.AddKey(time, position.x);
					curvePY.AddKey(time, position.y);
					curvePZ.AddKey(time, position.z);
					if(isStaticMesh){
						boneTransform.localPosition = position;
					}
				}
				for(var k = 0; k < keyFrameCount; ++k)
				{
					var euler = buffer.ToVector3(ref offset);
					var quaternion = FromEulerAngles(euler.x, euler.y, euler.z);
					var time = k * timeScale;
					curveRX.AddKey(time, quaternion.x);
					curveRY.AddKey(time, quaternion.y);
					curveRZ.AddKey(time, quaternion.z);
					curveRW.AddKey(time, quaternion.w);
					if(isStaticMesh){
						boneTransform.localRotation = quaternion;
					}
				}

				if(keyFrameCount > 1)
				{
					var time = keyFrameCount * timeScale;
					curvePX.AddKey(time, curvePX[0].value);
					curvePY.AddKey(time, curvePY[0].value);
					curvePZ.AddKey(time, curvePZ[0].value);
					curveRX.AddKey(time, curveRX[0].value);
					curveRY.AddKey(time, curveRY[0].value);
					curveRZ.AddKey(time, curveRZ[0].value);
					curveRW.AddKey(time, curveRW[0].value);
				}

				var clip = clipList[j];
				clip.SetCurve(bonePath, typeof(Transform), "localPosition.x", curvePX);
				clip.SetCurve(bonePath, typeof(Transform), "localPosition.y", curvePY);
				clip.SetCurve(bonePath, typeof(Transform), "localPosition.z", curvePZ);
				clip.SetCurve(bonePath, typeof(Transform), "localRotation.x", curveRX);
				clip.SetCurve(bonePath, typeof(Transform), "localRotation.y", curveRY);
				clip.SetCurve(bonePath, typeof(Transform), "localRotation.z", curveRZ);
				clip.SetCurve(bonePath, typeof(Transform), "localRotation.w", curveRW);
			}
		}
		return bones;
	}

	static public Quaternion FromEulerAngles(float pitch, float yaw, float roll)
	{
		var halfX = 0.5f * pitch;
		var halfY = 0.5f * yaw;
		var halfZ = 0.5f * roll;

		var sinX = Mathf.Sin(halfX);
		var cosX = Mathf.Cos(halfX);

		var sinY = Mathf.Sin(halfY);
		var cosY = Mathf.Cos(halfY);

		var sinZ = Mathf.Sin(halfZ);
		var cosZ = Mathf.Cos(halfZ);

		var x = sinX * cosY * cosZ - cosX * sinY * sinZ;
		var y = sinY * cosZ * cosX + cosY * sinZ * sinX;
		var z = sinZ * cosX * cosY - cosZ * sinX * sinY;
		var w = cosX * cosY * cosZ + sinX * sinY * sinZ;

		return new Quaternion(x, y, z, w);
	}
}

