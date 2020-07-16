# Prepare K8s environment for automatic deployments
# This should be done once.

# Create CI/CD service account to perform operation from outside
kubectl apply -f k8s-create-sa.yml

# Create a kubectl config file to use on CI/CD

TOKEN_NAME=$(kubectl get serviceaccount cicd-user -o jsonpath='{.secrets[0].name}')
APISERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
CA=$(kubectl get secret/$TOKEN_NAME -o jsonpath='{.data.ca\.crt}')
TOKEN=$(kubectl get secret/$TOKEN_NAME -o jsonpath='{.data.token}' | base64 --decode)
NAMESPACE=$(kubectl get secret/$TOKEN_NAME -o jsonpath='{.data.namespace}' | base64 --decode)

echo "
apiVersion: v1
kind: Config
clusters:
- name: remote-cluster
  cluster:
    certificate-authority-data: ${CA}
    server: ${APISERVER}
contexts:
- name: remote-context
  context:
    cluster: remote-cluster
    namespace: ${NAMESPACE}
    user: remote-user
current-context: remote-context
users:
- name: remote-user
  user:
    token: ${TOKEN}
" > sa.kubeconfig

# Now we get the config file and place its content as an environment variable on CI/CD tool
cat sa.kubeconfig