# profile for NFS client mounts
class profile::nfs_client (
  Hash $mounts = {},
) {
  include nfs

  $mounts.each |String $mount, Hash $options| {
    nfs::client::mount { $mount:
      * => $options,
    }
  }
}
