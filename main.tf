provider "google" {
  version = "~> 3.38"
  project = "shpock-yams"
}

resource "google_cloudbuild_trigger" "build_go_app" {
  name     = "alexf-test-trigger"
  provider = google-beta
  project  = "shpock-yams"
  github {
    owner = "alrf"
    name  = "go-hello-test"
    push {
      branch = "master"
    }
  }

  build {
    images = ["gcr.io/shpock-yams/alexf-test:$COMMIT_SHA"] # with this name will be pushed to registry in case of success
    step {
      name = "gcr.io/cloud-builders/alexf-test" # docker name during building
      args = ["build -t gcr.io/shpock-yams/alexf-test:$COMMIT_SHA -f Dockerfile ."]
    }
  }
  # trigger_template {
  #   branch_name = "master"
  #   repo_name   = "my-repo"
  # }

  # substitutions = {
  #   _FOO = "bar"
  #   _BAZ = "qux"
  # }

  # filename = "cloudbuild.yaml"
}

# resource "google_cloud_run_service" "default" {
#   name     = "alexf-test"
#   location = "europe-west1"

#   template {
#     spec {
#       containers {
#         image = "gcr.io/cloudrun/hello"
#       }
#     }
#   }
# }

# data "google_iam_policy" "noauth" {
#   binding {
#     role = "roles/run.invoker"
#     members = [
#       "allUsers",
#     ]
#   }
# }

# resource "google_cloud_run_service_iam_policy" "noauth" {
#   location = google_cloud_run_service.default.location
#   project  = google_cloud_run_service.default.project
#   service  = google_cloud_run_service.default.name

#   policy_data = data.google_iam_policy.noauth.policy_data
# }
