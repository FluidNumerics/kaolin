# Kaolin

[![codecov](https://codecov.io/gh/FluidNumerics/kaolin/graph/badge.svg?token=WY2HNX2G8M)](https://codecov.io/gh/FluidNumerics/kaolin)

## Backgroud

### Abstract
Scientific discovery increasingly relies on robust and sustainable software tools capable of efficiently managing the growing complexity of high-performance computing (HPC) workflows. While Fortran remains a cornerstone language for computational science, its support for modern computing architectures and best practices in software development has lagged behind contemporary frameworks. This proposal aims to develop FTensor, a modular, cross-platform Fortran library designed to provide standardized, scalable, and portable solutions for memory management, array operations, and parallel communication across a wide range of hardware platforms, including x86 and ARM CPUs, AMD and NVIDIA GPUs, and heterogeneous systems such as APUs.
FTensor will address critical gaps in scientific software by providing researchers with:

1. Portable Host-Device Memory Management: A unified interface for allocating and managing arrays in both host and device memory, streamlining code development for heterogeneous systems.
2. High-Level Array Operations: Simplified and efficient methods for performing array arithmetic and interfacing with BLAS/LAPACK routines, enabling seamless execution of linear algebra operations on host or device.
3. Streamlined MPI Communication: Abstractions that reduce the complexity of MPI calls by providing intuitive, high-level constructs for rank coordination and parallel execution workflows.

The library will be built on established best practices in scientific software development, including modular code design, automated testing (continuous integration), documentation, and community engagement, with the goal of promoting sustainable, reproducible research workflows. FTensor will be disseminated as an open-source tool, with extensive documentation and community support, empowering researchers across biomedical, clinical, behavioral, and social science disciplines to leverage modern HPC infrastructure for scalable and reproducible research.

By providing a flexible and portable solution to accelerate scientific computing workflows, this project directly addresses NIH’s goals to modernize data science ecosystems and enhance the sustainability and impact of research software tools. The proposed work will strengthen cross-disciplinary collaborations between domain scientists and software engineers, improve the software skills of the research workforce, and foster broader adoption of HPC best practices across the research community.

### Project Goals
* Provide host and device memory management for arrays in Fortran
* Provide standard operations for arrays (add, sub, elementwise-mult) and assignment
* Make the builds portable across platforms (CPU (x86 and ARM) only, AMD GPU, Nvidia GPU platforms, APUs)
* Provide simple access to BLAS/LAPACK operations on host or device 
    * i.e. simple call blas_lib%dgemm(a,b...) and it knowing if it has to execute it on the host or device 


* Provide simple calls to key MPI management routines, instead of:
    * if(rank .eq. 0) then ... !do coordination
    * if (rank.gt.0) then ... !do workers 
    * if(rank%is_leader()) then ... 
    * if(rank%is_worker()) then ...
    
### What's in a name ?
**Kaolin: A Foundation of Modern Society**  
Kaolin, a fine, white alumino-silicate clay, is a cornerstone of modern civilization, with its uses spanning diverse industries. It is fundamental in manufacturing ceramics, serving as the primary component in porcelain and tiles, and is critical in producing paper, where it provides gloss and smoothness. In pharmaceuticals and cosmetics, kaolin offers absorbent and soothing properties, while in construction, it is a key ingredient in cement and paint. Its versatility and ubiquity make it an essential material that underpins technological advancement and daily life.

**Kaolin Software: A Fundamental Building Block for HPC**  
Just as kaolin forms the basis for numerous modern applications, **Kaolin** is envisioned as a foundational tool for high-performance computing (HPC) from the Fortran programming language. HPC workflows rely on efficient management of arrays, seamless host-device memory coordination, scalable parallel communication, and portable execution across diverse architectures. These capabilities are akin to the myriad roles kaolin plays in society—supporting the structure, efficiency, and functionality of advanced systems.  


**Kaolin** will serve as a vital building block for computational science, much like its namesake supports modern industry. By addressing key challenges in portability, scalability, and usability, it will foster sustainable and reproducible HPC workflows, empowering scientists and engineers to achieve transformative advancements in their fields.