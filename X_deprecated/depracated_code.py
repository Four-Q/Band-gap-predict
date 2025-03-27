# Hyperparameter optimization for Random Forest Regressor
# not use
def hp_optimization(X_train, y_train, cv=10):
    """
    use GridSearchCV and 10 fold cross validation to find the best hyperparameters for Random Forest Regressor.
    
    parameters:
    X_train: 
    y_train: 
    cv: cross validation folds
    
    returns:
    best_model: 
    best_params: 
    results_df: dataframe of all results
    """
    print("HP optimazation begin...")
    start_time = time.time()
    
    # define the parameter grid for Random Forest
    # reduce the number of parameters to avoid long time consuming
    param_grid = {
        'n_estimators': [100, 200, 300],  # number of trees in the forest
        'max_depth': [None, 15, 25],  # maximum depth of the tree, None means nodes are expanded until all leaves are pure
        # 'min_samples_split': [2, 5, 10, 20, 50, 100],  # minimum number of samples required to split an internal node
        # 'min_samples_leaf': [1, 2, 4, 10, 20, 50],    # minimum number of samples required to be at a leaf node
        'max_features': ['sqrt', 'log2']  # number of features to consider when looking for the best split, None means all features
    }
    
    # create a KFold object for cross-validation
    kf = KFold(n_splits=cv, shuffle=True, random_state=RANDOM_SEED)
    
    # create a RandomForestRegressor object
    rf = RandomForestRegressor(random_state=RANDOM_SEED, n_jobs=-1)
    
    # create a GridSearchCV object
    grid_search = GridSearchCV(
        estimator=rf,
        param_grid=param_grid,
        cv=kf,
        scoring='neg_mean_squared_error',
        n_jobs=-1,  
        verbose=1, # show progress
        return_train_score=True
    )
    
    # 
    grid_search.fit(X_train, y_train)
    
    # 
    best_params = grid_search.best_params_
    best_model = grid_search.best_estimator_
    best_score = np.sqrt(-grid_search.best_score_)
    
    # create a DataFrame to store the results
    results = pd.DataFrame(grid_search.cv_results_)
    results['test_rmse'] = np.sqrt(-results['mean_test_score'])
    results['train_rmse'] = np.sqrt(-results['mean_train_score'])
    
    # sort the results by test RMSE
    results_sorted = results.sort_values('test_rmse')
    
    # time taken for optimization
    elapsed_time = time.time() - start_time
    
    print(f"HP optimization done! Time consumed: {elapsed_time:.2f}s")
    print(f"Best HP: {best_params}")
    print(f"Best Test RMSE: {best_score:.4f}")
    
    # plot the results of the top 10 parameter combinations
    top_results = results_sorted.head(10)
    
    plt.figure(figsize=(12, 8), dpi=300)
    
    plt.subplot(1, 2, 1) # 1 row, 2 columns, 1st subplot
    plt.title('the top 10 parameter combinations test RMSE')
    sns.barplot(x=top_results.index, y='test_rmse', data=top_results)
    plt.xticks([])
    plt.ylabel('RMSE')
    
    plt.subplot(1, 2, 2)
    plt.title('the top 10 parameter combinations train RMSE vs test RMSE')
    
    x = np.arange(len(top_results))
    width = 0.35
    
    plt.bar(x - width/2, top_results['train_rmse'], width, label='Train RMSE')
    plt.bar(x + width/2, top_results['test_rmse'], width, label='Test RMSE')
    plt.xticks([])
    plt.ylabel('RMSE')
    plt.legend()
    
    plt.tight_layout()
    plt.show()
    
    return best_model, best_params, results_sorted
