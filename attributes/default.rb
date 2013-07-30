default['btrfs_snap']['install_dir'] = '/opt/btrfs-snap'
default['btrfs_snap']['btrfs_prog'] = '/sbin/btrfs'
default['btrfs_snap']['snapshot_basedir'] = '/snapshots'
default['btrfs_snap']['snapshot_basedir_owner'] = 'root'
default['btrfs_snap']['snapshot_basedir_group'] = 'root'
default['btrfs_snap']['snapshot_basedir_mode'] = 0755
default['btrfs_snap']['git_url'] = 'https://github.com/jf647/btrfs-snap.git'
default['btrfs_snap']['git_ref'] = 'master'
default['btrfs_snap']['rootmount'] = '/btrfs'
default['btrfs_snap']['enable_periodic_scrub'] = false
default['btrfs_snap']['periodic_scrub_schedule'] = { 'weekday' => 4, 'minute' => 30, 'hour' => 2 }
