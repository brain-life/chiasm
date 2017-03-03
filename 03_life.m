
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

% Remove non zero weighted fascicles
fg = feGet(fe,'fibers acpc');
w = feGet(fe,'fiber weights');
positive_w = w > 0;
fg = fgExtract(fg, positive_w, 'keep');

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
fg.fibers = fg.fibers(1:2000);

% Display fascicles and anatomy
fig_h = figure('name','Whole Brain','color','k');
hold on

% display anatomy
t1 = niftiRead(t1File);
%h  = mbaDisplayBrainSlice(t1, slices{1});
%h  = mbaDisplayBrainSlice(t1, slices{2});

% Disdplay fasciles
set(gca,'visible','off','ylim',[-108 69],'xlim',[-75 75],'zlim',[-45 78],'Color','w')
[~, light_h] = mbaDisplayConnectome(fg.fibers,fig_h,colors{1},'single');
delete(light_h)
view(viewCoords(1),viewCoords(2))
light_h = camlight('right');
lighting phong;
%set(fig_h,'Units','normalized', 'Position',[0.5 .2 .4 .8]);
set(gcf,'Color',[1 1 1])
drawnow

% save figure to disk
print(fig_h,'my_figure','-dpng','-r600');%'-dpsc2')
