# windows profile
# Baseline for Windows nodes. Deliberately minimal: the Linux baseline
# (accounts, epel, profile::base) assumes RPM/systemd and cannot apply here.
class profile::windows {
  include profile::openvox_agent
}
