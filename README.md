# Deploy AI / ML Models as REST API on a Production Ready Docker Container
Deploy Production Ready ML Models as REST API on Docker and Kuberenetes. <br /> 
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
2. Add required libraries in requirements.txt (PIP) and conda-requirements.txt.
3. Load the model and predict the output in app.py.
4. Dockerfile Automatically adds - **Logging, JWT Authentication, gUnicorn (AppServer), nGinx (WebServer), TLS (HTTPS)** 
5. Run

## Options
1. HTTPS
    - By default HTTPS is On. To Turn off this behaviour, give option as: **-https false**
2. Increase Timeout
    - By default timeout is 60s. Based on the model complexity, sometimes prediction can take longer.<br /> To increase the timeout, give option as **-timeout 300s**

### HTTPS - Bring Your Own Certicate
- Configured to use TLS v1.2 and v1.3
- You can replace app/config/nginx/cert.crt and key.key with your own certificate and key.

### 

