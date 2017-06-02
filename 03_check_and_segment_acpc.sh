Check_acpc () {

subj=$1

analysis=/home/auguser2016/Projects/Chiasm_RJP_FP_ACPC/$subj

# Compare coregisterred DW image with anatomy in acpc space
#mrview $analysis/$subj\_clean_075mm_aligned_trilin_noMEC.nii.gz $analysis/$subj\_t1_acpc.nii.gz

# Compare DW images before and after registration
#mrview $analysis/$subj\_clean_075mm_aligned_trilin_noMEC.nii.gz /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/0.75mm_iso/$subj/$subj\_clean_075mm.mif

# Compare their bvecs
#gedit $analysis/$subj\_clean_075mm_aligned_trilin_noMEC.bvecs /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/0.75mm_iso/$subj/$subj\_bvecs.bvecs

# Compare their bvals
#gedit $analysis/$subj\_clean_075mm_aligned_trilin_noMEC.bvals /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/0.75mm_iso/$subj/$subj\_bvals.bvals

# for ACPC registration
# Perform segmentation of T1 image in ACPC space into WM, GM, subGM, CSF and potential pathological tissue
5ttgen fsl $analysis/$subj\_t1_acpc.nii.gz $analysis/$subj\_t1_acpc_5tt.nii.gz

# Correct WM segmentation in chiasm - modify opened ROI and close mrview. Modified WM segmentation image will be shown - repeat previous steps until satisfactory result is obtained. Terminate console to finish process
#mrview $analysis/$subj\_t1_acpc_5tt.nii.gz -colourmap 3 -overlay.load $analysis/$subj\_t1_acpc.nii.gz -overlay.colourmap 0 -overlay.opacity 0.8 -roi.load $analysis/$subj\_5tt_patch.mif

#5ttedit $analysis/$subj\_t1_acpc_5tt.nii.gz -wm $analysis/$subj\_5tt_patch.mif $analysis/$subj\_t1_acpc_5tt_modified.nii.gz -force

#while true; do
#  mrview $analysis/$subj\_t1_acpc_5tt_modified.nii.gz -colourmap 3 -overlay.load $analysis/$subj\_t1_acpc.nii.gz -overlay.colourmap 0 -overlay.opacity 0.8 -roi.load $analysis/$subj\_5tt_patch.mif
#  5ttedit $analysis/$subj\_t1_acpc_5tt.nii.gz -wm $analysis/$subj\_5tt_patch.mif $analysis/$subj\_t1_acpc_5tt_modified.nii.gz -force
#done

}

#for i in /home/auguser2016/dMRI_DATA/PREPROCESSED_DATA/1.5mm_iso/*; do Check_acpc ${i: -4}; done

Check_acpc $1
