ACPC_preparation () {

	# Registration to ACPC space requires preprocessed DWI image in .nii (or .nii.gz) format with corresponding bvecs and bvals. T1 image in ACPC space will be prepared separately

	# Defining data set and its' path
	a=${1::-6}
	data=/home/auguser2016/dMRI_DATA
	high_res=PREPROCESSED_DATA/0.75mm_iso/$a

	# Obtain bvecs and bvals
	mrinfo $data/$high_res/$a\_clean_075mm.mif -export_grad_fsl $data/$high_res/$a\_bvecs.bvecs $data/$high_res/$a\_bvals.bvals

	# Transform DW in .mif into .nii.gz
	mrconvert $data/$high_res/$a\_clean_075mm.mif $data/$high_res/$a\_clean_075mm.nii.gz
}

# List of all data_sets used in studies
list=(fe21_1325/ hw91_0844/ ib57_0731/ kw99_0633/ lw37_0977/ nb30_1185/ ow93_0974/ ps94_1516/ rx88_1234/ sj22_1218/ ta14_1065/ tq63_1214/ xs62_1217/ xn78_1085/ uh47_1309/ uf97_1072/ ow93_0974/ )

# As during processing of each data set full resources are used, lining them up is an effective approach
for i in ${list[@]}; do ACPC_preparation $i; done