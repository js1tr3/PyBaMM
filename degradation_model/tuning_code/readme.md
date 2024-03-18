# Code to tune degradation model

The process to tune the degradation model is documented in this [paper](https://iopscience.iop.org/article/10.1149/1945-7111/ad1294) and is summarized in this figure:

![degradation tuning summary](./tuning_summary.png)

We adopt a sequential tuning process and it includes 4 steps:

## Step 1
1. Using calendar aging data for multiple temperatures to tune the SEI model. In this case, the contribution of mechanical damage and Li plating to aging would be negligible.
2. The SEI model is tuned using the data from the calendar aged cells in both cold (-5°C) and hot temperature (45°C) conditions. The reason for doing this is to capture the temperature dependency of SEI growth, being faster at high temperatures and slower at colder temperatures.
3. The vector of degradation mechanism parameters P to be tuned in step 1 are:
$$P_\mathrm{cal} = \left[k_{0,\mathrm{SEI}},D_\mathrm{SEI},E_{a,\mathrm{SEI}}\right]^T $$
4. The vector of data to be fitted against model outputs are:
$$Y_\R\mathrm{cal} = \left[C, n_\mathrm{Li},y_0,x_{100}\right]^T$$

To perform step 1, please run this [notebook](./step_1_calendar.ipynb)

### Input Data Required:
eSOH parameters $[x_0,x_{100},y_0,y_{100},C_n,C_p,C,n_{Li}]$ at RPTs for calendar aging cells at multiple temperatures
### Output of Tuning:
$$P_\mathrm{cal} = \left[k_{0,\mathrm{SEI}},D_\mathrm{SEI},E_{a,\mathrm{SEI}}\right]^T $$


## Step 2
1. After step 1, we tune the mechanical damage model parameters and lithium plating model parameters together using the cycling aging data at multiple C-rates
2. The vector of degradation mechanism parameters P to be tuned in step 2 are:
$$P_\mathrm{cyc} = \left[\beta^-_{\mathrm{LAM},1},\beta^-_{\mathrm{LAM},2},\beta^+_{\mathrm{LAM},1},\beta^+_{\mathrm{LAM},2},m_{\mathrm{LAM}},k_\mathrm{pl}\right] $$
3. The vector of data to be fitted against model outputs are:
$$Y_\mathrm{cyc} = \left[C, n_\mathrm{Li},C_n,C_p\right]^T$$
4. The parameters $P_{cyc}$ were tuned based on the data sets $Y_{cyc}$ extracted from the RPTs of the cycling cells at charge-discharges rates of C/5-C/5%–100%DOD, 1.5C-1.5C-100%DOD, and C/5-1.5C-100%DOD. The reason for tuning the model using the three cells together is to establish the C-rate dependency of the mechanical damage and Li plating models. Using data from a single C-rate would be insufficient to get the C-rate dependency correct in the model. 
5. Please note that step 2 has to be run after step 1 and we use the values of $P_{cal}$ obtained in step 1 to initialize the model in step 2. 

To perform step 2, please run this [notebook](./step_2_cycling.ipynb)

### Input Data Required:
eSOH parameters $[x_0,x_{100},y_0,y_{100},C_n,C_p,C,n_{Li}]$ at RPTs for cycling aging cells at multiple C-rates
### Output of Tuning:
$$P_\mathrm{cyc} = \left[\beta^-_{\mathrm{LAM},1},\beta^-_{\mathrm{LAM},2},\beta^+_{\mathrm{LAM},1},\beta^+_{\mathrm{LAM},2},m_{\mathrm{LAM}},k_\mathrm{pl}\right] $$

## Step 3

## Step 4