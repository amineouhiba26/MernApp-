# Kubernetes Deployment Guide

## Prerequisites
- Docker Desktop with Kubernetes enabled, OR
- Minikube installed and running
- kubectl installed

## Step 1: Build and Push Docker Images

First, build your Docker images:

```bash
# Build server image
cd server
docker build -t [your-dockerhub-username]/mern-server:latest .

# Build client image
cd ../client
docker build -t [your-dockerhub-username]/mern-client:latest .
```

Push images to Docker Hub:

```bash
docker push [your-dockerhub-username]/mern-server:latest
docker push [your-dockerhub-username]/mern-client:latest
```

**Important:** Replace `[username]` in the YAML files with your actual Docker Hub username!

## Step 2: Verify Kubernetes Cluster

```bash
# Check if Kubernetes is running
kubectl cluster-info

# Check nodes
kubectl get nodes
```

## Step 3: Deploy to Kubernetes

From the project root directory, apply all the YAML files:

```bash
# 1. Apply ConfigMap first
kubectl apply -f app-configmap.yaml

# 2. Deploy MongoDB
kubectl apply -f mongodb-deployment.yaml
kubectl apply -f mongodb-service.yaml

# 3. Deploy Server
kubectl apply -f server-deployment.yaml
kubectl apply -f server-service.yaml

# 4. Deploy Client
kubectl apply -f client-deployment.yaml
kubectl apply -f client-service.yaml
```

## Step 4: Verify Deployments

Check if everything is running:

```bash
# Check all pods
kubectl get pods

# Check all deployments
kubectl get deployments

# Check all services
kubectl get services

# View logs if needed
kubectl logs -l app=mern-server
kubectl logs -l app=mern-client
kubectl logs -l app=mongodb
```

## Step 5: Access the Application

**For Docker Desktop:**
- Client: http://localhost:30002
- Server: http://localhost:30001

**For Minikube:**
```bash
# Get the client URL
minikube service client-service --url

# Get the server URL
minikube service server-service --url
```

## Useful Commands

### Scaling
```bash
# Scale server to 5 replicas
kubectl scale deployment server-deployment --replicas=5

# Scale client to 2 replicas
kubectl scale deployment client-deployment --replicas=2
```

### Update Image (Rolling Update)
```bash
# Update client to v2
kubectl set image deployment/client-deployment mern-client=[username]/mern-client:v2
```

### Check Status
```bash
# Watch pods in real-time
kubectl get pods -w

# Describe a specific pod
kubectl describe pod [pod-name]

# Get detailed deployment info
kubectl describe deployment server-deployment
```

### Debugging
```bash
# Get logs from a specific pod
kubectl logs [pod-name]

# Follow logs in real-time
kubectl logs -f [pod-name]

# Execute commands in a pod
kubectl exec -it [pod-name] -- sh
```

## Clean Up Everything

When you're done, delete all resources:

```bash
kubectl delete -f client-service.yaml
kubectl delete -f client-deployment.yaml
kubectl delete -f server-service.yaml
kubectl delete -f server-deployment.yaml
kubectl delete -f mongodb-service.yaml
kubectl delete -f mongodb-deployment.yaml
kubectl delete -f app-configmap.yaml
```

Or delete everything at once:

```bash
kubectl delete -f .
```

## Troubleshooting

### Pods not starting?
```bash
kubectl describe pod [pod-name]
kubectl logs [pod-name]
```

### Can't pull images?
- Make sure you replaced `[username]` with your Docker Hub username in the YAML files
- Make sure images are pushed to Docker Hub
- Check if images are public or if you need to configure image pull secrets

### MongoDB connection issues?
- Check if mongodb-service is running: `kubectl get svc mongodb-service`
- Check mongodb logs: `kubectl logs -l app=mongodb`

### Port conflicts?
- Make sure ports 30001 and 30002 are not in use on your machine
- You can change the nodePort values in the service YAML files
