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
    1. Clone repo
     >git clone https://github.com/digant-thakur/restful-ml-models
    2. Copy model(s)
     >cp my_model.pkl restful-ml-models/models
2. Add required libraries in requirements.txt (PIP) and conda-requirements.txt.  
3. Load the model and predict the output in app.py.
4. **BONUS**: Dockerfile Automatically adds - **Logging, JWT authentication, gUnicorn (AppServer), nGinx (WebServer), TLS (HTTPS).** 
5. Run
    > docker-compose up
6. Test (Postman also works)
    1. Health check on **Path**: `/`
    > curl -k https://localhost:32768/
    2. Get JWT auth token at **Path**: `/auth`. **Method**: `POST`. **Default credentials (in Body)**: `{"username": "user", "password": "pass"}`.
        > curl -k --header "Content-Type: application/json" <br />
            --request POST <br />
            --data '{"username":"xyz","password":"xyz"}' <br />
            https://localhost:32768/auth
    3. Prediction at **Path**: `/predict`. **Method**: `POST`. **Body**: `as per code`

## Design
- ### API Design
![System Design](illustrations/system_design.png#center) 

- ### Docker Layers 
    - User only manages Source Code + Dependencies (Light Gray).<br /> Other components are automatically added/managed by dockerfile.
![Dockerfile Layering](illustrations/container_design.png#center)


## Options
1. HTTPS
    - By default HTTPS is on. To Turn off this behaviour, give option as: `-https false` while running. (Host port changes to 32767)
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