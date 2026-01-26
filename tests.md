# Week of 2026-01-26: Tests During Beam Downtime on Thursday

## Purpose
1. We observe a bug where only header information is present in the SN binaries for an SN-enabled run.  
1. This bug appears when we build a new area with SPACK using any version later than the `feature/kalra_sncomJuly2025` branch from `sbndaq-artdaq`.  
1. When implementing the required features step by step, we do **not** see this behavior. The branch currently used in that case is `yufan_nefisteststand`.  
1. We want to test whether this issue is specific to the Nevis teststand or if it can also be reproduced at SBND.

## Preparation
1. The area  
   `/home/nfs/sbnd/DAQ_SPACK_DevAreas/DAQ_2026-01-22_SCHUNG_v1_10_08`  
   is built using the `yufan_nefisteststand` branch.  

1. The production SPACK area  
   `/home/nfs/sbnd/DAQ_SPACK_DevAreas/DAQ_2025-09-23_SHIFT_v1_10_08`  
   serves as the *problematic* reference.  

1. The FHiCL file to use is  
   `/home/nfs/sbnd/schung/teststand/fake_2EXT.fcl`.  
   Run with:  
   `artdaqDriver -c {fcl}`  
   after sourcing `setup_daqinterface_spackenv.sh` in each area.  

1. The expected test duration is approximately 15 minutes if everything works fine, maximum 1 hour for debugging

1. Components/Servers needed: TPC01 crate and TPC01 server