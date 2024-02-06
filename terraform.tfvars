dockerhub_credentials = "arn:aws:secretsmanager:us-east-1:365235792173:secret:codebuild/dockerhub-zyCkEI"
codestar_connector_credentials = "arn:aws:codestar-connections:us-east-1:365235792173:connection/6b72cab4-2cf9-4cf7-bbe4-02767612b705"




demo_app_cluster_name        = "demo-app-cluster"
availability_zones           = ["us-east-1a", "us-east-1b", "us-east-1c"]
demo_app_task_famliy         = "demo-app-task"
container_port               = 3000
demo_app_task_name           = "demo-app-task"
ecs_task_execution_role_name = "demo-app-task-execution-role"

application_load_balancer_name = "cc-demo-app-alb"
target_group_name              = "cc-demo-alb-tg"

demo_app_service_name = "cc-demo-app-service"

ecr_repo_url = "365235792173.dkr.ecr.us-east-1.amazonaws.com/helloworld:latest"