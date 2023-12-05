# Voting App Development

Ce projet déploie une application de vote sur Kubernetes en utilisant Helm Charts. Il inclut également un pipeline CI/CD pour déployer l'application en mode canary avec un poids de 50/50.

## Structure du Répertoire

```markdown
.
├── .github
│   └── workflows
│       └── on_pull_request.yml
├── platforms
│   └── dev
│       └── Dockerfile
├── voting-app
│   ├── Chart.yaml
│   ├── values.yaml
│   ├── values-canary.yaml
│   ├── templates
│   │   ├── deployment.yaml
│   │   ├── ingress.yaml
│   │   └── service.yaml
├── .gitignore
├── README.md
├── outputs.tf
├── packer.json
├── providers.tf
├── terraform.tf
└── variables.tf
```

## Utilisation

### Terraform Infrastructure

1. Assurez-vous d'avoir Terraform installé.
2. Modifiez les fichiers `terraform.tfvars` avec vos configurations spécifiques.
3. Exécutez `terraform init` et `terraform validate` pour initialiser et valider la configuration.
4. Exécutez `terraform plan` pour voir les changements prévus.
5. Une fois satisfaits, exécutez `terraform apply` pour déployer l'infrastructure.

Dans le terminal du Codespace, exécutez les commandes nécessaires pour initialiser et déployer le projet.

#### Installer Terraform

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null

sudo apt-get update && sudo apt-get install terraform
```

#### Installer Azure CLI

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az --version
```

#### Se Connecter à Azure CLI

```bash
az login --use-device-code
```

## Configuration Helm Chart

- `voting-app/values.yaml`: Configuration par défaut de l'application.
- `voting-app/values-canary.yaml`: Configuration spécifique pour le déploiement en mode canary.

Vous pouvez déployer le Helm Chart sur un cluster Kubernetes avec les commandes suivantes :

```bash
# Installer le Helm Chart
helm upgrade --install voting-app ./voting-app -f ./voting-app/values-canary.yaml --set canary.enabled=true --set canary.weight=50
```

## Remarques

- Assurez-vous d'ajuster les fichiers en fonction de votre configuration spécifique.
- Remplacez les valeurs telles que `your-docker-repo` par vos propres valeurs.

Pour utiliser le Codespace avec le projet, vous pouvez suivre ces étapes d'installation et de lancement du projet. Assurez-vous que toutes les dépendances nécessaires sont installées dans votre Codespace. Notez que ces instructions supposent que vous avez déjà configuré les secrets appropriés dans les paramètres du dépôt GitHub.

### Installation

1. **Azure CLI:**

    ```bash
    curl -fsSL https://aka.ms/InstallAzureCLIDeb |

 sudo bash
    ```

2.**Terraform:**

```bash
    sudo apt-get install -y unzip
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
    sudo apt-get update && sudo apt-get install terraform
    ```

3.**Docker:**

```bash
    curl -fsSL https://get.docker.com | sudo bash
    sudo usermod -aG docker $USER
    ```

4.**Helm:**

    ```bash
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod +x get_helm.sh
    ./get_helm.sh
    ```

Vérifiez que Minikube est Démarré : Si vous utilisez Minikube, assurez-vous qu'il est démarré. Exécutez la commande suivante pour démarrer Minikube si ce n'est pas déjà fait :

```bash
minikube start
```

Vérifiez la Configuration Kubernetes : Vérifiez que kubectl pointe vers le bon cluster Kubernetes. Exécutez la commande suivante pour afficher la configuration kubectl :

```bash
kubectl config view
```

#### Initialiser et déployer l'infrastructure Terraform

```bash
terraform init
terraform validate
terraform plan
terraform apply
```

### CI/CD Pipeline

Le pipeline CI/CD est déclenché automatiquement sur les pull requests. Il construit l'image Docker, la pousse vers le registre Docker et déploie l'application en mode canary sur Kubernetes.

### Docker Build Multi-Staged

Le fichier `Dockerfile` dans `platforms/dev` utilise un build multi-staged pour optimiser la taille de l'image.

### Packer et Ansible

1. Utilisez Packer pour construire une image Docker en remplaçant `${SHA}` par le commit SHA actuel.
2. Packer utilise Ansible pour le provisionnement. Les tâches spécifiques peuvent être ajoutées dans `ansible/playbook.yml`.

Vous pouvez également exécuter le processus de build multi-staged Docker en exécutant les commandes suivantes :

#### Construire l'image Docker multi-staged

```bash
docker build -t your-docker-repo/voting-app:${SHA} -f platforms/dev/Dockerfile .
```

#### Pousser l'image vers le registre Docker

```bash
docker push your-docker-repo/voting-app:${SHA}
```
