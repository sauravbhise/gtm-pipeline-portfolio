# GCP e2-micro instance for n8n (Always Free tier)
# See docs/decisions.md — 2026-08-17 entry — for why GCP over Oracle.

resource "google_compute_instance" "n8n-prod" {
  boot_disk {
    auto_delete = true
    device_name = "n8n-prod"
    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2404-noble-amd64-v20260810"
      size  = 30
      type  = "pd-standard"
    }
    mode = "READ_WRITE"
  }
  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false
  labels = {
    goog-ec-src           = "vm_add-tf"
    goog-ops-agent-policy = "v2-template-1-7-0"
  }
  machine_type = "e2-micro"
  metadata = {
    enable-osconfig = "TRUE"
  }
  name = "n8n-prod"
  network_interface {
    access_config {
      network_tier = "PREMIUM"
    }
    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/gtm-pipeline-portfolio/regions/us-central1/subnetworks/default"
  }
  reservation_affinity {
    type = "ANY_RESERVATION"
  }
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }
  service_account {
    email  = "269861030771-compute@developer.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }
  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }
  tags = ["http-server", "https-server"]
  zone = "us-central1-c"
}

module "ops_agent_policy" {
  source        = "github.com/terraform-google-modules/terraform-google-cloud-operations/modules/ops-agent-policy"
  project       = "gtm-pipeline-portfolio"
  zone          = "us-central1-c"
  assignment_id = "goog-ops-agent-v2-template-1-7-0-us-central1-c"
  agents_rule = {
    package_state = "installed"
    version       = "latest"
  }
  instance_filter = {
    all = false
    inclusion_labels = [{
      labels = {
        goog-ops-agent-policy = "v2-template-1-7-0"
      }
    }]
  }
}
