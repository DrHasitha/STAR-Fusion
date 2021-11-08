version 1.0

import "https://raw.githubusercontent.com/STAR-Fusion/STAR-Fusion/Terra-1.10.1/WDL/star_fusion_workflow.wdl" as SFW

workflow star_fusion_hg19_wf {
  input {
    
    String sample_id

    File genome_plug_n_play_tar_gz = "gs://ctat_genome_libs/__genome_libs_StarFv1.10/GRCh37_gencode_v19_CTAT_lib_Mar012021.plug-n-play.tar.gz"
    
    # input data options
    File? left_fq
    File? right_fq
    File? fastq_pair_tar_gz
    

    # STAR-Fusion parameters
    String? fusion_inspector  # inspect or validate
    Boolean examine_coding_effect = false
    
    # runtime params
    String docker = "trinityctat/starfusion:1.10.1"
    Int num_cpu = 12
    Float fastq_disk_space_multiplier = 3.25
    String memory = "50G"
    Float genome_disk_space_multiplier = 2.5
    Int preemptible = 2
    Float extra_disk_space = 10
    Boolean use_ssd = true

  }

    
  call SFW.star_fusion_workflow as star_fusion_hg19 {
      input:
        left_fq = left_fq,
        right_fq = right_fq,
        fastq_pair_tar_gz = fastq_pair_tar_gz,
        genome_plug_n_play_tar_gz = genome_plug_n_play_tar_gz,
        sample_id = sample_id,
        examine_coding_effect = examine_coding_effect,
        preemptible = preemptible,
        docker = docker,
        num_cpu = num_cpu,
        memory = memory,
        extra_disk_space = extra_disk_space,
        fastq_disk_space_multiplier = fastq_disk_space_multiplier,
        genome_disk_space_multiplier = genome_disk_space_multiplier,
        fusion_inspector = fusion_inspector,
        use_ssd = use_ssd
    
  }

  output {

    File fusion_predictions = star_fusion_hg19.fusion_predictions
    File fusion_predictions_abridged = star_fusion_hg19.fusion_predictions_abridged
    File junction = star_fusion_hg19.junction
    File bam = star_fusion_hg19.bam
    File sj = star_fusion_hg19.sj
    
    File? coding_effect = star_fusion_hg19.coding_effect

    Array[File]? extract_fusion_reads = star_fusion_hg19.extract_fusion_reads

    File star_log_final = star_fusion_hg19.star_log_final
    
    File? fusion_inspector_validate_fusions_abridged = star_fusion_hg19.fusion_inspector_validate_fusions_abridged
    File? fusion_inspector_validate_web = star_fusion_hg19.fusion_inspector_validate_web

    File? fusion_inspector_inspect_fusions_abridged = star_fusion_hg19.fusion_inspector_inspect_fusions_abridged
    File? fusion_inspector_inspect_web = star_fusion_hg19.fusion_inspector_inspect_web
    
  }
}

