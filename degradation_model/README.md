# Code for modeling battery degradation and expansion

## Installation instructions
1. Install [git](https://git-scm.com/downloads) 
2. Install [python 3.9](https://www.python.org/downloads/release/python-3913/)
3. Clone the git repo:
```
git clone https://github.com/js1tr3/PyBaMM
```
4. Follow install from source instruction from PyBaMM documentation to install our custom fork of PyBaMM
https://docs.pybamm.org/en/latest/source/user_guide/installation/install-from-source.html

5. Ensure that you are in the PyBaMM working directory after following instructions in step 4.
6. Switch to the `gmjuly2022` branch of the PyBaMM fork
```
git checkout gmjuly2022
```

7. Change the working directory to `degradation_model` subfolder
```
cd degradation_model
```
## Data
The model requires cycling data, RPT data, resistance and eSOH data. These data files not included in this repo due to upload size limitations. Please download from this [Google Drive Folder](https://drive.google.com/drive/folders/16uwOXhK_kvs6xNQBIiVQT5VzPDkkNnov?usp=sharing) and paste the files in the empty folder named `data` provided. Ensure to paste the data in the corresponding subfolders of `cycling`,`esoh`,`ocv` and `resistance`.
## Running the degradation Model
- Run [run_model.ipynb](../degradation_model/run_model.ipynb) notebook to simulate aging for all cells at room temperature
  - Includes resistance simulations
  - Includes voltage and expansion simulations
- Run [figures_1.ipynb](../degradation_model/figures_1.ipynb) to generate figures from the Results section in the paper
- Run [figures_2.ipynb](../degradation_model/figures_2.ipynb) to generate figures from other sections in the paper

## Parameters
- Details regarding the location of parameters and how to update them are given in [parameters.md](./parameters.md)
- Running C/3 and C/20 cycles with the new parameter set is given in [run_cycles.ipynb](./run_cycles.ipynb)

## Examples
- Run [run_current_profile.ipynb](../degradation_model/run_current_profile.ipynb) shows how to run the model using a current profile from data
- Run [initialize_model.ipynb](../degradation_model/initialize_model.ipynb) shows how to initialize the model with electrode stoichiometries and capacities.