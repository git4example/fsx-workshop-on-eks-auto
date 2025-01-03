#! /bin/bash

aws sts get-caller-identity
export PRIMARY_REGION=$AWS_REGION
export SECONDARY_REGION=us-east-2
export PRIMARY_CLUSTER_NAME=FSx-eks-cluster
export SECONDARY_CLUSTER_NAME=FSx-eks-cluster02

#Check environment variables 
echo "PRIMARY_REGION        :" $PRIMARY_REGION
echo "SECONDARY_REGION      :" $SECONDARY_REGION
echo "PRIMARY_CLUSTER_NAME  :" $PRIMARY_CLUSTER_NAME
echo "SECONDARY_CLUSTER_NAME:" $SECONDARY_CLUSTER_NAME

#Update kubeconfig 
aws eks update-kubeconfig --name $PRIMARY_CLUSTER_NAME --region $PRIMARY_REGION

#Check cluster access 
kubectl get nodes

#Download Trident Operator
curl -L -o trident-installer-24.10.0.tar.gz https://github.com/NetApp/trident/releases/download/v24.10.0/trident-installer-24.10.0.tar.gz
tar -xvf ./trident-installer-24.10.0.tar.gz
cd trident-installer/helm
ls -ltr

#Helm Install Trident Operator
kubectl create ns trident
helm install trident -n trident trident-operator-100.2410.0.tgz
kubectl get pods -n trident
helm status trident -n trident

# Provision Trident volume and storage class
cd /home/participant/environment/eks-fsx-workshop/static/eks/FSxN

# fetch SVM password and sed into svm_secret.yaml file
# kubectl apply -f svm_secret.yaml