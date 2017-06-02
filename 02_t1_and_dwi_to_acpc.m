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

for i=3:size(subjects,1)
    
    id=subjects(i).name
    %id='hw91'
    % Prepare data in form acceptable by dtiInit
    
    % ACPC registerred T1 image
    anatomy=strcat('/home/auguser2016/Projects/Chiasm_RJP_FP_ACPC/',id,'/',id,'_t1_acpc.nii.gz')
    
    % Diffusion Data (motion, eddy and geometrical distortions corrected)
    dwi=strcat('/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/1.5mm_iso/',id,'/',id,'_clean_150mm.nii.gz')
    
    % Bvecs and bvals obtained from corrected DW images
    bvecs=strcat('/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/1.5mm_iso/',id,'/',id,'_bvecs.bvecs')
    bvals=strcat('/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/1.5mm_iso/',id,'/',id,'_bvals.bvals')
    
    %bvecs_rot = dlmread(bvecs);
    %bvecs_rot(1,:) = -bvecs_rot(1,:);
    %dlmwrite(strcat('/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/1.5mm_iso/',id1,'/',id,'_bvecs_rot.bvecs'),bvecs_rot)
    %bvecs=strcat('/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/1.5mm_iso/',id1,'/',id,'_bvecs_rot.bvecs')
    
    %bvecs_rot = dlmread(bvecs);
    %bvecs_rot(2,:) z= -bvecs_rot(2,:);
    %dlmwrite(strcat('/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/1.5mm_iso/',id1,'/',id,'_bvecs_rot.bvecs'),bvecs_rot)
    %bvecs=strcat('/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/1.5mm_iso/',id1,'/',id,'_bvecs_rot.bvecs')
  
% %przypomnienie, że bveci to ważna sprawa i możliwe, że mam filpa na osi y
%     bvecs_rot = dlmread(bvecs);
%     bvecs_rot(2,:)=-bvecs_rot(2,:);
%     dlmwrite(strcat('/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/1.5mm_iso/',id,'/',id,'_bvecs_rot.bvecs'), bvecs_rot)
    
    % Output directory
    output=strcat('/home/auguser2016/Projects/Chiasm_RJP_FP_ACPC/',id,'/')
    
    % Set up dtiInit paramters specific for our study
    dwParams = dtiInitParams;
    dwParams.rotateBvecsWithRx = 1;
    dwParams.rotateBvecsWithCanXform = 1;
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
    
     mrtrix_bfileFromBvecs(strcat('/home/auguser2016/Projects/Chiasm_RJP_FP_ACPC/',id,'/',id,'_clean_150mm_aligned_trilin_noMEC.bvecs'),strcat('/home/auguser2016/Projects/Chiasm_RJP_FP_ACPC/',id,'/',id,'_clean_150mm_aligned_trilin_noMEC.bvals'),strcat('/home/auguser2016/Projects/Chiasm_RJP_FP_ACPC/',id,'/',id,'_mrtrix_grad_table.b'))

     end

     %pathToScript = fullfile('/media/auguser2016/Volume/Test/chiasm','04_postprocess.sh'); 
     %cmdStr = sprintf('%s', pathToScript);
     %system(cmdStr);
