define teamspeak3 (
  $ensure = present,
  $version = '3.0.7.2',
  $checksum = '0631b1d585ae26605394f582cea70db4',
  $installdir = '/opt'
) {

  $arch = $architecture
  if $arch != 'amd64' {
    $arch = 'x86'
  }
  
  archive { "teamspeak${version}":
    ensure => $ensure,
    digest_string => $checksum,
    url => "http://ftp.4players.de/pub/hosted/ts3/releases/${version}/teamspeak3-server_linux-${arch}-${version}.tar.gz",
    root_dir => "teamspeak3-server_linux-${arch}",
    target => $installdir
  }

  file { '/etc/init.d/teamspeak-server':
    ensure => link,
    target => "$installdir/teamspeak3-server_linux-${arch}/ts3server_startscript.sh",
    require => Archive["teamspeak${version}"]
  }

  service { 'teamspeak-server':
    enable => true,
    ensure => running,
    require => File['/etc/init.d/teamspeak-server']
  }

}
