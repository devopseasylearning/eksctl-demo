# Source: https://gist.github.com/681a5f4455428379e00bc815450e12d8

#############################################
# eksctl                                    #
# How to Create and Manage AWS EKS clusters #
# https://youtu.be/pNECqaxyewQ              #
#############################################

#########
# Setup #
#########

# Install the CLI from https://eksctl.io/introduction/#installation

export AWS_ACCESS_KEY_ID=[...]

export AWS_SECRET_ACCESS_KEY=[...]

export KUBECONFIG=$PWD/kubeconfig.yaml

###############################
# How NOT to create a cluster #
###############################

# Do NOT do this!
# eksctl create cluster

# Do NOT do this!
# eksctl create cluster \
#     --name devops-catalog \
#     --region us-east-2 \
#     --version 1.18 \
#     --nodegroup-name primary \
#     --node-type t2.small \
#     --nodes-min 3 \
#     --nodes-max 6 \
#     --managed \
#     --spot \
#     --asg-access \
#     --full-ecr-access

######################
# Creating a cluster #
######################

git clone \
    https://github.com/vfarcic/eksctl-demo.git

cd eksctl-demo

cat cluster-1.17.yaml

# Open https://eksctl.io/usage/schema/

eksctl create cluster \
    --config-file cluster-1.17.yaml

##########################
# Exploring the outcomes #
##########################

# Open AWS Web Console and make sure that us-east-2 is selected

eksctl get clusters --region us-east-2

kubectl get nodes

###############################
# How NOT to scale a cluster #
###############################

# Do NOT do this
# eksctl scale nodegroup \
#     --cluster devops-catalog \
#     --nodes 4 \
#     --name primary

# Cluster Autoscaler?
# Open https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html

###############################
# Upgrading the control plane #
###############################

diff cluster-1.17.yaml \
    cluster-1.18.yaml

eksctl upgrade cluster \
    --config-file cluster-1.18.yaml

eksctl upgrade cluster \
    --config-file cluster-1.18.yaml \
    --approve

kubectl get nodes

##########################
# Upgrading worker nodes #
##########################

eksctl create nodegroup \
    --config-file cluster-1.18.yaml

kubectl get nodes

eksctl delete nodegroup \
    --config-file cluster-1.18.yaml \
    --only-missing

eksctl delete nodegroup \
    --config-file cluster-1.18.yaml \
    --only-missing \
    --approve

kubectl get nodes

#######################
# What else is there? #
#######################

eksctl utils describe-addon-versions \
    --cluster devops-catalog \
    --region us-east-2

##########################
# Destroying the cluster #
##########################

eksctl delete cluster \
    --config-file cluster-1.18.yaml \
    --wait
