# --- all hosts and whether they need fresh install ---
locals {
  hosts = {
    #"agent-0" = {
    #  needs_install = false
    #}
    "laptop" = {
      needs_install = false
    }
    #"laptop-huawei" = {
    #  needs_install = false
    #}
    #"server-0" = {
    #  needs_install = false
    #}
  }
}
