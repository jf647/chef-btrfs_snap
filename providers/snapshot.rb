def whyrun_supported?
    true
end

def mk_insideparms(s)
    case s
        when '10_minutes'
            return true
        else
            return false
    end
end

def mk_cronparms(s)
    case s
        when '10_minutes'
            return %w(* * * * *)
        when '1_hour'
            return %w(*/5 * * * *)
        when '1_day_fast'
            return %w(3 * * * *)
        when '1_day_slow'
            return %w(6 */3 * * *)
        when '1_week'
            return %w(9 0 * * *)
        when '2_weeks'
            return %w(12 0 * * *)
        when '3_months'
            return %w(15 0 * * 1)
        when '6_months'
            return %w(18 0 1 * *)
        when '1_year'
            return %w(21 0 1 */3 *)
        else
            raise "unknown btrfs-snap schedule '#{s}'"
    end
end

def mk_schedparms(s)
    case s
        when '10_minutes'
            return '1m 10'
        when '1_hour'
            return '5m 12'
        when '1_day_fast'
            return '1h 24'
        when '1_day_slow'
            return '3h 8'
        when '1_week'
            return '1d 7'
        when '2_weeks'
            return '1d 14'
        when '3_months'
            return '1w 12'
        when '6_months'
            return '1mo 6'
        when '1_year'
            return '3mo 4'
        else
            raise "unknown btrfs-snap schedule '#{s}'"
    end
end

def mk_command(r, s)
    command = "#{node['btrfs_snap']['dir']}/bin/btrfs-snap"
    if ! mk_insideparms(s)
        command += " -b #{r.basedir}"
    end
    if r.readonly
        command += " -r"
    end
    command += " #{r.mount} #{mk_schedparms(s)}"
    return command
end

action :create do
    new_resource.basedir( new_resource.basedir || node['btrfs_snap']['snapshot_base'] )
    converge_by "creating btrfs-snap cronjobs" do
        new_resource.schedule.each do |s|
            cronparms = mk_cronparms(s)
            cron "#{new_resource.name}_#{s}" do
                command mk_command(new_resource, s)
                minute cronparms[0]
                hour cronparms[1]
                day cronparms[2]
                month cronparms[3]
                weekday cronparms[4]
            end
        end
    end
end

action :remove do
    converge_by "removing btrfs-snap cronjobs" do
        new_resource.schedule.each do |s|
            cron "#{new_resource.name}_#{s}" do
                action :remove
            end
        end
    end
end
