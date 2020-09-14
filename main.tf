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
    name  = "tf_google_cloud_run"
    push {
      branch = "master"
    }
  }

  build {
    # images = ["gcr.io/shpock-yams/alexf-test:$COMMIT_SHA"] # with this name will be pushed to registry in case of success
    # step {
    #   name = "gcr.io/cloud-builders/docker"
    #   args = ["build", "-t", "gcr.io/shpock-yams/alexf-test:$COMMIT_SHA", "-f", "Dockerfile", "."]
    # }
    images = ["gcr.io/shpock-yams/alexf-test:latest"] # with this name will be pushed to registry in case of success
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-t", "gcr.io/shpock-yams/alexf-test:latest", "-f", "Dockerfile", "."]
    }
  }
}

resource "google_cloud_run_service" "default" {
  name     = "alexf-test"
  location = "europe-west1"

  template {
    spec {
      containers {
        #image = "gcr.io/shpock-yams/alexf-test:f4b4b9f7bc7ffd36e63b512c549f35a5df5abaa0"
        image = "gcr.io/shpock-yams/alexf-test:latest"
      }
    }
  }
  autogenerate_revision_name = true
}

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
