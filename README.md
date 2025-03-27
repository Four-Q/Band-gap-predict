# Band gap predict 1

By using data from MP/AFLOW/Experiment, train some ML models which can be used to predict band gap of semiconductors...

## Data：

DFT data from MP(Materail project) and AFLOW, Experiment data from Ya Zhuo et
we use the **full composition** to represent a class of materail, for the same composition, we use the band gap value which is **closest** to the average value in this class.

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

Then we remove one of the two features with a linear correlation coefficient greater than 0.95.
So the number of features we use to train our model is **106**.


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