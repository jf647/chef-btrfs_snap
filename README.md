# chef-btrfs_snap

## Description

Cookbook for Opscode chef to make snapshots of btrfs filesystems using btrfs-snap:

https://github.com/jf647/btrfs-snap

## Attributes

### Configuration

These attributes are under the `node['btrfs_snap']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
install_dir | Where to install btrfs-snap | String | /opt/btrfs-snap
btrfs_prog | Path to btrfs program | String | /sbin/btrfs
snapshot_basedir | Base directory for snapshots | String | /snapshots
snapshot_basedir_owner | Owner of base directory | String | root
snapshot_basedir_group | Group of base directory | String | root
snapshot_basedir_mode | Mode of base directory | Number | 0755
git_url | URL to clone btrfs-snap from | String | https://github.com/jf647/btrfs-snap.git
git_ref | Git ref to use in btrfs-snap repo | String | master
rootmount | The subvolid=5 mount of the btrfs filesystem | String | /btrfs
enable_periodic_scrub | Whether to perform periodic scrubs of the btrfs filesystem | Boolean | false
periodic_scrub_schedule | The schedule to perform scrubs on | Hash | { 'weekday' => 4, 'minute' => 30, 'hour' => 2 }
snapshots | Snapshots to take | Hash | none (see below)

### Snapshots

This attribute-driven snapshot recipe is rather opinionated about snapshot
schedules.  This provides ease of use at the cost of flexibility.  Pull
requests are welcome for additional schedules or alternate approaches.

There are several named schedules.  Each one corresponds to a period, a
number of generations to keep and where the snapshot is kept:

Schedule Name | Period | Generations to Keep | Location
--------------|--------|---------------------|---------
10_minutes | every minute | 10 | Inside Filesystem
1_hour | every 5 minutes | 12 | Basedir
1_day_fast | every hour at 3 minutes past | 24 | Basedir
1_day_slow | every 3 hours at 6 minutes past | 8 | Basedir
1_week | every day at 00:09 | 7 | Basedir
2_weeks | every day at 00:12 | 14 | Basedir
3_months | every Sunday at 00:15 | 12 | Basedir
6_months | first day of every month at 00:18 | 6 | Basedir
1_year | first day of every 3rd month at 00:21 | 4 | Basedir

Each filesystem that you want snapshots of needs an entry under the `node['btrfs_snap']['snapshots']` namespace:

```json
{
   "btrfs_snap" : {
      "snapshots" : {
         "etc" : {
            "mount" : "/etc",
            "schedule" : [
               "10_minutes",
               "2_weeks"
            ]
         },
         "var" : {
            "mount" : "/var",
            "schedule" : [
               "1_day_slow",
               "1_week"
            ]
         },
         "root" : {
            "mount" : "/",
            "schedule" : [
               "1_day_slow",
               "1_week"
            ]
         },
         "home_james" : {
            "mount" : "/home/james",
            "schedule" : [
               "10_minutes",
               "1_day_slow",
               "2_weeks"
            ]
         }
      }
   }
}
```

Each filesystem can have more than one schedule.  Each schedule is turned into a cronjob.

## Recipes

* `recipe[btrfs_snap::install]` Installs btrfs-snap
* `recipe[btrfs_snap::snapshot]` Makes snapshots based on node attributes
* `recipe[btrfs_snap::scrub]` Performs periodic scrub of btrfs filesystem
* `recipe[btrfs_snap::default]` Combines install, snapshot and scrub

## LWRPs

* `btrfs_snap_snapshot` - Snapshots a btrfs filesystem on one or more schedules

Attribute | Description | Type | Default
----------|-------------|------|--------
mount | Filesystem to snapsot | String |
schedule | Schedules to snapshot at | Array |
readonly | Whether snapshot should be readonly | Boolean | true
basedir | Where to make the snapshot | String | /snapshots

## Usage

### Install btrfs-snap

Add `recipe[btrfs_snap::install]` to your node's run list.

### Take Snapshots based on Attributes

Add `recipe[btrfs_snap::snapshot]` to your node's run list.  Configure one or more snapshots as described above.

### Take a Snapshot

In a recipe:

```ruby
include_recipe 'btrfs'

btrfs_snap_snapshot "name" do
    mount "/etc"
    schedule [ '1_week', '3_months' ]
    readonly false
    basedir "/foo"
end
```

### Perform a Periodic Filesystem Scrub

In order to perform a scrub, you have to have the root of your btrfs
filesystem mounted somewhere.  Typically this is done with a line in fstab
like this:

```
UUID=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX   /btrfs   btrfs   defaults,subvolid=5   0   0
```

Add `recipe[btrfs_snap::scrub]` to your node's run list.  Set
`node['btrfs_snap']['enable_periodic_scrub']` to true and if desired, change
`node['btfs_snap']['periodic_scrub_schedule']` to suit your needs.  If you
mount the root of your btrfs filesystem somewhere other than /btrfs, modify
`node['btrfs_snap']['rootmount']` as needed.

## License

Licensed under the Apache License, Version 2.0 (the "License"); you may not
use this file except in compliance with the License.  You may obtain a copy
of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
License for the specific language governing permissions and limitations
under the License.

## Authors

* Copyright (c) 2013 James FitzGibbon <james@nadt.net>
