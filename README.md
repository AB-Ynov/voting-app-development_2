```markdown
# Voting App Development

Ce projet déploie une application de vote sur Kubernetes en utilisant Helm Charts. Il inclut également un pipeline CI/CD pour déployer l'application en mode canary avec un poids de 50/50.

## Structure du Répertoire

```
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
├── outputs.tf
├── providers.tf
├── terraform.tf
└── variables.tf
```

## Utilisation

### Terraform Infrastructure

1. Assurez-vous que vous avez Terraform installé.
2. Modifiez les fichiers `terraform.tfvars` avec vos configurations spécifiques.
3. Exécutez `terraform init` et `terraform validate` pour initialiser et valider la configuration.
4. Exécutez `terraform plan` pour voir les changements prévus.
5. Une fois satisfaits, exécutez `terraform apply` pour déployer l'infrastructure.

### CI/CD Pipeline

Le pipeline CI/CD est déclenché automatiquement sur les pull requests. Il construit l'image Docker, la pousse vers le registre Docker et déploie l'application en mode canary sur Kubernetes.

### Docker Build Multi-Staged

Le fichier `Dockerfile` dans `platforms/dev` utilise un build multi-staged pour optimiser la taille de l'image.

### Packer et Ansible

1. Utilisez Packer pour construire une image Docker en remplaçant `${SHA}` par le commit SHA actuel.
2. Packer utilise Ansible pour le provisionnement. Les tâches spécifiques peuvent être ajoutées dans `ansible/playbook.yml`.

## Configuration Helm Chart

- `voting-app/values.yaml`: Configuration par défaut de l'application.
- `voting-app/values-canary.yaml`: Configuration spécifique pour le déploiement en mode canary.

## Remarques

- Assurez-vous d'ajuster les fichiers en fonction de votre configuration spécifique.
- Remplacez les valeurs telles que `your-docker-repo` par vos propres valeurs.

```
