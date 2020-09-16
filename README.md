Introdution
Behavior Atlas is a spatio-temporal decomposition framework for automatically detecting behavioral phenotypes. It receives 3D/2D continuous multidimensional motion features data input, and unsupervisedly decompose it into understandable behavioral modules/movements (e.g., walking, running, rearing). Our framework emphasizes the extraction of the temporal dynamics of movements. Without making model assumptions, similar movements with various time durations and temporal variability can be efficiently detected. Besides the decomposition, the constructed self-similarity matrix of these movement segments describes the structure of involved movements. Further dimensionality reduction and visualization enable us construct the feature space of behavior. This helps us study the evolution of movement sequences for higher-order behavior and behavioral state transition caused by neural activity.

Features
1. The real 3D reconstruction of animal poses with a high signal-to-noise ratio
a. Capturing Image streams from four cameras with different 2D views;
b. Using DeepLabCut (DLC) to track animal body parts and generate 2D skeletal trajectories separately (color-coded traces);
c. Reconstructing 3D body skeleton by integrating these four data streams (based on pose3d).
Your browser does not support the video tag.
Video1 | 3D reconstruction demo video, Download this video Video1-3D_Capture_and_recons_demo.mp4 (11.6MB)

The pipeline of 3D animal skeletal reconstruction

Figure1 | The pipeline of 3D animal skeletal reconstruction.

representative (900s) mouse body tracking trace data showing with 48 data vectors obtained by 3D reconstruction

Figure2 | Representative (900s) mouse body tracking trace data showing with 48 data vectors obtained by 3D reconstruction.

2. Parallel and two-layer framework for motion feature decomposition.
There are many similar previous works such as MotionMapper, Moseq were used to detect stereotyped movement modules on flies or mice. Our framework focus on address the high-dimensionality and large temporal variability of rodent behavior. we adopted a parallel motion decomposition strategy following the natural characteristics of animal motion. That is, two-layer dynamic temporal decomposition is performed on the continuous animal skeleton postural data to obtain Non-locomotor movement (NM) space. Finally, together with locomotion dimension, unsupervised clustering is used to reveal the structure of behavior.

Spatio-temporal decomposition framework for animal behavior analysis fig1

Figure3 | Spatio-temporal decomposition framework for animal behavior analysis.

3. Mapping Mouse Movements with Low-Dimensional Embeddings and Unsupervised Clustering
We demonstrate our framework in 15-minute experimental data collected in a featureless circular open-filed. Thus, we obtained 11 types (determined by Bayesian Information Criterion ) of movement.

Video2 | Decomposition demo of 15-minute experimental data collected in a featureless circular open-filed Video2-decomposition_demo.mp4 (68.2MB) (CQI: Clustering Quality Index helps us determine the stereotyped/non-stereotyped movements. CQI is evaluated by integrated the intra-cluster and inter-cluster correlation coefficients. Larger CQI indicates more stereotyped movement segment)
