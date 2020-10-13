# Deploy ML Models as REST API on a Production Ready Docker Container
**Tech Stack**: Python, Conda, Flask-RESTful, gUnicorn, nGinx, Docker, Kuberenetes.

## Features
1. **Model Preloading** into memory for Performance enhancements
2. **HTTPS** enabled. 
3. Critical nGinx **Security Vulnerabilities Cleared.** 
4. **JWT Authentication** Support.
5. **Aggregated Logs** on Console. (nGinx + gUnicorn + Flask)
6. **Easy to Use** - Production Ready in 5 mins.

## How to Use
1. Copy your models into models directory.
    1. Clone Repo
     >git clone https://github.com/digant-thakur/restful-ml-models
    2. Copy Model
     >cp my_model.pkl restful-ml-models/models
2. Add required libraries in requirements.txt (PIP) and conda-requirements.txt.  
3. Load the model and predict the output in app.py.
    > #app.py<br />
    ........<br />
    global mymodel<br />
    mymodel['my_model_name'] = joblib.load('models/my_model.pkl')<br />
    ........<br />
    prediction = mymodel['my_model_name'].predict(input)<br />
    response = {"Precition": prediction}<br />
    return response<br />
    ........<br />
4. **BONUS**: Dockerfile Automatically adds - **Logging, JWT Authentication, gUnicorn (AppServer), nGinx (WebServer), TLS (HTTPS)** 
5. Run
    > docker-compose up
6. Test (Postman also works)
    1. Health Check
    > curl -k https://localhost:32768/ 
    2. Predict
    > curl -k -X POST -d '{"param": "value"}' https://localhost:32768/predict

## Design
- ### API Design
![System Design](illustrations/system_design.png#center) 

- ### Docker Layers 
    - User only manages Source Code + Dependencies (Light Gray).<br /> Other components are automatically added/managed by dockerfile.
![Dockerfile Layering](illustrations/container_design.png#center)


## Options
1. HTTPS
    - By default HTTPS is on. To Turn off this behaviour, give option as: `-https false` while running.
    - `docker build -t mlapp .`
    - `docker run mlapp -https false`
2. Increase Timeout
    - By default timeout is 60s. Based on the model complexity, sometimes prediction can take longer.<br /> To increase the timeout, give option as `-timeout 300s` while running.
    - `docker build -t mlapp .`
    - `docker run mlapp -timeout 300`
### HTTPS - Bring Your Own Certicate
- Configured to use TLS v1.2 and v1.3
- You can replace `config/nginx/cert.crt` and `config/nginx/key.key` with your own certificate and key.

### JWT Authentication - 
- Turned On by default, to turn off - comment `@jwtrequired()` decorator in app.py

#### Open to all feedback and suggestions