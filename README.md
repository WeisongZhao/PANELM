
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
<h5 align="center">rFRC mapping and PANEL pinpointing with Matlab.</h5>
</p>
<br>
<p>
<img src='./img/MATLAB.jpg' align="left" width=120>
</p>

rFRC (rolling Fourier ring correlation) mapping and PANEL (Pixel-level ANalysis of Error Locations) pinpointing with Matlab is distributed as accompanying software for publication: [Weisong Zhao et al. Quantitatively mapping local quality at super-resolution scale by rolling Fourier ring correlation, <!-- Nature Methods -->, X, XXX-XXX (2022)](https://www.nature.com/nmeth/). More details on [Wiki](https://github.com/WeisongZhao/PANELM/wiki/). If it helps your research, please cite our work in your publications. 

<br>
<br>

If you are not a Matlab user, you can have a try on the imagej version: [PANELJ](https://github.com/WeisongZhao/PANELJ), or the Python version: [PANELpy](https://github.com/WeisongZhao/PANELpy).

## Usages of rFRC and PANEL in specific

The `rFRC` is for quantitatively mapping the local image quality (effective resolution, data uncertainty). The lower effective resolution gives a higher probability to the error existence, and thus we can use it to represent the uncertainty revealing the error distribution.

**rFRC is capable of:**
- **Data uncertainty mapping** of reconstructions without Ground-Truth (Reconstruction-1 vs Reconstruction-2) | 3σ curve is recommended;
- **Data uncertainty and leaked model uncertainty mapping** of deep-learning predictions of low-level vision tasks without Ground-Truth (Prediction-1 from input-1 vs Prediction-2 from input-2) | 3σ curve is recommended;
- **Model uncertainty mapping** of deep-learning predictions of low-level vision tasks without Ground-Truth (Prediction-1 from model-1 vs Prediction-2 from model-2) | 3σ curve is recommended;
- **Full error mapping** of reconstructions/predictions with Ground-Truth (Reconstruction/Prediction vs Ground-Truth) | 3σ curve is recommended;
- **Resolution mapping** of raw images (Image-1 vs Image-2) | 1/7 hard threshold or 3σ curve are both feasible;

**When two-frame is not accessible, two alternative strategies for single-frame mapping is also provided (not stable, the two-frame version is recommended).** 

**PANEL**

- We also accompany our `filtered rFRC` with `truncated RSM` ([resolution-scaled error map](http://dx.doi.org/10.1038/nmeth.4605)) as a `full PANEL` map, but this `RSM` is an optional feature that can be turn off as the wide-field reference being unavailable. `PANEL` is for biologists to qualitatively pinpoint regions with low reliability as a concise visualization

- Note that our `rFRC` and `PANEL` cannot fully pinpoint the unreliable regions induced by the model bias, which would require more extensive characterization and correction routines based on the underlying theory of the corresponding models.


## PANELM for local quality mapping
<p align='center'>
<img src='./img/PANELM.png' align="center" width=900>
</p>


## Version
- v0.4.5 Adaptive background threshold & parallel acceleration
- v0.3.0 Single-frame rFRC mapping
- v0.2.0 RSM and PANEL visualization
- v0.1.0 Initial rFRC mapping


## Open source [PANELM](https://github.com/WeisongZhao/PANELM)
- This software and corresponding methods can only be used for **non-commercial** use, and they are under Open Data Commons Open Database License v1.0.
- Feedback, questions, bug reports and patches are welcome and encouraged!