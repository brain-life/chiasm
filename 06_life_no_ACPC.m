% Add required folders to path
addpath(genpath('/home/auguser2016/Software/spm12'))
addpath(genpath('/home/auguser2016/Software/vistasoft-master'))
addpath(genpath('/home/auguser2016/Software/mba'))
addpath(genpath('/home/auguser2016/Software/encode'))

% Define participant
subj ='kw99'

% Define relevant folders
general_data=strcat('/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/0.75mm_iso/',subj,'/')
specific_data=strcat('/home/auguser2016/Projects/Chiasm_RJP_FP/',subj,'/')
current = pwd

cd(general_data)

% Build the file names for the diffusion data, the anatomical MRI.
dwiFile       = fullfile(strcat(general_data,subj,'_clean_075mm.nii.gz'));
dwiFileRepeat = fullfile(strcat(general_data,subj,'_clean_075mm.nii.gz'));
t1File        = fullfile(strcat(general_data,subj,'_075mm_anatomical_coreg2nodif_undist_2.nii.gz'));
fgFileName = fullfile(strcat(specific_data,'Tractography_dwi/',subj,'_ACT.tck'));
%fgFileName = fullfile(strcat(specific_data,'Tractography/',subj,'_good.tck'));

% The final connectome and data astructure will be saved with this name:
feFileName    = 'test_ensemble_tracking';

L = 360; % Discretization parameter
fe = feConnectomeInit(dwiFile,fgFileName,feFileName,[],dwiFileRepeat,t1File,L,[0,1]);

Niter = 500;
fe = feSet(fe,'fit',feFitModel(feGet(fe,'model'),feGet(fe,'dsigdemeaned'),'bbnnls',Niter,'preconditioner'));

% Remove non zero weighted fascicles
fg = feGet(fe,'fibers acpc');
w = feGet(fe,'fiber weights');
positive_w = w > 0;
fg = fgExtract(fg, positive_w, 'keep');

cd(specific_data)
fgWrite(fg,strcat(subj,'_dwi_filtered.mat'))

% Use MBA to visualize
colors     = {[.75 .25 .1]};
viewCoords = [90,0];
proportion_to_show = .05;
threshold_length   = 10;
slices     = {[18 0 0],[0 -40 0],[0 0 -14]}; % Values in mm from AC 

% Prepare the plot of tract
fg = rmfield(fg,'coordspace');

% Pick a percentage of fascicles to display (the PN can be too dense for visualization).
%fibs_indx = RandSample(1:length(fg.fibers),round(length(fg.fibers)*proportion_to_show));
%fg.fibers = fg.fibers(1:1000); 

% Display fascicles and anatomy
fig_h = figure('name','Whole Brain','color','k');
hold on

% display anatomy
%t1 = niftiRead(t1File);
%h  = mbaDisplayBrainSlice(t1, slices{1});
%h  = mbaDisplayBrainSlice(t1, slices{2});

% Display fasciles
set(gca,'visible','off','ylim',[-108 69],'xlim',[-75 75],'zlim',[-45 78],'Color','w')
[~, light_h] = mbaDisplayConnectome(fg.fibers,fig_h,colors{1},'single');
delete(light_h)
view(viewCoords(1),viewCoords(2))
light_h = camlight('right');
lighting phong;
%set(fig_h,'Units','normalized', 'Position',[0.5 .2 .4 .8]);
set(gcf,'Color',[1 1 1])
drawnow

%quit

% save figure to disk
%print(fig_h,'my_figure','-dpng','-r600');%'-dpsc2')