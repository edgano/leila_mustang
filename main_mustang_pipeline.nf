leilaDir="/users/cn/lmansouri/PROJECTS/CLAN2FAM/CL0014.21"

params.msafile="${leilaDir}/*_ref.fa"
params.templates="${leilaDir}/*_ref.template_list"
params.pdb="${leilaDir}/*.pdb"

if ( params.msafile ) {
  Channel
  .fromPath(params.msafile)
//  .map { item -> [ item.baseName.replace('_ref','') , item] }
  .set { fastaAln }
}

if ( params.templates ) {
  Channel
  .fromPath(params.templates)
//  .map { item -> [ item.baseName.replace('_ref','') , item] }
  .set { templates }
}

if ( params.pdb ) {
  Channel
  .fromPath(params.pdb)
//  .map { item -> [ item.simpleName , item] }
  .collect()
  .set { pdbFiles }
}

process 'running 3dM aln' {
    publishDir "${leilaDir}"
    
    input:
    file(fasta) from fastaAln
    file(template) from templates
    file(pdb) from pdbFiles 
    
    output:
    file("*") into ref_aln
    
    script:
    """
    t_coffee -seq ${fasta} -template_file ${template} -method sap_pair TMalign_pair mustang_pair -output clustalw,fasta_aln >CL0014.21_3dM_coffee.fasta_aln
    """
}    


//process 'running regressive 3dM aln' {
//    publishDir "${leilaDir}"
//
//    input:
//    file(fasta) from fastaAln
//    file(template) from templates 
//    file(pdb) from pdbFiles 
//
//    output:
//    file("*") into ref_aln
//
//    script:
//    """
//      t_coffee -reg -reg_method 3dcoffee_msa -template_file ${template} -seq ${fasta} -reg_nseq 100 > CL0014.21_regressive_3dM_coffee.fasta_aln
//    """
//
//}


