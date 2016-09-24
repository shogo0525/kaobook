server '52.69.160.255', user: 'app', roles: %w{app db web}
set :ssh_options, keys: '/Users/shogo_inamoto/.ssh/id_rsa'