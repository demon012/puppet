class profile::sensuserver {
    class { 'sensu':
        rabbitmq_password         => 'correct-horse-battery-staple',
                          server  => true,
                          api     => true,
                          plugins => [
                              'puppet:///data/sensu/plugins/ntp.rb',
                              'puppet:///data/sensu/plugins/postfix.rb'
                          ]
    }

    sensu::handler { 'default':
        command => 'mail -s \'Sensu Alert\' alan.james.jenkins@gmail.com',
    }

    sensu::check { 'check_ntp':
        command     => 'PATH=$PATH:/usr/lib/nagios/plugins check_ntp_time -H pool.ntp.org -w 30 -c 60',
        handlers    => 'default',
        subscribers => 'sensu-test'
    }
}
