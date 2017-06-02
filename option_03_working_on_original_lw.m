% Add required folders to path
addpath(genpath('/home/auguser2016/Software/spm12'))
addpath(genpath('/home/auguser2016/Software/vistasoft-master'))
addpath(genpath('/home/auguser2016/Software/mba'))
addpath(genpath('/home/auguser2016/Software/encode'))

% ACPC registration for T1 in each data set performed manually
% Done manually

% Perform Diffusion Imaging Processing for all data sets
cd /home/auguser2016/Projects/Chiasm_RJP_FP_ACPC/
subjects=dir

for i=5:size(subjects,1)
    
    id=subjects(i).name
    % Prepare data in form acceptable by dtiInit
    
    % ACPC registerred T1 image
    anatomy=strcat('/home/auguser2016/Projects/Chiasm_RJP_FP_ACPC/',id,'/',id,'_t1_acpc.nii.gz')
    
    % Diffusion Data (motion, eddy and geometrical distortions corrected)
    dwi=strcat('/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/1.5mm_iso/',id,'/',id,'_clean_150mm.nii.gz')
    
    % Bvecs and bvals obtained from corrected DW images
    bvecs=strcat('/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/1.5mm_iso/',id,'/',id,'_bvecs.bvecs')
    bvals=strcat('/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/1.5mm_iso/',id,'/',id,'_bvals.bvals')
  
    % Output directory
    output=strcat('/home/auguser2016/Projects/Chiasm_RJP_FP_ACPC/',id,'/')
    
    % Set up dtiInit paramters specific for our study
    dwParams = dtiInitParams;
    dwParams.rotateBvecsWithRx = 1;
    dwParams.rotateBvecsWithCanXform = 0;
    dwParams.bvecsFile = fullfile(bvecs);
    dwParams.bvalsFile = fullfile(bvals);
    dwParams.eddyCorrect = -1;
    dwParams.dwOutMm = [0.75 0.75 0.75]; % change this to 1.5 and process 0.75 anyway
    %dwParams.dwOutMm = [1.5 1.5 1.5];
    dwParams.phaseEncodeDir = 2;
    dwParams.outDir=output
    %dwParams.outDir = fullfile(pwd,'dtiInitPreprocessed');

    % Start Diffusion Imaging preprocessing.
    [dt6FileName, outBaseDir] = dtiInit(dwi,...
                                        anatomy, ...
                                        dwParams); 
end
