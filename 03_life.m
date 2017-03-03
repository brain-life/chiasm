
% Build the file names for the diffusion data, the anatomical MRI.
dwiFile       = fullfile('/media/auguser2016/Volume/Test','lw37_aligned_trilin.nii.gz');
dwiFileRepeat = fullfile('/media/auguser2016/Volume/Test','lw37_aligned_trilin.nii.gz');
t1File        = fullfile('/media/auguser2016/Volume/Test/anatomy','t1_acpc.nii.gz');
fgFileName = fullfile('/media/auguser2016/Volume/Test','lw_et.tck')         

% The final connectome and data astructure will be saved with this name:
feFileName    = 'test_ensemble_tracking';

L = 360; % Discretization parameter
fe = feConnectomeInit(dwiFile,fgFileName,feFileName,[],dwiFileRepeat,t1File,L,[1,0]);

Niter = 500;
fe = feSet(fe,'fit',feFitModel(feGet(fe,'model'),feGet(fe,'dsigdemeaned'),'bbnnls',Niter,'preconditioner'));
