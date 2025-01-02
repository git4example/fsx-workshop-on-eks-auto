
## Create stack 
Upload AWS CloudFormation template to your bucket in order to validate template before stack creation.
```bash
export BUCKET_NAME= < YOUR BUCKET NAME >

```bash
# Upload template to S3
aws s3 cp ./static/FSXWorkshopOnEKS.yaml s3://$BUCKET_NAME/FSXWorkshopOnEKS.yaml

# Validate template
aws cloudformation validate-template --template-url https://$BUCKET_NAME.s3.amazonaws.com/FSXWorkshopOnEKS.yaml
```

This may take upto 45-60 mins : 
```bash
# Set variables
export REGION=us-west-2
export SECONDARY_REGION=us-east-2
STACK_NAME=FSXWorkshopOnEKS
VSINSTANCE_NAME=VSCodeServerForEKS
ASSET_BUCKET_ZIPPATH=""

# Create stack
aws cloudformation create-stack \
  --stack-name ${STACK_NAME} \
  --template-url https://databackupbucket.s3.amazonaws.com/FSXWorkshopOnEKS.yaml \
  --region $REGION \
  --parameters \
  ParameterKey=VSCodeUser,ParameterValue=participant \
  ParameterKey=InstanceName,ParameterValue=${VSINSTANCE_NAME} \
  ParameterKey=InstanceVolumeSize,ParameterValue=100 \
  ParameterKey=InstanceType,ParameterValue=t4g.medium \
  ParameterKey=InstanceOperatingSystem,ParameterValue=AmazonLinux-2023 \
  ParameterKey=HomeFolder,ParameterValue=environment \
  ParameterKey=DevServerPort,ParameterValue=8081 \
  ParameterKey=AssetZipS3Path,ParameterValue=${ASSET_BUCKET_ZIPPATH} \
  ParameterKey=BranchZipS3Path,ParameterValue="" \
  ParameterKey=FolderZipS3Path,ParameterValue="" \
  ParameterKey=SecondaryRegion,ParameterValue=${SECONDARY_REGION} \
  --disable-rollback \
  --capabilities CAPABILITY_NAMED_IAM

# Wait for stack creation to complete
aws cloudformation wait stack-create-complete --stack-name ${STACK_NAME} --region $REGION
```

## Clean up :
This may take upto 30 mins : 

```bash
# Delete stack
aws cloudformation delete-stack --stack-name ${STACK_NAME} --region $REGION

# Wait for stack deletion to complete
aws cloudformation wait stack-delete-complete --stack-name ${STACK_NAME} --region $REGION
```



## Shortcuts 

```bash
alias k=kubectl
alias ka="kubectl apply -f "
alias ke="kubectl exec -it "
alias kg="kubectl get "
alias kd="kubectl describe "
alias kdel="kubectl delete "
alias kl='kubectl -n karpenter logs -l app.kubernetes.io/name=karpenter --all-containers=true -f --tail=20'
alias ks="kubectl -n kube-system "
alias ksg="kubectl -n kube-system get "
alias ksd="kubectl -n kube-system describe "
alias ktest="k run -it netshoot --image=nicolaka/netshoot /bin/bash"
```
