directory node['btrfs_snap']['dir'] do
    owner "root"
    group "root"
    mode 0755
end

directory "#{node['btrfs_snap']['dir']}/bin" do
    owner "root"
    group "root"
    mode 0755
end

git "#{Chef::Config[:file_cache_path]}/btfs-snap" do
    repository node['btrfs_snap']['git_url']
    reference node['btrfs_snap']['git_ref']
    notifies :run, "bash[install btrfs-snap]"
end

bash "install btrfs-snap" do
    action :nothing
    cwd "#{Chef::Config[:file_cache_path]}/btfs-snap"
    user "root"
    group "root"
    code <<-eos
        cp btrfs-snap #{node['btrfs_snap']['dir']}/bin
        chown root:root #{node['btrfs_snap']['dir']}/bin/btrfs-snap
        chmod 755 #{node['btrfs_snap']['dir']}/bin/btrfs-snap
    eos
end
