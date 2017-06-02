 #!/bin/bash

General_postprocessing () {

subj=${1}

analysis=/home/auguser2016/Projects/Chiasm_RJP_FP_ACPC/$subj
#analysis=/home/auguser2016/Projects/hw91_canxform

dwi2mask $analysis/$subj\_clean_150mm_aligned_trilin_noMEC.nii.gz $analysis/$subj\_acpc_mask.nii.gz -grad $analysis/$subj\_mrtrix_grad_table.b

# Estimating single fibre response (SFR) for lmax=6
dwi2response tournier $analysis/$subj\_clean_150mm_aligned_trilin_noMEC.nii.gz $analysis/$subj\_acpc_SFR.txt -shell 1600 -lmax 6 -mask $analysis/$subj\_acpc_mask.nii.gz  -voxels $analysis/$subj\_acpc_SFR_voxels.nii.gz -grad $analysis/$subj\_mrtrix_grad_table.b

# Estimation of Fiber Orientation Distribution function for 3 lmax
for lmax in 8 10 12; do  
  dwiextract $analysis/$subj\_clean_150mm_aligned_trilin_noMEC.nii.gz -grad $analysis/$subj\_mrtrix_grad_table.b - | dwi2fod msmt_csd - $analysis/$subj\_acpc_SFR.txt -lmax $lmax $analysis/$subj\_acpc_FOD_lmax_$lmax.mif -mask $analysis/$subj\_acpc_mask.nii.gz 
done
}

current=$(pwd)

cd /home/auguser2016/Projects/Chiasm_RJP_FP_ACPC
for i in */; do
	General_postprocessing ${i::-1};
done

cd $current


'''
# List of all data_sets used in studies
list=(fe21_1325/ hw91_0844/ ib57_0731/ kw99_0633/ lw37_0977/ nb30_1185/ ow93_0974/ ps94_1516/ rx88_1234/ sj22_1218/ ta14_1065/ tq63_1214/ xs62_1217/ xn78_1085/ uh47_1309/ uf97_1072/ ow93_0974/ )

list=(hw91_some/) #ow93_0974/ )


# This way 4 sets are processed at once - we can't process all at once due to RAM usage, however preprocessing one at a time is ineffective because e.g. eddy from dwipreproc is using only one core. There is a version of eddy operating on multicore processors, but it's not running on this machine

for i in ${list[@]:0:3}; do General_postprocessing $i; done
wait
for i in ${list[@]:3:6}; do General_postprocessing $i & done
wait
for i in ${list[@]:6:9}; do General_postprocessing $i & done
wait
for i in ${list[@]:9:12}; do General_postprocessing $i & done
wait
for i in ${list[@]:12:15}; do General_postprocessing $i & done
wait
for i in ${list[@]:15:18}; do General_postprocessing $i & done
wait
for i in ${list[@]:18:21}; do General_postprocessing $i & done
wait
for i in ${list[@]:21:24}; do General_postprocessing $i & done
wait
for i in ${list[@]:24:27}; do General_postprocessing $i & done
wait
for i in ${list[@]:27:30}; do General_postprocessing $i & done
wait
for i in ${list[@]:30:33}; do General_postprocessing $i & done
wait
'''
