function behavior_decomposing(BeA_DecParam)

% perform 3-layer (poses, movements, ethograms) behavior decomposition
%
% Input
%   BeA_DecParam       -  parameters for behavior decomposition
%       - BeA_DecParam.paraP	-  parameters for layer 1
%           - calg          -  clustering algorithm type, {'kmeans'} | 'density'
%           - ralg          -  reduction algorithm type, {'merge'} | 'ave'
%           - redL          -  maximum segment length
%           - kF            -  frame cluster, needed if the calg is 'kmeans'
%       - BeA_DecParam.paraM	-  parameters for layer 2
%           - kerType       -  kernel type, 'g' | 'st' | 'bi'
%           	'g':  Gaussian kernel
%               'st': Self Tunning kernel. See the paper in NIPS 2004, Self-Tuning Spectral Clustering
%               'bi': Bipartite Maximum Weight Matching. See the paper in AISTAT 2007,
%                     Loopy Belief Propagation for Bipartite Maximum Weight b-Matching
%           - kerBand       -  #nearest neighbour to compute the kernel bandwidth, {.1}
%               0: binary kernel
%               NaN: set bandwidth to 1
%           - k             -  class number of layer 2.
%           - nMi           -  minimum length of every motifs
%           - nMa           -  maximum length of every motifs
%           - Ini           -  initialization method of layer 2
%
% Output
%   global BeA.BeA_DecData
%       - BeA_DecData.K     - PxP matrix saving the distance matrix.
%       - BeA_DecData.paraP    - BeA data of layer 1
%           ReMap:          - mapping list of layer 1 with data
%           Seglist:        - decomposition results of layer 1
%           MedData:        - intermediate variables
%       - BeA_DecData.paraM    - BeA data of layer 2
%           ReMap:          - mapping list of layer 2 with data
%           Seglist:        - decomposition results of layer 2
%           MedData:        - intermediate variables
% History
%   create  -  Kang Huang  (kang.huang@siat.ac.cn), 03-02-2020
%   modify  -  Yaning Han  (yn.han@siat.ac.cn), 07-16-2020

%% Initialize para for decompostion
global BeA

timer_all = clock;
fs = BeA.DataInfo(1).VideoInfo.FrameRate;

paraP.k = BeA_DecParam.paraP.kF;
paraP.kF = paraP(1,1).k;
paraP.redL = BeA_DecParam.paraP.redL;
paraP.calg = BeA_DecParam.paraP.calg;
paraP.ralg = BeA_DecParam.paraP.ralg;

paraM.k = BeA_DecParam.paraM.k;
paraM.kF = 'f';
paraM.nMi = round((fs*BeA_DecParam.paraM.nMi/1000) / (paraP.redL));
paraM.nMa = round((fs*BeA_DecParam.paraM.nMa/1000) / (paraP.redL));
paraM.ini = BeA_DecParam.paraM.Ini;
paraM.nIni = 1;
paraM.kerType = 'g';
paraM.kerBand = 'nei';

selIdx = BeA_DecParam.selection;
data = BeA.BeA_DecData.XYZ(selIdx==1, :);

%% Decompose poses
timer = clock;
[DP_sR, DP_X, DP_XD, DP_XD0, G1] = decompose_poses(data, paraP);
addMes2log(1, ['Decomposing poses, time elapse: ' num2str(etime(clock,timer)) 'seconds'], 0, 1)

%% Calculating kernel matrix
timer = clock;
D = conDist(DP_X, DP_X);
if ~isfield(BeA_DecParam.paraM, 'sigma')
    nei = ps([], paraM.kerBand, .1);
    BeA_DecParam.paraM.sigma = bandG(D, nei);
end
paraM.sigma = BeA_DecParam.paraM.sigma;
K = conKnl_DTAK(D, paraM.kerType, paraM.kerBand, paraM.sigma);
addMes2log(1, ['Calculating kernel matrix, time elapse: ' num2str(etime(clock,timer)) 'seconds'], 0, 1)

%% Decompose self movements
timer = clock;
segDM = decompose_Movement(K, paraM);
addMes2log(1, ['Decomposing movements and ethograms, time elapse: ' num2str(etime(clock,timer)) 'seconds'], 0, 1)

%% Results transfer
decBehavior = segDM; % initialize decBehavior
decBehavior(2) = segDM;
decBehavior(1).s = DP_sR;
decBehavior(1).sH = DP_sR;
decBehavior(1).G = G1;
decBehavior(1).tim = [];
decBehavior(1).obj = [];
decBehavior(1).T = K;

Seg_cell = cell(2,1);
Seglist = DP_XD0;
Seg_cell{1,1} = Seglist;

TRL = segDM.s;
MapFL = DP_sR;
TFL = 0.*TRL;
for m = 1:size(TRL,2)
    for n = 1:size(MapFL,2)
        if n == TRL(1,m)
            TFL(1,m) = MapFL(1,n);
        end
    end
end
decBehavior(2).s = TFL;
decBehavior(2).G = segDM.G;
Seglist = SegBarTrans(decBehavior(2));
Seg_cell{2,1} = Seglist;

%% Save results

BeA_DecData.K = K;
BeA_DecData.DP_X = DP_X;
BeA_DecData.paraP.ReMap = decBehavior(1).s;
BeA_DecData.paraP.Seglist = Seg_cell{1};
BeA_DecData.paraP.MedData = decBehavior(1);
BeA_DecData.paraM.ReMap = decBehavior(2).s;
BeA_DecData.paraM.Seglist = Seg_cell{2};
BeA_DecData.paraM.MedData = decBehavior(2);

BeA_DecData.XY = BeA.BeA_DecData.XYZ;

BeA_DecParam.paraP = paraP;
BeA_DecParam.paraM = paraM;
BeA.BeA_DecData = BeA_DecData;
BeA.BeA_DecParam = BeA_DecParam;

addMes2log(1, ['Decomposing completed, time elapse: ' num2str(etime(clock, timer_all)) 'seconds'], 0, 1)





