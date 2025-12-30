# 2025-12-18: Move run2-beam-SN binaries to Nevis
1. Identify run number from DAQ Spreadsheet
19713
19689
19688
19687
19686
19676
19675
19654
19653
19652
19651
19649
19648
19647
19646
19645
2. Check binary files on tpc servers
Looks like everything is there
3. Write script to copy files over
Written in `/home/nfs/sbnd/schung/macros/copy_binary_fromTPC_toNevis.sh`, wait for next beam downtime


# 2025-12-29: Update SPACK DAQ area on `nefertiti` to include subfile saving in SN binary files
1. Identify that binary saving is enabled on both `feature/kalra_sncomJuly2025` and `v2_00_00` of `sbndaq-artdaq` (https://github.com/SBNSoftware/sbndaq-artdaq/blob/2ca1fedb1acae711b5b599a717a59a913f26632b/sbndaq-artdaq/Generators/SBND/NevisTPC/NevisTPC2StreamNUandSNXMIT_generator.cc#L426)
1. Using `DAQ_SPACK_DevAreas/newSPACKDevArea-GAL.env` as template, modify `/home/sbnd/DAQ_SPACK_DevAreas/newSPACKDevArea-schung.env` for `v2_00_00`
    * Didn't work, possible conflict with windriver,revert back to `v1_10_08`
1. Follow instructions from https://cdcvs.fnal.gov/redmine/projects/sbnd/wiki/SPACK_Instructions

Rebuilding with `v1_10_08`
1. Error
```
1 error found in build log: >> 6 CMake Error at /daq/software/spack_packages/cetmodules/3.26.00/linux-scientific7-x86_64_v2-gcc-13.1.0-b357pek64v4c477h4r6nynasxaw77q72/Modules/priva te/CetOverrideFindPackage.cmake:180 (_find_package): 7 By not providing "Findsbndaq_artdaq_core.cmake" in CMAKE_MODULE_PATH this 8 project has asked CMake to find a package configuration file provided by 9 "sbndaq_artdaq_core", but CMake did not find one. 10 11 Could not find a package configuration file provided by 12 "sbndaq_artdaq_core" (requested version 1.04.00) with any of the following
```
1. Modify CListMake.txt in `sbndaq-artdaq` to match `sbndaq-artdaq-core` `v1_10_08`
    1. Failed
    1. Tried fresh build, same error. Will rsync from nfs to `nefertiti` again

1. Issue was that using same DEVNAME for same date is conflicting. Tried with new name
    1. Only copied over modified source code from `feature/kalra_sncomJuly2025`
    1. **IMPORANT**
    Do
    ```
    unset SPACK_DISABLE_LOCAL_CONFIG
    export SPACK_USER_CONFIG_PATH=/home/nfs/sbnd/DAQ_SPACK_DevAreas/<your DAQ area>/spack
    ```
    
    Before
    ```
    spack concretize --fresh -f -j64
    spack install -y -j64 --fresh --no-cache --source
    ```

    Else will get errors related to `nothing to build`

1. Getting new error
```
terminate called after throwing an instance of 'std::future_error'
  what():  std::future_error: No associated state
Aborted (core dumped)
```


Added line related to zero suppression
```
channel_threshold : true
load_threshold_mean : 2
load_threshold_variance : 3
postsample : 7
presample : 7

zero_suppression_params: {                                                                                                          
#config_file: "/home/nfs/sbnd/DAQ_DevAreas/DAQ_2025-07-11_nevis_sn_production_dev_v1_10_07/DAQInterface/configs/opsFullTriggerMenuP3_ExtraMTCA5-5-/crate1.txt"
config_file: "/home/nfs/sbnd/DAQ_DevAreas/DAQ_2025-07-11_nevis_sn_production_dev_v1_10_07/DAQInterface/configs/opsFullTriggerMenuP3_ExtraMTCA5-5-/crate1.txt"
}
```

Error now gone, but SN binary is not being saved


# 2025-12-30: Build SPACK DAQ with `v2_00_00`. Find fcl with SN used during start of Run2
1. **TODO**: Set up NFS on `nefertiti` and `nitocris`. Possibly something like AL9 which supports VScode
1. Found Eric's SN tests based on `sbndaq-artdaq` `v1_10_09`. Try to build this
1. Checked that building `v2_00_00` works on SL7 evb. Try again on `nefertiti` after rsyncing `daq` area again
1. Identified fcl for run19713, not certain if this will work as we need fake data
1. Built new area with `https://github.com/SBNSoftware/sbndaq-artdaq/tree/ericSNtestSpack` branch using `v1_10_09`
    * Still need to debug issue with `v2_00_00`
    * Build had issue with windriver, modified `sbndaq-suite`
        * Conflict between windriver version wanted in
        ```
        depends_on("windriver@v12_06_00", when="@:v2_00_00")
        depends_on("windriver@v16_05_00", when="@v2_01_00:")
        ```
        and specific requirements in conditional block
    * `spack edit sbndaq-suite`
    * `spack location -p sbndaq-suite`
1. **Solved**
    * Issue of SN binaries not saving with SNcomm source code
    * Need separate `DumpSNBinary` entry to enable
    * Refer to `/home/nfs/sbnd/DAQ_fcls_area/fcl_configs_run2/sbnd-daq-fcls/run2-beam-SN-` if needed