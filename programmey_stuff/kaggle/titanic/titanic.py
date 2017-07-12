import pandas as pd
import numpy as np

import re
mrPattern = re.compile('.*Mr\..*')
missPattern = re.compile('.*Miss\..*')
masterPattern = re.compile('.*Master\..*')
mrsPattern = re.compile('.*Mrs\..*')
donPattern = re.compile('.*Don\..*')
revPattern = re.compile('.*Rev\..*')
drPattern = re.compile('.*Dr\..*')
mmePattern = re.compile('.*Mme\..*')
msPattern = re.compile('.*Ms\..*')
majorPattern = re.compile('.*Major\..*')
ladyPattern = re.compile('.*Lady\..*')
sirPattern = re.compile('.*Sir\..*')
mllePattern = re.compile('.*Mlle\..*')
colPattern = re.compile('.*Col\..*')
captPattern = re.compile('.*Capt\..*')
countessPattern = re.compile('.*Countess\..*')
jonkheerPattern = re.compile('.*Jonkheer\..*')

def nameToCategory(name):
    if (mrPattern.match(name)):
        return 'Mr'
    elif (jonkheerPattern.match(name)):
        return 'Other'
    elif (countessPattern.match(name)):
        return 'Other'
    elif (captPattern.match(name)):
        return 'Other'
    elif (missPattern.match(name)):
        return 'Miss'
    elif (masterPattern.match(name)):
        return 'Master'
    elif (mrsPattern.match(name)):
        return 'Mrs'
    elif (donPattern.match(name)):
        return 'Other'
    elif (revPattern.match(name)):
        return 'Other'
    elif (drPattern.match(name)):
        return 'Other'
    elif (mmePattern.match(name)):
        return 'Mrs'
    elif (msPattern.match(name)):
        return 'Miss'
    elif (majorPattern.match(name)):
        return 'Other'
    elif (ladyPattern.match(name)):
        return 'Other'
    elif (sirPattern.match(name)):
        return 'Other'
    elif (mllePattern.match(name)):
        return 'Miss'
    elif (colPattern.match(name)):
        return 'Other'
    return 'Other'

nameToCategory('Mr. Johnson')
nameToCategory('Ms. John')

import math
def clean_input_data(filePath):
    data = pd.read_csv(filePath)
    char_cabin = data['Cabin'].astype(str)
    new_cabin = np.array([cabin[0] for cabin in char_cabin])
    data['Cabin'] = pd.Categorical(new_cabin)

    data['Fare'] = data['Fare'].fillna(data['Fare'].mean())

    c1Median = data.Age[data.Pclass == 1].median()
    c2Median = data.Age[data.Pclass == 2].median()
    c3Median = data.Age[data.Pclass == 3].median()

    def medianFor(row):
        if (row['Pclass'] == 1):
            return c1Median
        elif (row['Pclass'] == 2):
            return c2Median
        elif (row['Pclass'] == 3):
            return c3Median
        else:
            raise Exception('Goofed')

    def updateAge(row):
        if (math.isnan(row['Age'])):
            median = medianFor(row)
            row['Age'] = median
        return row

    # Update the missing ages with the median
    data = data.apply(updateAge, axis=1)

    new_embarked = np.where(data['Embarked'].isnull()
                           , 'S'
                           , data['Embarked'])

    data['Embarked'] = new_embarked

    data['Title'] = data['Name'].apply(nameToCategory)
    return data

def svm_feature_transform(df):
    fixed = df.drop(['Name', 'Ticket', 'Fare', 'PassengerId'], axis=1)
    fixedWithDummies = pd.get_dummies(fixed)
    return fixedWithDummies

def nn_feature_transform(df):
    df = df.drop(['Name', 'Ticket', 'Fare', 'PassengerId'], axis=1)

    df = pd.get_dummies(df)
    return df

def logistic_feature_transform(df):
    encoded_sex = label_encoder.fit_transform(df["Sex"])
    encoded_class = label_encoder.fit_transform(df["Pclass"])
    encoded_cabin = label_encoder.fit_transform(df["Cabin"])
    encoded_title = label_encoder.fit_transform(df["Title"])
    encoded_parch = label_encoder.fit_transform(df["Parch"])

    train_features = pd.DataFrame([ encoded_class
                                  , encoded_cabin
                                  , encoded_sex
                                  , encoded_title
                                  , encoded_parch
                                  , df["Age"]
                                  ]).T
    return train_features

scrubbedData = clean_input_data('train.csv')
scrubbedData = svm_feature_transform(scrubbedData)
scrubbedData_X = scrubbedData.drop('Survived', axis=1)
scrubbedData_y = scrubbedData.Survived

# For each of my models, I would like to use a different method to take my input data X and pull out/transform to the features I want to use.
# Specifically, each of the feature transform functions seen above.
# Right now I only only know how transform the X data before I pass it into grid_search_cv.fit(X, y)
# Do you know of a way to do this

from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import f_regression
# Scores using f_regression, and drops all but the 5 best features based on this score.
anova_filter = SelectKBest(f_regression, k = 5)

from sklearn import svm
svc = svm.SVC(kernel='linear')

from sklearn.neural_network import MLPClassifier
nn = MLPClassifier(
    solver='lbfgs',
    activation='logistic'
    )

from sklearn.linear_model import LogisticRegression
logistic = LogisticRegression()

from sklearn.ensemble import VotingClassifier
vote = VotingClassifier(estimators=[
    ('nn', nn),
    ('svc', svc),
    ('logistic', logistic)
    ])

from sklearn.pipeline import Pipeline
pipe = Pipeline([
    ('anova', anova_filter),
    ('vote', vote)
    ])
parameters = {
    "anova__k": range(5, 8),
    "vote__svc__C": [0.03, 0.1, 0.3, 1, 3],
    "vote__nn__alpha": [3e-4, 1e-3, 3e-3]
    }

from sklearn.model_selection import GridSearchCV
grid_search_cv = GridSearchCV(
    pipe,
    param_grid=parameters,
    n_jobs=4,
    )

X = scrubbedData_X
y = scrubbedData_y
grid_search_cv.fit(X, y)
from sklearn.metrics import classification_report
print(classification_report(y, grid_search_cv.predict(X)))
# grid_search_cv.get_params()

test_for_submit = clean_input_data('test.csv')
test_for_submit = svm_feature_transform(test_for_submit)
test_for_submit.insert(14, 'Cabin_T', 0)

submit_preds = grid_search_cv.predict(X=test_for_submit)
submission = pd.DataFrame({ "PassengerId": clean_input_data('test.csv')["PassengerId"]
                          , "Survived":submit_preds})

submission.to_csv( "submission.csv"
                 , index=False)
