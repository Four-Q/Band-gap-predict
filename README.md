# Band gap predict 1

By using data from MP/AFLOW/Experiment, train some ML models which can be used to predict band gap of semiconductors...

## Data：

DFT data from MP(Materail project) and AFLOW, Experiment data from Ya Zhuo et

Elements number: 2 to 4
MP data are stable data(e_above_hull=0)
Band gap range: 0 to 6eV

## Featurization:

we use `matminer.featurizers.composition.ElementProperty` to featurize data, and preset_name='magepie'.
The **features** are:
['Number', 'MendeleevNumber', 'AtomicWeight',
'MeltingT', 'Column', 'Row', 'CovalentRadius',
'Electronegativity', 'NsValence', 'NpValence',
'NdValence', 'NfValence', 'NValence', 'NsUnfilled',
'NpUnfilled', 'NdUnfilled', 'NfUnfilled', 'NUnfilled',
'GSvolume_pa', 'GSbandgap', 'GSmagmom',
'SpaceGroupNumber']

The **stats** are: 
['minimum', 'maximum', 'range', 'mean', 'avg_dev', 'mode']
**Totally 132** features.



## Train

### Models：

- **Linear Regression** class
    - Elastic Net
    - Ridge
    - Lasso

- **Boosting Decision Trees** class
    - Gradient Boosting Regression
    - LightGBM
    - XGBoost

- **RandomForest** class
    - Random Forest
    - ExtremeRandomTrees

- Kernel Ridge Regression(KRR)
- K-Nearest Neighbor(KNN)
- Support Vector Regressor

### Metrics:

- Determine coefficient($R^2$)
- Root mean squared error 
- Absolute mean error

### Hyper Parameter Search:

we use **Random Search** for the model which hp search time is too long,
and use **Grid Search** for the model which hp search time is short.

### Test set:

There are three type test set:
- Test on the same set (such as trained on dft, test on dft)
- Test on the another set(such as trained on dft, test on exp)
- Test on the mixed set (such as trained on dft, test on dft+exp)