if node['btrfs_snap']['enable_periodic_scrub']
    cron "btrfs_periodic_scrub" do |c|
        command "#{node['btrfs_snap']['btrfs_prog']} scrub start #{node['btrfs_snap']['rootmount']}"
        node['btrfs_snap']['periodic_scrub_schedule'].each do |k, v|
            c.send(k, v)
        end
    end
end
