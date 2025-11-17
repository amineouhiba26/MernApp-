 #!/bin/bash

echo "🔨 Rebuilding client Docker image..."
cd client
docker build -t amineouhiba/mern-client:latest .

echo "📤 Pushing image to Docker Hub..."
docker push amineouhiba/mern-client:latest

echo "♻️  Restarting client pods in Kubernetes..."
cd ..
kubectl rollout restart deployment client-deployment

echo "⏳ Waiting for rollout to complete..."
kubectl rollout status deployment client-deployment

echo "✅ Client updated! Check with: kubectl get pods"
