directory node['btrfs_snap']['snapshot_basedir'] do
    owner node['btrfs_snap']['snapshot_basedir_owner']
    group node['btrfs_snap']['snapshot_basedir_group']
    mode node['btrfs_snap']['snapshot_basedir_mode']
end

node['btrfs_snap']['snapshots'].each do |name, parms|
    btrfs_snap_snapshot name do
        mount parms['mount']
        schedule parms['schedule']
    end
end
