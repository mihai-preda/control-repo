# Libvirt instructions

The profile is fully parameterised via Hiera if you ever need to override defaults (e.g. switch to a static IP on a virt server):
hiera example:
profile::libvirt_bridge::ipv4_method: manual
profile::libvirt_bridge::ipv4_address: 10.21.2.x/24
profile::libvirt_bridge::ipv4_gateway: 10.21.2.254
Otherwise no node-level Hiera changes are needed — the defaults (br0, eno1, DHCP) match what you have.
