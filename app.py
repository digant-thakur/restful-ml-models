from flask import Flask, request, Response
from flask_restful import Resource, Api
from flask_jwt import JWT, jwt_required
import pandas as pd
import joblib
import sys


# Custom JWT Implementation using In-Memory Database
sys.path.append('myjwt/')
from security import authenticate, identity

# Define app and secret
app = Flask(__name__)
app.secret_key = "mysecret"

# Define API and load Custom JWT
api = Api(app)
jwt = JWT(app, authenticate, identity)

# Health Check on '/'
@app.route("/", methods=['GET'])
def health_check():
    return Response(status=200)

# Global Variable to pre-load model
mymodel = {}
# Load the model in memory before the user request for performance gains
@app.before_first_request
def load_model():
    global mymodel
    mymodel['boston_housing'] = joblib.load('models/boston_model.pkl')

# RESTful class to handle predictions
class Prediction(Resource):
    @jwt_required()
    def post(self):
        # Load the User Request JSON into dict
        request_json = request.get_json()

        # Preprocess the user data as per app logic
        from sklearn.preprocessing import StandardScaler 
        scaler = StandardScaler()

        df = pd.DataFrame(request_json, index = [0])
        scaler.fit(df)

        df_x_scaled = scaler.transform(df)
        df_x_scaled = pd.DataFrame(df_x_scaled, columns = df.columns)

        # Generate Predictions
        global mymodel
        y_predict = mymodel['boston_housing'].predict(df_x_scaled)
        response = {"House Price": y_predict[0]}
        return response, 200



api.add_resource(Prediction, '/predict')
app.run(port = 5000, debug= True)