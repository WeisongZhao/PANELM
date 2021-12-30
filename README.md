
[![website](https://img.shields.io/badge/website-up-green.svg)](https://weisongzhao.github.io/PANELM/)
[![paper](https://img.shields.io/badge/paper-nat.%20methods-black.svg)](https://www.nature.com/nmeth/)
[![Github commit](https://img.shields.io/github/last-commit/WeisongZhao/PANELM)](https://github.com/WeisongZhao/PANELM/)
[![License](https://img.shields.io/github/license/WeisongZhao/PANELM)](https://github.com/WeisongZhao/PANELM/blob/master/LICENSE/)<br>
[![Twitter](https://img.shields.io/twitter/follow/weisong_zhao?label=weisong)](https://twitter.com/weisong_zhao/status/1370308101690118146)
[![GitHub watchers](https://img.shields.io/github/watchers/WeisongZhao/PANELM?style=social)](https://github.com/WeisongZhao/PANELM/) 
[![GitHub stars](https://img.shields.io/github/stars/WeisongZhao/PANELM?style=social)](https://github.com/WeisongZhao/PANELM/) 
[![GitHub forks](https://img.shields.io/github/forks/WeisongZhao/PANELM?style=social)](https://github.com/WeisongZhao/PANELM/)

<p>
<h1 align="center">PANEL<font color="red">M</font></h1>
<h6 align="right">v0.4.5</h6>
<h5 align="center">Pixel-level ANalysis of Error Locations (or resolution) with Matlab.</h5>
</p>
<br>
<p>
<img src='./img/MATLAB.jpg' align="left" width=120>
</p>

Pixel-level ANalysis of Error Locations (or resolution) with Matlab is distributed as accompanying software for publication: [Weisong Zhao et al. PANEL: quantitatively mapping reconstruction errors at super-resolution scale by rolling Fourier ring correlation, Nature Methods, X, XXX-XXX (2022)](https://www.nature.com/nmeth/). Please cite PANEL in your publications, if it helps your research.

<br>
<br>

## Usage of PANEL in specific

- **Error mapping** of reconstructions without Ground-Truth (Reconstruction-1 vs Reconstruction-2) | 3σ curve is recommended;
- **Error mapping** of deep-learning predictions of low-level vision tasks without Ground-Truth (Prediction-1 vs Prediction-2) | 3σ curve is recommended;
- **Error mapping** of reconstructions/predictions with Ground-Truth (Reconstruction/Prediction vs Ground-Truth) | 3σ curve is recommended.
- **Resolution mapping** of raw images (Image-1 vs Image-2) | 1/7 hard threshold is recommended;

**Notably, when two-frame is not accessible, two alternative strategies for single-frame mapping is also provided (but not stable, the two-frame version is recommended).** 

## PANELM for error mapping
<p align='center'>
<img src='./img/PANELM.png' align="center" width=900>
</p>


## Version
- v0.4.5 Adaptive background threshold & parallel acceleration
- v0.3.0 Single-frame rFRC mapping
- v0.2.0 RSM and PANEL visualization
- v0.1.0 Initial rFRC mapping


## Declaration
This repository contains the Maltab source code for <b>PANEL</b> .  

If you are not a Matlab user, you can have a try on the imagej version of PANEL: [PANELJ](https://github.com/WeisongZhao/PANELJ).

Here is an example dataset [HDSMLM_20nmpixel_background_15.tif](https://github.com/WeisongZhao/PANELM/releases/download/v0.3.0/HDSMLM_20nmpixel_background_15.tif) and [its wide-field image](https://github.com/WeisongZhao/PANELM/releases/download/v0.3.0/HDWF.tif).

## Open source [PANELM](https://github.com/WeisongZhao/PANELM)
- This software and corresponding methods can only be used for **non-commercial** use, and they are under Open Data Commons Open Database License v1.0.
- Feedback, questions, bug reports and patches are welcome and encouraged!