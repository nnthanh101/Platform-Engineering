
resource "kubernetes_role" "devs_kube_role" {
  metadata {
    name = "default:developers"
  }

  rule {
    api_groups = ["*"]
    resources  = ["services", "deployments", "pods", "configmaps", "pods/log"]
    verbs      = ["get", "list", "watch", "update", "create", "patch"]
  }
}

resource "kubernetes_role_binding" "devs_kube_role_binding" {
  metadata {
    name = "eks-dev-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "default:developers"
  }
  subject {
    kind      = "Group"
    name      = "default:developers"
    api_group = "rbac.authorization.k8s.io"
  }
}
