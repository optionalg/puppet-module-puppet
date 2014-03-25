# puppet-module-puppet

Manages a Puppet Agent

## Requirements
---

- Puppet version 3 or greater with Hiera support
- Puppet Modules:

| OS Family      | Module |
| :------------- |:-------------: |
| ALL            | [clabs/core](https://bitbucket.org/convectionlabs/puppet-module-core)|
| ALL            | [puppetlabs/inifile](https://forge.puppetlabs.com/puppetlabs/stdlib) |
| ALL            | [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/inifile) |

## Usage
---

Loading the puppet class:

```puppet
include puppet
```

## Configuration
---

Configuration settings should be set via Hiera

### Default settings (Linux)

```yaml
puppet::enabled     : true
puppet::user        : 'puppet'
puppet::group       : 'puppet'
puppet::configfile  : '/etc/puppet/puppet.conf'
puppet::packages    :
    - 'puppet'
puppet::settings    :
    'listen'        : false
    'pluginsync'    : true
    'autoflush'     : true
    'environment'   : %{::environment}
    'certname'      : %{::fqdn}
    'server'        : %{::servername}
    'modulepath'    : '/etc/puppet/modules:/usr/share/puppet/modules'
```

### Default settings (Windows)

Same as Linux except for:
    - configuration file location
    - local module directory locations

```yaml
puppet::configfile  : '/ProgramData/PuppetLabs/puppet/etc/puppet.conf'
puppet::settings    :
    'modulepath': 'C:/ProgramData/PuppetLabs/puppet/etc/modules;C:/usr/share/puppet/modules',
```

## See Also

* [Configuring Puppet](http://docs.puppetlabs.com/guides/configuring.html)
