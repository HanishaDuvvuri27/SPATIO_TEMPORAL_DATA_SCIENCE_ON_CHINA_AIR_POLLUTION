# SPATIO TEMPORAL DATA SCIENCE ON CHINA AIR POLLUTION
machine-learning
time-series
air-pollution


## Overview

This repository contains code, notebooks, and data-processing scripts for analyzing spatial and temporal patterns of air pollution across China. The project focuses on exploratory data analysis, visualization, statistical modeling, and spatio-temporal forecasting for major pollutants (e.g., PM2.5, PM10, NO2, O3).

## Goals

- Clean and preprocess multi-source air quality data (monitoring stations, satellite products, meteorological covariates).
- Explore spatial and temporal trends and anomalies in pollutant concentrations.
- Build spatio-temporal models (e.g., mixed-effects, geostatistical/kriging, spatial-temporal deep learning) to predict pollutant concentrations.
- Produce reproducible notebooks and visualizations for reports and further research.

## Data sources

List your primary data sources here. Example entries:

- National air quality monitoring station data (CNEMC / MEE).
- Satellite-derived aerosol optical depth (AOD) products (MODIS, VIIRS).
- Reanalysis and meteorological covariates (ERA5, NCEP).
- Administrative boundaries and population/demographic layers.

Add dataset file names and short descriptions in the `data/` directory or link to external sources when appropriate.

## Repository structure

- data/ - raw and processed datasets (NOT included in version control or included as small samples).
- notebooks/ - Jupyter notebooks for EDA, modeling, and visualization.
- src/ - Python/R scripts and modules used by notebooks and experiments.
- models/ - saved model checkpoints and training artifacts (large files should be stored externally).
- results/ - figures, maps, and evaluation metrics produced by experiments.
- docs/ - supplementary documentation and report exports.

## Setup and requirements

Create a reproducible environment before running notebooks. Example using conda:

```bash
conda create -n st_air python=3.10
conda activate st_air
pip install -r requirements.txt
```

Alternatively, provide a `environment.yml` or `requirements.txt` in the repo.

## How to use

1. Place raw datasets into `data/raw/` and small processed samples into `data/processed/`.
2. Inspect notebooks in `notebooks/`.
3. Run preprocessing scripts in `src/preprocessing.py` to generate cleaned inputs.
4. Run modeling notebooks or scripts in `notebooks/` or `src/models/`.

## Notebooks of interest

- notebooks/01_eda.ipynb — exploratory data analysis and visualizations.
- notebooks/02_preprocessing.ipynb — data cleaning and feature engineering.
- notebooks/03_modeling.ipynb — baseline spatio-temporal models and evaluation.

Adjust filenames to match actual notebooks present in the repository.

## Reproducibility

- Use fixed random seeds where applicable and record package versions (`pip freeze > requirements.txt`).
- For heavy computations, record the compute environment (GPU, CPU, memory) and use checkpoints.

## Contributing

Contributions are welcome. Please open an issue to discuss changes or submit a pull request with a clear description and tests/examples when appropriate.

## License

Add an appropriate license (e.g., MIT, Apache-2.0) in a `LICENSE` file.

## Contact

Repository maintained by HanishaDuvvuri27. For questions, open an issue or contact the maintainer through their GitHub profile.

---

Notes:
- This README is a template. Modify data sources, scripts, and instructions to reflect actual repository contents and any additional dependencies or setup steps.
