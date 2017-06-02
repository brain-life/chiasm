# Initializing

# Folder with raw and preprocessed data
data=/home/auguser2016/dMRI_DATA

Preparation () {

	# 2 resolutions (1.5 mm and 0.75mm), inside each folder all preprocessed data sets of corresponding resolution with masks, map of distortions etc.
	a=${1::-6}
	
	low_res=PREPROCESSED_DATA/1.5mm_iso/$a
	high_res=PREPROCESSED_DATA/0.75mm_iso/$a

	mkdir $data/$low_res
	mkdir $data/$low_res/Temporal
	mkdir $data/$low_res/Temporal/Distortions

	mkdir $data/$high_res
	mkdir $data/$high_res/Temporal
	
	
	cd $data/RAW_DATA/${1::-1}/s*/

	# Raw data files - DWI and anatomy - unpacked with MRIcron (dcm2nii) as a 4D Nifti images. Raw data goes: RAW_DATA/data_set_name/study.../studies_X/ where important are those with ep2d
	# Transforming Nifti into .mif files and denoising them. Denoising is the very first that should be done - it's results can be viewed.
	
	for b in *ep2d*; do
		cd $b
		mrconvert *a001.nii -stride -1,2,3,4 -fslgrad *.bvec *.bval $data/$low_res/Temporal/$a\_$b\.mif 
		dwidenoise $data/$low_res/Temporal/$a\_$b.mif $data/$low_res/Temporal/$a\_$b\_denoised.mif -noise $data/$low_res/Temporal/Distortions/$a\_$b\_noise.mif -debug
	  	cd ..
	done

	# Script from MRtrix interacting with fsl. Here version for correcting DWI with 2 phase encoding directions is used
	dwipreproc AP  $data/$low_res/Temporal/*AP_denoised.mif -rpe_all $data/$low_res/Temporal/*PA_denoised.mif $data/$low_res/Temporal/$a\_denoised_preproc.mif -export_grad_mrtrix $data/$low_res/Temporal/Distortions/$a\_gradients 
	
	# Masking preprocessed data. Results should be checked
	dwi2mask $data/$low_res/Temporal/$a\_denoised_preproc.mif $data/$low_res/$a\_clean_150mm_mask.mif

	# Masked is used for bias field correction using ANTS software
	dwibiascorrect -ants $data/$low_res/Temporal/$a\_denoised_preproc.mif $data/$low_res/$a\_clean_150mm.mif -mask $data/$low_res/$a\_clean_150mm_mask.mif -bias $data/$low_res/Temporal/Distortions/$a\_bias_field.mif
 
	# Preprocessing of 1.5 mm iso data sets done. Moving to upsampled resolution
	
	# Upsampling by factor of 2 to 0.75mm. Justified step, in FBA even factor 3 can be recommended
	mrresize $data/$low_res/$a\_clean_150mm.mif -scale 2.0 $data/$high_res/$a\_clean_075mm.mif
	
	# Calculating mask again
	dwi2mask $data/$high_res/$a\_clean_075mm.mif $data/$high_res/$a\_clean_075mm_mask.mif

	# Estimating single fibre response (SFR) for default lmax
	dwi2response tournier $data/$high_res/$a\_clean_075mm.mif $data/$high_res/$a\_clean_075mm_SFR.txt -shell 1600 -lmax 8 -mask $data/$high_res/$a\_clean_075mm_mask.mif -voxels $data/$high_res/Temporal/$a\_clean_075mm_SFR_voxels.mif

	# Estimating FOD for previously obtained SFR
	dwiextract $data/$high_res/$a\_clean_075mm.mif - | dwi2fod msmt_csd - $data/$high_res/$a\_clean_075mm_SFR.txt $data/$high_res/$a\_clean_075mm_FOD.mif -mask $data/$high_res/$a\_clean_075mm_mask.mif

	# Performing coregistration of anatomical image to DWI images and segmenting it. It's easier approach as gradient table is not rotated this way. However for cross-modal studies it would be better to register DWI to anatomy

	cd *MPRAGE*iso
	
	# Converting DWI image from .mif to .nii.gz as FSL likes. This step should be checked as well.
	mrconvert $data/$high_res/$a\_clean_075mm.mif $data/$high_res/Temporal/$a\_clean_075mm.nii.gz
	
	# Coping anatomical image to corresponding folder
	cp o* $data/$high_res/$a\_anatomical.nii.gz

	# Extracting clean brain from anatomical image. Check this step
	bet2 $data/$high_res/$a\_anatomical.nii.gz $data/$high_res/Temporal/$a\_anatomical_brain.nii.gz -f 0.6  	
	
	# Corregister DWI to anatomy
	epi_reg --epi=$data/$high_res/Temporal/$a\_clean_075mm.nii.gz --t1=$data/$high_res/$a\_anatomical.nii.gz --t1brain=$data/$high_res/Temporal/$a\_anatomical_brain.nii.gz --out=$data/$high_res/Temporal/$a\_nodif2mprage_2 --echospacing=0.00023 --pedir=-y

	# Reverse corregistration matrix
	convert_xfm -inverse $data/$high_res/Temporal/$a\_nodif2mprage_2.mat -omat $data/$high_res/Temporal/$a\_mprage2nodif_2.mat

	# Apply reverted matrix to corregister anatomy to DWI
	flirt -in $data/$high_res/$a\_anatomical.nii.gz -ref $data/$high_res/Temporal/$a\_clean_075mm.nii.gz -out $data/$high_res/$a\_075mm_anatomical_coreg2nodif_undist_2 -applyxfm -init $data/$high_res/Temporal/$a\_mprage2nodif_2.mat -interp sinc -sincwidth 7 -sincwindow hanning

	# Perform segmentation into WM, GM, subcortical GM, CSF and possible pathological tissue using FIRST from FSL
	5ttgen fsl $data/$high_res/$a\_075mm_anatomical_coreg2nodif_undist_2.nii.gz $data/$high_res/$a\_075mm_5tt.nii.gz

}

cd $data/RAW_DATA

# List of all data_sets used in studies
list=(fe21_1325/ hw91_0844/ ib57_0731/ kw99_0633/ lw37_0977/ nb30_1185/ ow93_0974/ ps94_1516/ rx88_1234/ sj22_1218/ ta14_1065/ tq63_1214/ xs62_1217/ xn78_1085/ uh47_1309/ uf97_1072/ ow93_0974/ )
#list=(fe21_1325/)

# This way 4 sets are processed at once - we can't process all at once due to RAM usage, however preprocessing one at a time is ineffective because e.g. eddy from dwipreproc is using only one core. There is a version of eddy operating on multicore processors, but it's not running on this machine

for i in ${list[@]:0:3}; do Preparation $i & done
wait
for i in ${list[@]:3:6}; do Preparation $i & done
wait
for i in ${list[@]:6:9}; do Preparation $i & done
wait
for i in ${list[@]:9:12}; do Preparation $i & done
wait
for i in ${list[@]:12:15}; do Preparation $i & done
wait
for i in ${list[@]:15:18}; do Preparation $i & done
wait
for i in ${list[@]:18:21}; do Preparation $i & done
wait
for i in ${list[@]:21:24}; do Preparation $i & done
wait
for i in ${list[@]:24:27}; do Preparation $i & done
wait
for i in ${list[@]:27:30}; do Preparation $i & done
wait
for i in ${list[@]:30:33}; do Preparation $i & done
wait

# Returning to original folder
cd /home/auguser2016/Scripts/

