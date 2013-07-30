if node['btrfs_snap']['enable_weekly_scrub']
    cron "btrfs_weekly_scrub" do
        command "#{node['btrfs_snap']['btrfs_prog']} scrub start #{node['btrfs_snap']['rootmount']}"
        node['btrfs_snap']['weekly_scrub_schedule'].each do |k, v|
            k v
        end
    end
end
