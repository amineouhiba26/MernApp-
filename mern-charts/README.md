# MERN Application Helm Charts

This directory contains Helm charts for deploying a MERN (MongoDB, Express, React, Node.js) stack application.

## Structure

```
mern-charts/
├── mern-app/       # Parent chart that orchestrates all components
├── mongodb/        # MongoDB database chart
├── server/         # Node.js backend server chart
└── client/         # React frontend client chart
```

## Prerequisites

- Kubernetes cluster (Docker Desktop, Minikube, or cloud provider)
- Helm 3.x installed
- kubectl configured to access your cluster

## Installation

### Option 1: Install the complete application

```bash
# Update dependencies
cd mern-charts/mern-app
helm dependency update

# Install the application
helm install mern-app . --namespace default
```

### Option 2: Install individual components

```bash
# Install MongoDB
helm install mongodb ./mongodb

# Install Server
helm install server ./server

# Install Client
helm install client ./client
```

## Configuration

The charts can be configured by modifying the `values.yaml` files in each chart directory.

### Common configurations:

- **Replica count**: Adjust the number of pod replicas
- **Image repository**: Change the Docker image repository
- **Image tag**: Specify different image versions
- **Environment variables**: Configure application-specific settings
- **Resource limits**: Set CPU and memory limits

### Example: Override values during installation

```bash
helm install mern-app ./mern-app \
  --set server.replicaCount=5 \
  --set client.replicaCount=2
```

## Upgrading

```bash
# Upgrade the application
helm upgrade mern-app ./mern-app

# Upgrade with new values
helm upgrade mern-app ./mern-app -f custom-values.yaml
```

## Uninstalling

```bash
# Uninstall the application
helm uninstall mern-app

# Or uninstall individual components
helm uninstall mongodb
helm uninstall server
helm uninstall client
```

## Access the Application

After installation, you can access the application:

1. Add an entry to your `/etc/hosts` file:
   ```
   127.0.0.1 mern-app.local
   ```

2. Access the application at: http://mern-app.local

## ArgoCD Deployment

These charts are designed to work with ArgoCD for GitOps-based deployment. See the main README for ArgoCD setup instructions.

## Chart Details

### mern-app (Parent Chart)
- Orchestrates all three components
- Manages dependencies between services
- Provides unified configuration

### mongodb
- Deploys MongoDB database
- ClusterIP service on port 27017
- Single replica by default

### server
- Deploys Node.js backend
- ClusterIP service on port 5000
- 3 replicas by default
- Connects to MongoDB

### client
- Deploys React frontend
- ClusterIP service on port 3000
- 3 replicas by default
- Includes Ingress configuration
- Connects to server

## Troubleshooting

Check pod status:
```bash
kubectl get pods
```

View logs:
```bash
kubectl logs -l app.kubernetes.io/name=server
kubectl logs -l app.kubernetes.io/name=client
kubectl logs -l app.kubernetes.io/name=mongodb
```

Describe resources:
```bash
helm status mern-app
kubectl describe deployment mern-app-server
```
