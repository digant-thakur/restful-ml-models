# Add Custom Supporting Python Projects to PATH
import sys
sys.path.append('myjwt/')

# Import Standard Libraries
from flask import Flask, Response, request, g
from flask_jwt import JWT, jwt_required
import pandas as pd
import joblib
import time
import logging

# Import Custom JQT In-Mem Implementation
from security import authenticate, identity

# Define Flask App, Secret, JWT Auth Implementation and Logging Config
app = Flask(__name__)
app.secret_key = "your-secret-key"
jwt = JWT(app, authenticate, identity)
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(name)s %(threadName)s : %(message)s')

######## OPTIONAL - HELPER CODE FOR LOGGING ########

# Health Check on HOME page
@app.route("/", methods=['GET'])
def health_check():
    return Response(status=200)

# Log Start Time    
@app.before_request
def start_request_execution():
    g.start_time = time.time()
    app.logger.info("Started Request")
    
# Log Execution Time
@app.teardown_request
def teardown_request(exception=None):
    if exception:
        app.logger.error(exception)
    else:
        app.logger.info("Finished Request. Time Taken: %f", time.time()-g.start_time)


######## YOUR CODE STARTS HERE ########

# 1. Define global Variable to pre-load model
mymodel = {}

# 2. Load the model in memory before the user request for performance gains
@app.before_first_request
def load_model_into_memory():
    global mymodel
    mymodel['boston_housing'] = joblib.load('models/boston_model.pkl')
    app.logger.info("Loaded Model {} into Memory")

# OPTIONAL: JWT AUTHENTICATION - Comment @jwt_required to TURN OFF 
@jwt_required()
@app.route('/predict', methods=['POST'])
def predict():
    # 3. Load the REST Post Body into Python Dict
    request_json = request.get_json(force=True)

    # 4. Preprocess the user data
    from sklearn.preprocessing import StandardScaler 
    scaler = StandardScaler()
    df = pd.DataFrame(request_json, index = [0])
    scaler.fit(df)
    df_x_scaled = scaler.transform(df)
    df_x_scaled = pd.DataFrame(df_x_scaled, columns = df.columns)

    # 5. Use the pre-loaded model and Generate Predictions
    global mymodel
    y_predict = mymodel['boston_housing'].predict(df_x_scaled)
    response = {"House Price": y_predict[0]}

    # 6. Return Response (as Dict), and appropriate HTTP STATUS Code
    return response, 200
