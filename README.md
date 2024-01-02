# Correction

## Terraform
Rien de complexe dans le Terraform on utilise simplement les valeurs par defaut pour deployer.

Il faut cependant bien penser a ecrire le fichier kube config sur notre systeme avant de pouvoir deployer les helm charts

Au niveau Helm chart on reutilise ceux de la communauté pour l'ingress et redis il suffit simplement de suivre la documentation.

## Helm Chart
On cree le chart de notre voting-app avec la commande ```helm create```, on doit legerement modifier le fichier `templates/deployment.yaml` pour inclure la variable d'environnement et on donne la valeur ```redis.redis.svc.cluster.local``` qui pointe vers le FQDN dans Kubernetes directement.

On change quelques valeurs dans le fichier `values.yaml` entre autre pour activer l'ingress et on modifie le nom de domaine.

Vu qu'on a pas de serveur DNS on modifie le fichier `/etc/hosts` de notre machine pour faire pointer l'IP public de notre cluster vers le nom choisit, puis on peut interroger le FQDN

## KubeConfig
La Kubeconfig est le fichier vous permettant de vous connecter a votre cluster Kubernetes, sans ce fichier la connexion va etre difficile.

Il faut imperativement l'ecrire dans un fichier sur votre machine sinon vous ne pourrez jamais deployer vos helm charts
c'est le but de ce bloc terraform 
```HCL 
resource "local_file" "kube_config" {
    content  = azurerm_kubernetes_cluster.aks.kube_config_raw
    filename = ".kube/config"
}
```

## Kubecost
Pour installer Kubecost, il va vous falloir creer un compte sur le site de kubecost directement, grace a ça vous pourrez avoir un token dont vous servirez pour le deploiement.
Soit vous passez en ligne de commande avec kubectl
```shell
helm install kubecost kubecost/cost-analyzer -n kubecost --create-namespace \
  --set kubecostToken="aGVsbUBrdWJlY29zdC5jb20=xm343yadf98"
```

Soit vous adaptez le terraform comme ceci:
```HCL
resource "helm_release" "kubecost" {
  name             = "kubecost"
  namespace        = "kubecost"
  create_namespace = true
  repository       = "https://kubecost.github.io/cost-analyzer/"
  chart            = "cost-analyzer"

  set {
    name  = "kubecostToken"
    value = "token"
  }

  depends_on = [
    azurerm_kubernetes_cluster.aks,
    local_file.kube_config
  ]
}

```


## Rappel des commandes 
| commande | Description |
|----|-----|
| terraform init | Initialise terraform dans le dossier courant |
| terraform validate . | Verifie la syntaxe des fichier terraform |
| terraform plan | Affiche ce que va deployer terraform |
| terraform apply | Deploie les resources ecrite dans terraform |
| terraform destroy | Detruis les resources ecrite dans terraform |
| helm create nom_chart | Cree un nouveau repo helm |
| helm install NAME nom_chart | Installe le chart nom_chart au nom de NAME dans kubernetes |
| helm upgrade NAME nom_chart | Update le chart nom_chart au nom de NAME dans kubernetes avec les nouvelles valeurs |
| helm uninstall nom_chart | Supprime le chart nom_chart dans kubernetes ainsi que les pods |
| helm rollback nom_chart | Reviens a la version precedente du chart |