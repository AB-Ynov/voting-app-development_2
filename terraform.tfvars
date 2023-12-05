name = "AB"

charts = {
  nginx-ingress-controller = {
    create_namespace = true
    repository       = "https://charts.bitnami.com/bitnami"
    version          = "9.4.1"
    sets = {}
  }
  cert-manager = {
    create_namespace = true
    repository       = "https://charts.bitnami.com/bitnami"
    version          = "v0.9.4"
    sets = {}
  }
  redis = {
    create_namespace = true
    repository       = "https://charts.bitnami.com/bitnami"
    version          = "v17.9.2"
    sets = {
      "global.redis.password" = "plop",
      "replica.replicaCount" = 1
    }
  }
}
