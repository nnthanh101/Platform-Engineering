locals {

  common_roles = [{
    rolearn  = module.iam.eks_rbac_admin_arn
    username = "admin"
    groups = [
    "system:masters"]
    },
    {
      rolearn  = module.iam.eks_rbac_devs_arn
      username = "devs"
      groups = [
      "default:developers"]
  }]
}
