Check_preprocessing () {

subj=$1

low_res=/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/1.5mm_iso/$subj
high_res=/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/0.75mm_iso/$subj

# View denoising maps. The less anatomical structures are visible the better
mrview $low_res/Temporal/Distortions/$subj\_series*

# Compare DWI before and after denoising for each encoding direction
mrview $low_res/Temporal/*AP.mif $low_res/Temporal/*AP_denoised.mif
mrview $low_res/Temporal/*PA.mif $low_res/Temporal/*PA_denoised.mif

# Compare mrtrix gradient for corrected DWI with original gradient table
mrinfo $low_res/Temporal/$subj\_*AP_denoised.mif -export_grad_fsl $low_res/Temporal/bvecs $low_res/Temporal/bvals
gedit $low_res/Temporal/bvecs &
gedit $low_res/Temporal/Distortions/$subj\_gradients &
gedit /home/auguser2016/dMRI_DATA/RAW_DATA/$subj*/s*/*ep2d*/*.bvec
rm $low_res/Temporal/bvecs $low_res/Temporal/bvals

# Compare DWI before and after dwipreproc
mrview $low_res/Temporal/*AP.mif $low_res/Temporal/*PA.mif $low_res/Temporal/$subj\_denoised_preproc.mif

# View mask used for bias field correction
mrview $low_res/Temporal/$subj\_denoised_preproc.mif -overlay.load  $low_res/$subj\_clean_150mm_mask.mif -overlay.opacity 0.2 -overlay.colourmap 3

# View bias field
mrview $low_res/Temporal/Distortions/$subj\_bias_field.mif

# View DWI before and after bias correction
mrview $low_res/Temporal/$subj\_denoised_preproc.mif $low_res/$subj\_clean_150mm.mif

# View normal and upsampled images
mrview $low_res/$subj\_clean_150mm.mif $high_res/$subj\_clean_075mm.mif

# View upsampled mask
mrview $high_res/$subj\_clean_075mm.mif -overlay.load  $high_res/$subj\_clean_075mm_mask.mif -overlay.opacity 0.2 -overlay.colourmap 3

# View SFR estimation voxels
mrview $high_res/$subj\_clean_075mm.mif -overlay.load $high_res/Temporal/$subj\_clean_075mm_SFR_voxels.mif

# View SFR
shview $high_res/$subj\_clean_075mm_SFR.txt

# View anatomical image overlaid on DWI
mrview $high_res/$subj\_clean_075mm_FOD.mif $high_res/$subj\_075mm_anatomical_coreg2nodif_undist_2.nii.gz

# View results of bet2
mrview $high_res/$subj\_anatomical.nii.gz -overlay.load $high_res/Temporal/$subj\_anatomical_brain.nii.gz -overlay.opacity 0.3

# View segmentation
mrview $high_res/$subj\_075mm_anatomical_coreg2nodif_undist_2.nii.gz -overlay.load $high_res/$subj\_075mm_5tt.nii.gz -overlay.opacity 0.3

# Correct WM segmentation in chiasm - modify opened ROI and close mrview. Modified WM segmentation image will be shown - repeat previous steps until satisfactory result is obtained. Terminate console to finish process
mrview $high_res/$subj\_075mm_5tt.nii.gz -colourmap 3 -overlay.load $high_res/$subj\_075mm_anatomical_coreg2nodif_undist_2.nii.gz -overlay.colourmap 0 -overlay.opacity 0.8 -roi.load $high_res/$subj\_5tt_patch.mif

5ttedit $high_res/$subj\_075mm_5tt.nii.gz -wm $high_res/$subj\_5tt_patch.mif $high_res/$subj\_5tt_for_act_modified.nii.gz -force

while true; do
  mrview $high_res/$subj\_5tt_for_act_modified.nii.gz -colourmap 3 -overlay.load $high_res/$subj\_075mm_anatomical_coreg2nodif_undist_2.nii.gz -overlay.colourmap 0 -overlay.opacity 0.8 -roi.load $high_res/$subj\_5tt_patch.mif
  5ttedit $high_res/$subj\_075mm_5tt.nii.gz -wm $high_res/$subj\_5tt_patch.mif $high_res/$subj\_5tt_for_act_modified.nii.gz -force
done

#data=/home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/0.75mm_iso/$subj

### Correct WM segmentation in chiasm - modify opened ROI and close mrview. Modified WM segmentation image will be shown - repeat previous steps until satisfactory result is obtained. Terminate console to finish process
#mrview $data/$subj\_075mm_5tt.nii.gz -colourmap 3 -overlay.load $data/$subj\_075mm_anatomical_coreg2nodif_undist_2.nii.gz -overlay.colourmap 0 -overlay.opacity 0.8 -roi.load $data/$subj\_5tt_patch.mif

#5ttedit $data/$subj\_075mm_5tt.nii.gz -wm $data/$subj\_5tt_patch.mif $data/$subj\_075mm_5tt_modify.nii.gz -force

#while true; do
#  mrview $data/$subj\_075mm_5tt_modify.nii.gz -colourmap 3 -overlay.load $data/$subj\_075mm_anatomical_coreg2nodif_undist_2.nii.gz -overlay.colourmap 0 -overlay.opacity 0.8 -roi.load $data/$subj\_5tt_patch.mif
#  5ttedit $data/$subj\_075mm_5tt.nii.gz -wm $data/$subj\_5tt_patch.mif $data/$subj\_075mm_5tt_modify.nii.gz -force
#done

}

#for i in /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/1.5mm_iso/*; do Check_preprocessing ${i: -4}; done

Check_preprocessing $1
