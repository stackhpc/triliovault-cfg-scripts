class trilio::contego (
    $backup_target_type                   = 'nfs',
    $nfs_shares                           = undef,
    $nfs_options                          = 'nolock,soft,timeo=180,intr',
    $s3_type                              = 'amazon_s3',
    $s3_accesskey                         = undef,
    $s3_secretkey                         = undef,
    $s3_region_name                       = undef,
    $s3_bucket                            = undef,
    $s3_endpoint_url                      = undef,
    $s3_signature_version                 = 'default',
    $s3_auth_version                      = 'DEFAULT',
    $s3_ssl_enabled                       = 'False',
    $s3_ssl_cert                          = undef,
    $database_connection                  = undef,
    $oslomsg_rpc_proto                    = hiera('messaging_rpc_service_name', 'rabbit'),
    $oslomsg_rpc_hosts                    = any2array(hiera('rabbitmq_node_names', undef)),
    $oslomsg_rpc_password                 = hiera('trilio::rabbit_password'),
    $oslomsg_rpc_port                     = hiera('trilio::rabbit_port', '5672'),
    $oslomsg_rpc_username                 = hiera('trilio::rabbit_userid', 'guest'),
    $oslomsg_rpc_use_ssl                  = hiera('trilio::rabbit_use_ssl', '0'),
    $cinder_backend_ceph                  = false,
    $ceph_cinder_user                     = 'openstack',
    $multi_ip_nfs_enabled                 = false,
    $datamover_node_name                  = hiera('tvault-contego_short_bootstrap_node_name'),
    $nfs_map                              = {},
) {


    $contego_user                         = 'nova'
    $contego_group                        = 'nova'
    $contego_conf_file                    = "/etc/tvault-contego/tvault-contego.conf"
    $contego_groups                       = ['kvm','qemu','disk']
    $vault_data_dir                       = "/var/lib/nova/triliovault-mounts"
    $vault_data_dir_old                   = "/var/triliovault"
    $contego_dir                          = "/home/tvault"
    $contego_virtenv_dir                  = "${contego_dir}/.virtenv"
    $log_dir                              = "/var/log/nova"
    $contego_bin                          = "${contego_virtenv_dir}/bin/tvault-contego"
    $contego_python                       = "${contego_virtenv_dir}/bin/python"
    $config_files                         = "--config-file=${nova_dist_conf_file} --config-file=${nova_conf_file} --config-file=${contego_conf_file}"

  
    if $redhat_openstack_version == '9' {
           $openstack_release = 'mitaka'
    }
    elsif $redhat_openstack_version == '10' {
           $openstack_release = 'newton'
    }
    else {
           $openstack_release = 'premitaka'
    }


##Set object_store_ext

    if $backup_target_type == 's3' {
        $contego_ext_object_store = "${contego_virtenv_dir}/lib/python2.7/site-packages/contego/nova/extension/driver/s3vaultfuse.py"

    }

    class {'trilio::contego::config': }

}
