clear all
genPath = genpath('./');
addpath(genPath)

%% get filename
filepath = '..\..\data\single_experiment';
fileName = 'demo_single_Data3d.mat';

%% get videoname
videopath = '..\..\data\single_experiment';
videoName = 'demo_single_Data3d.mp4';

%% Import dataset
clear global
global BeA
data_3d_name = [filepath,'\',fileName];
import_3d(data_3d_name);

%% Import dataset
video_name = [videopath,'\',videoName];
import_video(video_name);

%% Preprocess ->  Artifact Correction
method = 'median filtering';
WinWD = 1000; %ms
artifact_correction(method, WinWD);

%% Aanlysis  -> 1. body alignment
BA.Cen = 1;
BA.VA = 1;
BA.CenIndex = 13;
BA.VAIndex = 14;
BA.SDSize = 25;
BA.SDSDimens = [40,41,42];
body_alignment(BA);
BeA_DecParam = BeA.BeA_DecParam;
%% Aanlysis -> 2. Feature Selection

body_parts = BeA.DataInfo.Skl;
nBodyParts = length(body_parts);
weight = ones(1, nBodyParts);
featNames = body_parts';
selection = [1,1,1,1,1,1,1,1,...
            1,1,1,1,1,1,1,1,...
            1,1,1,1,1,1,1,1,...
            1,1,1,1,1,1,1,1,...
            1,1,1,1,0,0,1,1,...
            0,1,0,0,0,0,0,0];

for i = 1:nBodyParts
    BeA_DecParam.FS(i).featNames = body_parts{i};
    BeA_DecParam.FS(i).weight = weight(i);
end
BeA_DecParam.selection = selection;
%% Aanlysis -> Behavior Decomposing

% BeA_SegParam.paraP
BeA_DecParam.paraP.ralg = 'merge';
BeA_DecParam.paraP.redL = 5;
BeA_DecParam.paraP.calg = 'density';
BeA_DecParam.paraP.kF = 96;

% BeA_SegParam.paraM
BeA_DecParam.paraM.kerType = 'g';
BeA_DecParam.paraM.kerBand = 'nei';
BeA_DecParam.paraM.k = 30; % Number of segment types
BeA_DecParam.paraM.nMi = 100; % Minimum lengths (ms)
BeA_DecParam.paraM.nMa = 2000; % Maximum lengths (ms)
BeA_DecParam.paraM.Ini = 'p'; % Initialization method

behavior_decomposing(BeA_DecParam);

%% Reclustering movements with velocity dimension
kR = 11; % Number of cluster
labels = recluster_Movement(BeA.BeA_DecData.paraM.MedData, kR);

BeA.reClusData = BeA.BeA_DecData.paraM.MedData;
BeA.reClusData.G = L2G_Slow(labels);
BeA.reClusData.kR = kR;

% Saving
disp('saving, please wait......')
save(['..\..\data\single_experiment\', fileName(1:end-4), '_BeA_Struct.mat'], 'BeA', '-v7.3')
disp('save successfully!')

%% Segmenting video (optional)

% savepath = '..\..\data\single_experiment';
% seg_video(savepath)
    

