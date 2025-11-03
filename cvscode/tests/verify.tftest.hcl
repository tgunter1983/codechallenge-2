# tests/verify.tftest.hcl
# -----------------------------------
# Verifies that deployed ECS, CloudWatch configuration match expectations
# Uses outputs from the verify module
# Run: terraform test
# -----------------------------------

run "verify_ecs_and_logs" {
  command = plan

  assert {
    condition     = module.verify.ecs_cluster_verified == true
    error_message = " ECS cluster is not ACTIVE"
  }

  assert {
    condition     = module.verify.ecs_taskdef_verified == true
    error_message = " ECS task definition not found or invalid"
  }

  assert {
    condition     = module.verify.loggroup_verified == true
    error_message = " CloudWatch Log Group not found"
  }

  assert {
    condition     = (
      module.verify.ecs_cluster_verified &&
      module.verify.ecs_taskdef_verified &&
      module.verify.loggroup_verified
    )
    error_message = " One or more infrastructure checks failed."
  }
}
