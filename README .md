# Devops_Assignment

This repository contains the implementation of a Dockerized Express.js API with Swagger documentation, along with a CI/CD pipeline setup, cloud deployment options, and bonus features for a DevOps internship assignment.

## Steps to Complete the Assignment

### Dockerization & CI/CD Setup

#### 1. Dockerization

- **Create a Simple Express.js API**:
  - Built a basic Express.js API with a root endpoint (`/`) returning "Hello from PeerHire API!" and Swagger UI at `/api-docs`.
  - Dependencies: `express`, `swagger-jsdoc`, `swagger-ui-express`.
  - File: `server.js`.

- **Write a Dockerfile**:
  - Used `node:18-alpine` as the base image for a lightweight container.
  - Set up a working directory (`/app`), installed dependencies, and copied the app code.
  - Exposed port 3000 and set the start command to `npm start`.
  - File: `Dockerfile`.

- **Write a Docker Compose File**:
  - Defined a single service (`api`) to build and run the Dockerized API.
  - Mapped port `3000:3000`, set `NODE_ENV=production`, and added volumes for development convenience.
  - File: `docker-compose.yml`.

- **Test the Containerized API Locally**:
  - Build and run with: `docker-compose up --build`.
  - Test endpoints:
    - `http://localhost:3000/` - Returns the hello message.
    - `http://localhost:3000/api-docs` - Displays Swagger UI.

#### 2. CI/CD Pipeline Setup

- **Use GitHub Actions to Automate the Process**:
  - Workflow file: `.github/workflows/ci-cd.yml`.
  - Steps:
    1. **Run Unit Tests (Jest)**:
       - Install Jest (`npm install --save-dev jest`) and add a simple test file (e.g., `test/api.test.js`).
       - Example test: Check if `/` returns a 200 status.
       - Run: `npm test`.
    2. **Build Docker Image**:
       - Build the image using the Dockerfile: `docker build -t peerhire-api .`.
    3. **Push Image to Docker Hub or AWS ECR**:
       - Login to Docker Hub: `docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD`.
       - Tag image: `docker tag peerhire-api $DOCKER_USERNAME/peerhire-api:latest`.
       - Push: `docker push $DOCKER_USERNAME/peerhire-api:latest`.
       - (Note: Replace with AWS ECR steps if using AWS—requires AWS CLI and credentials.)
    4. **Deploy to Cloud**:
       - Example: Push to an EC2 instance or Kubernetes cluster (see Cloud Deployment below).
  - Secrets (e.g., `DOCKER_USERNAME`, `DOCKER_PASSWORD`) stored in GitHub Secrets.

---

### Cloud Deployment & API Documentation

#### 3. Cloud Deployment

- **Option 1: Deploy using AWS EC2 + Docker Compose**:
  - Launch an EC2 instance (e.g., Amazon Linux 2).
  - Install Docker and Docker Compose: 
    ```bash
    sudo yum update -y && sudo yum install docker -y
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    ```
  - Clone the repo: `git clone https://github.com/Varnit01-dev/Devops_Assignment.git`.
  - Run: `cd Devops_Assignment && docker-compose up -d`.
  - Access via EC2 public IP: `http://<ec2-public-ip>:3000`.

- **Option 2: Deploy using Kubernetes (EKS/GKE)**:
  - Create a Kubernetes manifest (`deployment.yaml`):
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: peerhire-api
    spec:
      replicas: 2
      selector:
        matchLabels:
          app: peerhire-api
      template:
        metadata:
          labels:
            app: peerhire-api
        spec:
          containers:
          - name: peerhire-api
            image: your-docker-username/peerhire-api:latest
            ports:
            - containerPort: 3000
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: peerhire-api-service
    spec:
      selector:
        app: peerhire-api
      ports:
      - port: 80
        targetPort: 3000
      type: LoadBalancer
    ```
  - Deploy to EKS/GKE:
    - Set up cluster (e.g., `eksctl create cluster` for EKS).
    - Apply: `kubectl apply -f deployment.yaml`.
    - Get external IP: `kubectl get svc peerhire-api-service`.

#### 4. API Documentation (Swagger & Postman)

- **Add Swagger UI to Express.js API**:
  - Integrated Swagger with OpenAPI 3.0.0 spec in `server.js`.
  - Accessible at `/api-docs` for interactive documentation and testing.
  - Example route documented: `/` (extend with more routes in `./routes/*.js` as needed).
- **Postman**:
  - Export Swagger spec as JSON from `/api-docs/json`.
  - Import into Postman to create a collection for API testing.

---

