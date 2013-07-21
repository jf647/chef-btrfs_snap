actions :create, :delete

default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :mount, :kind_of => String
attribute :schedule, :kind_of => Array #, equal_to => %w(10_minutes 1_hour 1_day_fast 1_day_slow 1_week 2_weeks 3_months 6_months 1_year)
attribute :readonly, :kind_of => [ TrueClass, FalseClass ], :default => true
attribute :basedir, :kind_of => String
