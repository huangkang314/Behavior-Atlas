# Data Formatting Standards
**General:** Data for analysis are stored and manipulated as structures, which contain all relevant information necessary to work with that data and are in .mat files, in which commonly used data types have a standardized format as outlined in this document.
**File Name:** [fileName]_BeA_Struct.mat
**Table of Contents:** Struct Varibles

[TOC]

## DataInfo
This struct contains all the information of animal behavior videos.
**Defined struct fields:**
* DataInfo.FileName: Px1 vector listing the name of data files
* DataInfo.FilePath: Px1 vector listing the path of data files
* DataInfo.VideoName: Px1 vector listing the name of videos to analysis
* DataInfo.VideoPath: Px1 vector listing the videos' path
* DataInfo.VideoInfo: the same as VideoReader object
* DataInfo.Skl: Mx1 cell listing the definition of animal skeleton
* DataInfo.Source: Indicates the type of data source
  * '3d': the data from 3D skeleton reconstruction


## RawData
This struct contains the corresponding raw data of DataInfo
**Defined struct fields:**
* RawData.X: NxM matrix saving the x-coordinate data of skeletions. N is time point, M is dimension.
* RawData.Y: NxM matrix saving the y-coordinate data of skeletions. N is time point, M is dimension.
* RawData.Z: NxM matrix saving the z-coordinate data of skeletions. N is time point, M is dimension.

## PreproInfo
This struct contains the preprocessing workflow of raw data.
**Defined struct fields:**
* PreproInfo.QC: saving the evaluated quality of 3D data.
* PreproInfo.Eng: saving the evaluated quality parameters (represented by the signal energy of the time-series).
  * PreproInfo.Eng.Noise: saving the evaluated noise of the 3D data.
  * PreproInfo.Eng.All: saving the evaluated overall energy of the 3D data.
  * PreproInfo.Eng.Effect: saving the evaluated signal of the 3D data.
* PreproInfo.AC: saving the artifact correction parameters.
  * PreproInfo.AC.LH: mark noise points by likelihood.
    * PreproInfo.AC.LH.Flag: bool variable, 1 is on, 0 is off.
    * PreproInfo.AC.LH.Seq: integer variable mark the sequence of the preprocessing method application, 1 is the first.
    * PreproInfo.AC.LH.Param: struct saving the parameters of likelihood method
      * PreproInfo.AC.LH.Param.Thres: double varible saving the threshold of likelihood method
  * PreproInfo.AC.MP: mark noise frame by animal morphological detection
    * PreproInfo.AC.MP.Flag: bool variable, 1 is on, 0 is off.
    * PreproInfo.AC.MP.Seq: integer variable mark the sequence of the preprocessing method application, 1 is the first.
    * PreproInfo.AC.MP.Param: struct saving the parameters of morphological method
      * PreproInfo.AC.MP.Param.MinThres: double varible saving the mininum threshold of morphological method
      * PreproInfo.AC.MP.Param.MaxThres: double varible saving the maxinum threshold of morphological method
  * PreproInfo.AC.MF: median filtering of the whole data
    * PreproInfo.AC.MF.Flag: bool variable, 1 is on, 0 is off.
    * PreproInfo.AC.MF.Seq: integer variable mark the sequence of the preprocessing method application, 1 is the first.
    * PreproInfo.AC.MF.Param:  struct saving the parameters of median filtering
      * PreproInfo.AC.MF.Param.WinWD: double varible saving the window width of median filtering
  * PreproInfo.AC.NMF: median filtering of the noise data
    * PreproInfo.AC.NMF.Flag: bool variable, 1 is on, 0 is off.
    * PreproInfo.AC.NMF.Seq: integer variable mark the sequence of the preprocessing method application, 1 is the first.
    * PreproInfo.AC.NMF.Param:  struct saving the parameters of median filtering for noise data
      * PreproInfo.AC.NMF.Param.WinWD: double varible saving the window width of median filtering for noise data
  * PreproInfo.AC.AMF: adaptive median filtering of the whole data
    * PreproInfo.AC.AMF.Flag: bool variable, 1 is on, 0 is off.
    * PreproInfo.AC.AMF.Seq: integer variable mark the sequence of the preprocessing method application, 1 is the first.
    * PreproInfo.AC.AMF.Param:  struct saving the parameters of adaptive median filtering
      * PreproInfo.AC.AMF.Param.WinWD: double varible saving the window width of adaptive median filtering


## PreproData
This struct contains the preprocessing data.
**Defined struct fields:**
* PreproData.X: NxM matrix saving the x-coordinate data of skeletions. N is time point, M is dimension.
* PreproData.Y: NxM matrix saving the y-coordinate data of skeletions. N is time point, M is dimension.
* PreproData.Z: NxM matrix saving the z-coordinate data of skeletions. N is time point, M is dimension.

## BeA_DecParam
This struct contains the parameters of Behavior_Atlas decomposition.
**Defined struct fields:**
* BeA_DecParam.BA: struct variable, saving the parameters of body alignment
  * BeA_DecParam.BA.Cen: bool variable, the flag of centering skeleton. 1 is on, 0 is off.
  * BeA_DecParam.BA.VA: bool variable, the flag of skeleton vector align. 1 is on, 0 is off.
  * BeA_DecParam.BA.CenIndex: integral variable, saving the index of center point
  * BeA_DecParam.BA.VAIndex: integral variable, saving the index of vector point
  * BeA_DecParam.BA.SDSize: integral variable, scale the distance from tail root to back,normalize it to SDSize mm (usually 25 mm)
  * BeA_DecParam.BA.SDSDimens: integral variable, saving the XYZ index of tail root
* BeA_DecParam.FS: struct varible, saving the parameters of body parts features selection
  * BeA_DecParam.FS.featNames: same to DataInfo.Skl, listing the definition of animal skeleton
  * BeA_DecParam.FS.weight: double varible, saving the weight of the corresponding feature
* BeA_DecParam.selection: bool varible, saving the flag if corresponding feature is selected
* BeA_DecParam.paraP: saving BeA parameters of pose decomposition
  * BeA_DecParam.paraP.ralg: string varible, saving the clustering method for pose decomposing
  * BeA_DecParam.paraP.redL: double varible, maximum segment length of a unique pose
  * BeA_DecParam.paraP.calg: string varible, saving the method for pose decomposing
    * 'kmeans': k-means method for pose decomposing
    * 'density': density cluster for pose decomposing
  * BeA_DecParam.paraP.kF: integral varible, saving the frame cluster, needed if the `calg` is 'kmeans'. 
* BeA_DecParam.paraM: saving BeA parameters of movement decomposition.
  *  BeA_DecParam.paraM.kerType: string varible, saving the kernel type for  kernel matrix calculating.
  *  BeA_DecParam.paraM.kerBand:  string varible, saving the kernel band for  kernel matrix calculating.
  *  BeA_DecParam.paraM.k: integral variable saving class number of movement decomposition.
  *  BeA_DecParam.paraM.nMi: integral varible saving the minimum length of every motifs.
  *  BeA_DecParam.paraM.nMa: integral varible saving the maximum length of every motifs.
  *  BeA_DecParam.paraM.Ini: char varible indicating the initialization method of movement decomposition decomposition, 'p' for pectral clustering, 'r' for random initialization.
  *  BeA_DecParam.paraM.sigma: double varible saving the kernel bandwidth for calculating kernel matrix


## BeA_DecData
This struct contains the data of Behavior_Atlas decomposition.
**Defined struct fields:**
* BeA_DecData.XY: MxN matrix saving the processed dimension of data. M is the number of dimensions, N is the number of time points.
* BeA_DecData.K: PxP matrix saving the distance matrix.
* BeA_DecData.paraP: saving the BeA data of pose decomposition
  * BeA_DecData.paraP.ReMap: saving the mapping list of pose decomposition with data
  * BeA_DecData.paraP.Seglist: saving the decomposition results of pose decomposition
  * BeA_DecData.paraP.MedData: a struct saving the intermediate variables of different decomposition methods
* BeA_DecData.paraM: saving the BeA data of movement decomposition
  * BeA_DecData.paraM.velnm: averaged velocity of each segments after normalization
  * BeA_DecData.paraM.ReMap: saving the mapping list of movement decomposition with data
  * BeA_DecData.paraM.Seglist: saving the decomposition results of movement decomposition
  * BeA_DecData.paraM.reClusData: a struct saving the variable of reclustering movements with velocity dimension
  * BeA_DecData.paraM.MedData: a struct saving the intermediate variable of movement decomposition (self-movement space)
* BeA_DecData.DP_X: DxS matrix, saving the results of postural decomposition, D dimensions after dimensionality reduction, S number of time series after removing the temporal redunancy 

## BeA_MapData
This struct contains the data of Behavior_Atlas mapping.
**Defined struct fields:**
* BeA_MapData.paraM: saving the BeA mapping data of movement decomposition


## reClusData
This struct contains the data after re-clustering.
**Defined struct fields:**
* reClusData.s: the segments start and end index mapped to the raw pose series
* reClusData.sH: the segments start and end index mapped to the decomposed pose representations
* reClusData.G: cluster labels reprsented with matrix
* reClusData.T: segment kernel matrix
* reClusData.kR: Number of cluster



