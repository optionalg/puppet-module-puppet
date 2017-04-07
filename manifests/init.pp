# vim: tabstop=2 expandtab shiftwidth=2 softtabstop=2 foldmethod=marker smartindent
#
# == Class: puppet::init
#
# Configures Puppet agent and Puppet master
#
class puppet (

  $agent           = getvar('::puppet::params::agent::agent'),
  $agentpkg        = getvar('::puppet::params::agent::pkg'),
  $agentsvcenable  = getvar('::puppet::params::agent::svcenable'),
  $agentsvcensure  = getvar('::puppet::params::agent::svcensure'),
  $agentsvcname    = getvar('::puppet::params::agent::svcname'),
  $hieramerge      = getvar('::puppet::params::agent::hieramerge'),
  $main            = getvar('::puppet::params::agent::main'),
  $master          = getvar('::puppet::params::master::master'),
  $mastersvcenable = getvar('::puppet::params::master::svcenable'),
  $mastersvcensure = getvar('::puppet::params::master::svcensure'),
  $mastersvcname   = getvar('::puppet::params::master::svcname'),
  $masterpkg       = getvar('::puppet::params::master::pkg'),
  $version         = getvar('::puppet::params::master::version'),
  $passenger       = getvar('::puppet::params::master::passenger')

) inherits puppet::params {
  validate_hash             ( $agent            )
  validate_string           ( $agentpkg         )
  validate_bool             ( $agentsvcenable   )
  validate_string           ( $agentsvcname     )
  validate_bool             ( $agentsvcensure   )
  validate_bool             ( $hieramerge       )
  validate_string           ( $version          )

  if $::instance_role == 'puppet' {
    validate_string         ( $masterpkg        )
    validate_bool           ( $mastersvcenable  )
    validate_string         ( $mastersvcname    )
    validate_bool           ( $mastersvcensure  )
  }

  # Merge config hashes
  $x_agent  = deep_merge($agent, hiera_hash('puppet::agent::params', {}))
  $x_main   = deep_merge($main, hiera_hash('puppet::main::params', {}))
  if $::instance_role == 'puppet' {
    $x_master = deep_merge($master, hiera_hash('puppet::master::params', {}))
  }

  # # [agent] section parameters
  # validate_bool           ( $x_agent["autoflush"]        )
  # validate_string         ( $x_agent["certname"]         )
  # validate_integer        ( $x_agent["configtimeout"]    )
  # validate_string         ( $x_agent["disable_warnings"] )
  # validate_string         ( $x_agent["environment"]      )
  # validate_bool           ( $x_agent["listen"]           )
  # validate_bool           ( $x_agent["pluginsync"]       )
  # validate_string         ( $x_agent["server"]           )
  # validate_bool           ( $x_agent["splay"]            )

  # # [main] section parameters
  # validate_string         ( $x_main["disable_warnings"]  )
  # validate_absolute_path  ( $x_main["logdir"]            )
  # validate_absolute_path  ( $x_main["rundir"]            )
  # validate_string         ( $x_main["ssldir"]            )

  class { '::puppet::agent::install': }
  -> class { '::puppet::agent::config':  }
  ~> class { '::puppet::agent::service': }

  contain 'puppet::agent::install'
  contain 'puppet::agent::config'
  contain 'puppet::agent::service'

  unless $x_master == undef {
    validate_bool           ( $x_master["autosign"]                  )
    validate_string         ( $x_master["certname"]                  )
    validate_string         ( $x_master["dns_alt_names"]             )
    validate_string         ( $x_master["environment"]               )
    validate_integer        ( $x_master["filetimeout"]               )
    validate_string         ( $x_master["manifest"]                  )
    validate_string         ( $x_master["modulepath"]                )
    validate_bool           ( $x_master["pluginsync"]                )
    validate_string         ( $x_master["ssl_client_header"]         )
    validate_string         ( $x_master["ssl_client_verify_header"]  )

    class { '::puppet::master::install': }
    -> class { '::puppet::master::config':  }
    ~> class { '::puppet::master::service': }

    contain 'puppet::master::install'
    contain 'puppet::master::config'
    contain 'puppet::master::service'
    contain 'puppet::master::r10k'
    contain 'puppet::master::hiera'

    if $passenger {
      contain 'puppet::master::passenger'
    }
  }
}
