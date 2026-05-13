# Installs libvirt/KVM and configures a bridged network so that virtual
# machines can communicate directly on the local subnet.
#
# A NetworkManager bridge connection (br0 by default) is created and the
# nominated physical interface is enslaved to it as a port.  The host IP
# moves to the bridge.  A matching libvirt network is then defined so that
# VMs can be attached to the bridge via virt-install / virsh.
#
# @param bridge_name  Name of the bridge interface to create.
# @param phy_iface    Physical NIC to enslave as the bridge port.
# @param ipv4_method  'auto' for DHCP or 'manual' for a static address.
# @param ipv4_address Static IPv4 address in CIDR notation (e.g. 10.21.2.5/24).
#                     Required when ipv4_method is 'manual'.
# @param ipv4_gateway Default gateway IP.  Required when ipv4_method is 'manual'.
# @param libvirt_net  Name given to the libvirt network definition.
class profile::libvirt_bridge (
  String           $bridge_name  = 'br0',
  String           $phy_iface    = 'eno1',
  String           $ipv4_method  = 'auto',
  Optional[String] $ipv4_address = undef,
  Optional[String] $ipv4_gateway = undef,
  String           $libvirt_net  = 'host-bridge',
) {
  # ── 1. libvirt packages and service ─────────────────────────────────────────
  # The cirrax-libvirt main class installs distribution-appropriate packages
  # (libvirt-daemon-kvm, qemu-kvm, etc.) via its own Hiera data and manages
  # the libvirtd service.  Everything else in this profile depends on it.
  include libvirt

  # ── 2. NetworkManager connection files ───────────────────────────────────────
  $nm_dir = '/etc/NetworkManager/system-connections'

  $ipv4_section = $ipv4_method ? {
    'manual' => "method=manual\naddress1=${ipv4_address},${ipv4_gateway}",
    default  => 'method=auto',
  }

  $bridge_conn = "[connection]
id=${bridge_name}
type=bridge
interface-name=${bridge_name}

[bridge]
stp=false

[ipv4]
${ipv4_section}

[ipv6]
method=disabled
"

  $port_conn = "[connection]
id=${phy_iface}-bridge-port
type=ethernet
interface-name=${phy_iface}
master=${bridge_name}
slave-type=bridge

[ethernet]
"

  file { "${nm_dir}/${bridge_name}.nmconnection":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => $bridge_conn,
    notify  => Exec['nm-bridge-reload'],
  }

  file { "${nm_dir}/${phy_iface}-bridge-port.nmconnection":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => $port_conn,
    notify  => Exec['nm-bridge-reload'],
  }

  # Reload NM connection profiles whenever either file changes.
  # refreshonly ensures this is a no-op on subsequent runs with no file drift.
  exec { 'nm-bridge-reload':
    command     => '/usr/bin/nmcli connection reload',
    refreshonly => true,
  }

  # ── 3. libvirt bridge network ────────────────────────────────────────────────
  # forward_mode defaults to 'bridge' in cirrax-libvirt, so only the bridge
  # name and autostart flag are required here.
  libvirt::network { $libvirt_net:
    ensure    => present,
    bridge    => $bridge_name,
    autostart => true,
    require   => Class['libvirt'],
  }
}
