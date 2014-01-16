class riak::join (

  $host = hiera('join_host', ''),

) inherits riak::params {

  exec { "join $host":
    path => '/usr/bin:/usr/sbin:/bin:/sbin',
    command => "riak ping && riak-admin cluster join riak@$host && riak-admin cluster plan && riak-admin cluster commit",
    onlyif => [ "riak-admin ringready|grep -v $host",
	        "test $host != $::ipaddress"],
                
    unless => "expr `riak-admin member_status| grep 'riak@'|awk '{print $4}' |wc -l` > 1"
  }

}
