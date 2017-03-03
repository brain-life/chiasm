% Set up dtiInit paramters specific for our study
dwParams = dtiInitParams;
dwParams.rotateBvecsWithRx = 1;
dwParams.rotateBvecsWithCanXform = 1;
dwParams.bvecsFile = fullfile('/media/auguser2016/Volume/Test/lw_bvecs.bvecs');
dwParams.bvalsFile = fullfile('/media/auguser2016/Volume/Test/lw_bvals.bvals');
dwParams.eddyCorrect = -1;
dwParams.dwOutMm = [1.5 1.5 1.5];
dwParams.phaseEncodeDir = 2;
dwParams.outDir = fullfile(pwd,'dtiInitPreprocessed');

% Start Diffusion Imaging preprocessing.
[dt6FileName, outBaseDir] = dtiInit('/media/auguser2016/Volume/Test/lw37.nii.gz',...
                                    '/media/auguser2016/Volume/Test/anatomy/t1_acpc.nii.gz', ...
                                    dwParams);