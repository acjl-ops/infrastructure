{ config, lib, pkgs, inputs, ...}:
  with lib;
{
  imports = [
    ./../../modules/nixos/hardware/cpu/amd-zen3.nix
    ./../../modules/nixos/hardware/gpu/amd.nix

    ./../../modules/nixos/hardware/efi/nonesp.nix

    ./../../modules/nixos/hardware/boot/luks.nix
    ./../../modules/nixos/hardware/boot/btrfs.nix
    ./../../modules/nixos/hardware/boot/swap.nix

    ./../../modules/nixos/hardware/io/ssd-nvme.nix
    ./../../modules/nixos/hardware/virtualization.nix

    ./../../modules/nixos/unfree.nix

    ./../../profiles/nixos/laptop.nix
    ./../../profiles/nixos/personal.nix

    ./../../profiles/sanix/laptop.nix
  ];

  nix.settings.system-features = [ "nixos-test" "benchmark" "big-parallel" ];

  boot.kernelParams = [
    # Force use of the thinkpad_acpi driver for backlight control.
    # This allows the backlight save/load systemd service to work.
    "acpi_backlight=native"

    # With BIOS version 1.12 and the IOMMU enabled, the amdgpu driver
    # either crashes or is not able to attach to the GPU depending on
    # the kernel version. I've seen no issues with the IOMMU disabled.
    #
    # BIOS version 1.13 fixes the IOMMU issues, but we leave the IOMMU
    # in software mode to avoid a sad experience for those people that drew
    # the short straw when they bought their laptop.
    #
    # Do not set iommu=off, because this will cause the SD-Card reader
    # driver to kernel panic.
    # "iommu=soft"
  ];

  services.kubo = {
    enable = true;
    enableGC = true;
    localDiscovery = true;
    settings = {
      Addresses.Gateway = [
        "/ip4/127.0.0.1/tcp/8080"
        "/ip6/::1/tcp/8080"
      ];
      Addresses.API = [
        "/ip4/127.0.0.1/tcp/5001"
        "/ip6/::1/tcp/5001"
      ];
      AutoNAT.ServiceMode = "enabled";
      Discovery.MDNS.Enabled = true;
    };
  };

  services.chrony = {
    enable = true;
    initstepslew.enabled = false;

    servers = mkForce [];

    extraConfig = ''
# minsamples 5
# minsources 2
# combinelimit 10

# authselectmode prefer

# Local clients / servers

# Loopback (trusted)
# peer 127.0.0.1 burst iburst trust prefer extfield F323
# peer ::1       burst iburst trust prefer extfield F323

# Local LAN (maybe not trusted, but preferable)
# server ntp.lan   burst iburst prefer extfield F323 presend 9
# server ntp.local burst iburst prefer extfield F323 presend 9

# Always prefer the main pool
pool pool.ntp.org prefer iburst maxsources 16 xleave extfield F323

# increase maxsources as this pool is very big
pool 0.pool.ntp.org prefer iburst maxsources 16 xleave extfield F323
pool 1.pool.ntp.org prefer iburst maxsources 16 xleave extfield F323
pool 2.pool.ntp.org prefer iburst maxsources 16 xleave extfield F323
pool 3.pool.ntp.org prefer iburst maxsources 16 xleave extfield F323

# initstepslew 1000 0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org

# Big companies alternative pools

## Cloudflare pool (known to support NTS, therefore trusted)
pool time.cloudflare.com prefer iburst maxsources 16 xleave extfield F323

## Google pool
pool time.google.com    prefer iburst maxsources 16 xleave extfield F323

server time1.google.com prefer iburst
server time2.google.com prefer iburst
server time3.google.com prefer iburst
server time4.google.com prefer iburst

# Facebook pool
pool time.facebook.com    prefer iburst maxsources 16 xleave extfield F323

server time1.facebook.com prefer iburst
server time2.facebook.com prefer iburst
server time3.facebook.com prefer iburst
server time4.facebook.com prefer iburst
server time5.facebook.com prefer iburst

# Apple pool (unknown to be accurate)
pool time.apple.com      iburst maxsources 16 xleave extfield F323
pool time.euro.apple.com iburst maxsources 16 xleave extfield F323

server time1.apple.com iburst
server time2.apple.com iburst
server time3.apple.com iburst
server time4.apple.com iburst
server time5.apple.com iburst
server time6.apple.com iburst
server time7.apple.com iburst

# Microsoft Windows pool (not recommended, known to be bad)

pool time.windows.com iburst maxsources 16 xleave extfield F323

# Alternative community pools

## pool.ntp.org

pool europe.pool.ntp.org iburst maxsources 16 xleave extfield F323

pool 0.europe.pool.ntp.org iburst maxsources 16
pool 1.europe.pool.ntp.org iburst maxsources 16
pool 2.europe.pool.ntp.org iburst maxsources 16
pool 3.europe.pool.ntp.org iburst maxsources 16

pool pt.pool.ntp.org iburst maxsources 16 xleave extfield F323

pool 0.pt.pool.ntp.org iburst maxsources 16
pool 1.pt.pool.ntp.org iburst maxsources 16
pool 2.pt.pool.ntp.org iburst maxsources 16
pool 3.pt.pool.ntp.org iburst maxsources 16

pool 0.openwrt.pool.ntp.org iburst
pool 1.openwrt.pool.ntp.org iburst
pool 2.openwrt.pool.ntp.org iburst
pool 3.openwrt.pool.ntp.org iburst

pool 0.ubnt.pool.ntp.org iburst
pool 1.ubnt.pool.ntp.org iburst
pool 2.ubnt.pool.ntp.org iburst
pool 3.ubnt.pool.ntp.org iburst

pool asia.pool.ntp.org iburst

pool 0.asia.pool.ntp.org iburst
pool 1.asia.pool.ntp.org iburst
pool 2.asia.pool.ntp.org iburst
pool 3.asia.pool.ntp.org iburst

pool ru.pool.ntp.org iburst

pool 0.ru.pool.ntp.org iburst
pool 1.ru.pool.ntp.org iburst
pool 2.ru.pool.ntp.org iburst
pool 3.ru.pool.ntp.org iburst

pool north-america.pool.ntp.org iburst

pool 0.north-america.pool.ntp.org iburst
pool 1.north-america.pool.ntp.org iburst
pool 2.north-america.pool.ntp.org iburst
pool 3.north-america.pool.ntp.org iburst

pool 0.gentoo.pool.ntp.org iburst
pool 1.gentoo.pool.ntp.org iburst
pool 2.gentoo.pool.ntp.org iburst
pool 3.gentoo.pool.ntp.org iburst

pool 0.arch.pool.ntp.org iburst
pool 1.arch.pool.ntp.org iburst
pool 2.arch.pool.ntp.org iburst
pool 3.arch.pool.ntp.org iburst

pool 0.fedora.pool.ntp.org iburst
pool 1.fedora.pool.ntp.org iburst
pool 2.fedora.pool.ntp.org iburst
pool 3.fedora.pool.ntp.org iburst

pool 0.opensuse.pool.ntp.org iburst
pool 1.opensuse.pool.ntp.org iburst
pool 2.opensuse.pool.ntp.org iburst
pool 3.opensuse.pool.ntp.org iburst

pool 0.centos.pool.ntp.org iburst
pool 1.centos.pool.ntp.org iburst
pool 2.centos.pool.ntp.org iburst
pool 3.centos.pool.ntp.org iburst

pool 0.debian.pool.ntp.org iburst
pool 1.debian.pool.ntp.org iburst
pool 2.debian.pool.ntp.org iburst
pool 3.debian.pool.ntp.org iburst

pool 0.askozia.pool.ntp.org iburst
pool 1.askozia.pool.ntp.org iburst
pool 2.askozia.pool.ntp.org iburst
pool 3.askozia.pool.ntp.org iburst

pool 0.freebsd.pool.ntp.org iburst
pool 1.freebsd.pool.ntp.org iburst
pool 2.freebsd.pool.ntp.org iburst
pool 3.freebsd.pool.ntp.org iburst

pool 0.netbsd.pool.ntp.org iburst
pool 1.netbsd.pool.ntp.org iburst
pool 2.netbsd.pool.ntp.org iburst
pool 3.netbsd.pool.ntp.org iburst

pool 0.openbsd.pool.ntp.org iburst
pool 1.openbsd.pool.ntp.org iburst
pool 2.openbsd.pool.ntp.org iburst
pool 3.openbsd.pool.ntp.org iburst

pool 0.dragonfly.pool.ntp.org iburst
pool 1.dragonfly.pool.ntp.org iburst
pool 2.dragonfly.pool.ntp.org iburst
pool 3.dragonfly.pool.ntp.org iburst

pool 0.pfsense.pool.ntp.org iburst
pool 1.pfsense.pool.ntp.org iburst
pool 2.pfsense.pool.ntp.org iburst
pool 3.pfsense.pool.ntp.org iburst

pool 0.opnsense.pool.ntp.org iburst
pool 1.opnsense.pool.ntp.org iburst
pool 2.opnsense.pool.ntp.org iburst
pool 3.opnsense.pool.ntp.org iburst

pool 0.smartos.pool.ntp.org iburst
pool 1.smartos.pool.ntp.org iburst
pool 2.smartos.pool.ntp.org iburst
pool 3.smartos.pool.ntp.org iburst

pool 0.android.pool.ntp.org iburst
pool 1.android.pool.ntp.org iburst
pool 2.android.pool.ntp.org iburst
pool 3.android.pool.ntp.org iburst

pool 0.amazon.pool.ntp.org iburst
pool 1.amazon.pool.ntp.org iburst
pool 2.amazon.pool.ntp.org iburst
pool 3.amazon.pool.ntp.org iburst

## Other pools

server usno.labs.hp.com iburst
server clepsydra.hpl.hp.com iburst
server clepsydra.labs.hp.com iburst
server clepsydra.dec.com iburst

server time-a-g.nist.gov iburst
server time-b-g.nist.gov iburst
server time-c-g.nist.gov iburst
server time-d-g.nist.gov iburst
server time-a-wwv.nist.gov iburst
server time-b-wwv.nist.gov iburst
server time-c-wwv.nist.gov iburst
server time-d-wwv.nist.gov iburst
server time-a-b.nist.gov iburst
server time-b-b.nist.gov iburst
server time-c-b.nist.gov iburst
server time-d-b.nist.gov iburst
server time.nist.gov iburst
server time-e-b.nist.gov iburst
server time-e-g.nist.gov iburst
server time-e-wwv.nist.gov iburst

server utcnist.colorado.edu iburst
server utcnist2.colorado.edu iburst

server ntp1.vniiftri.ru iburst
server ntp2.vniiftri.ru iburst
server ntp3.vniiftri.ru iburst
server ntp4.vniiftri.ru iburst
server ntp.sstf.nsk.ru iburst
server ntp1.niiftri.irkutsk.ru iburst
server ntp2.niiftri.irkutsk.ru iburst
server vniiftri.khv.ru iburst
server vniiftri2.khv.ru iburst
server ntp21.vniiftri.ru iburst
server ntp.mobatime.ru iburst

server ntp0.ntp-servers.net iburst
server ntp1.ntp-servers.net iburst
server ntp2.ntp-servers.net iburst
server ntp3.ntp-servers.net iburst
server ntp4.ntp-servers.net iburst
server ntp5.ntp-servers.net iburst
server ntp6.ntp-servers.net iburst
server ntp7.ntp-servers.net iburst

server ntp1.stratum1.ru iburst
server ntp2.stratum1.ru iburst
server ntp3.stratum1.ru iburst
server ntp4.stratum1.ru iburst
server ntp5.stratum1.ru iburst

server ntp1.stratum2.ru iburst
server ntp2.stratum2.ru iburst
server ntp3.stratum2.ru iburst
server ntp4.stratum2.ru iburst
server ntp5.stratum2.ru iburst

server stratum1.net iburst

server ntp.time.in.ua iburst
server ntp2.time.in.ua iburst
server ntp3.time.in.ua iburst

server ntp.ru iburst
server ts1.aco.net iburst
server ts2.aco.net iburst
server ntp1.net.berkeley.edu iburst
server ntp2.net.berkeley.edu iburst
server ntp.gsu.edu iburst
server tick.usask.ca iburst
server tock.usask.ca iburst
server ntp.nsu.ru iburst
server ntp.psn.ru iburst
server ntp.rsu.edu.ru iburst
server ntp.nict.jp iburst
server x.ns.gin.ntt.net iburst
server y.ns.gin.ntt.net iburst
server clock.nyc.he.net iburst
server clock.sjc.he.net iburst
server ntp.fiord.ru iburst
server gbg1.ntp.se iburst
server gbg2.ntp.se iburst
server mmo1.ntp.se iburst
server mmo2.ntp.se iburst
server sth1.ntp.se iburst
server sth2.ntp.se iburst
server svl1.ntp.se iburst
server svl2.ntp.se iburst
server ntp.se iburst
server ntp.qix.ca iburst
server ntp1.qix.ca iburst
server ntp2.qix.ca iburst
server ntp.yycix.ca iburst
server ntp.ix.ru iburst
server ntp1.hetzner.de iburst
server ntp2.hetzner.de iburst
server ntp3.hetzner.de iburst
server time-a.as43289.net iburst
server time-b.as43289.net iburst
server time-c.as43289.net iburst
server ntp.ripe.net iburst
server clock.isc.org iburst
server ntp.isc.org iburst
server ntp.time.nl iburst
server ntp1.time.nl iburst
server ntp0.as34288.net iburst
server ntp1.as34288.net iburst
server ntp1.jst.mfeed.ad.jp iburst
server ntp2.jst.mfeed.ad.jp iburst
server ntp3.jst.mfeed.ad.jp iburst
server ntp.ntsc.ac.cn iburst
server ntp.nat.ms iburst
server tick.usno.navy.mil iburst
server tock.usno.navy.mil iburst
server ntp2.usno.navy.mil iburst
server utcnist.colorado.edu iburst
server utcnist2.colorado.edu iburst
server timekeeper.isi.edu iburst
server rackety.udel.edu iburst
server mizbeaver.udel.edu iburst
server otc1.psu.edu iburst
server gnomon.cc.columbia.edu iburst
server navobs1.gatech.edu iburst
server navobs1.wustl.edu iburst
server now.okstate.edu iburst
server ntp.colby.edu iburst
server ntp-s1.cise.ufl.edu iburst
server bonehed.lcs.mit.edu iburst
server level1e.cs.unc.edu iburst
server tick.ucla.edu iburst
server tick.uh.edu iburst
server ntpstm.netbone-digital.com iburst
server nist1.symmetricom.com iburst
server ntp.quintex.com iburst
server ntp1.conectiv.com iburst
server tock.usshc.com iburst
server t2.timegps.net iburst
server gps.layer42.net iburst
server ntp-ca.stygium.net iburst
server sesku.planeacion.net iburst
server ntp0.nl.uu.net iburst
server ntp1.nl.uu.net iburst
server navobs1.oar.net iburst
server ntp-galway.hea.net iburst
server ntp1.ona.org iburst
server ntp.your.org iburst
server ntp.mrow.org iburst
server time.fu-berlin.de iburst
server ntps1-0.cs.tu-berlin.de iburst
server ntps1-1.cs.tu-berlin.de iburst
server ntps1-0.uni-erlangen.de iburst
server ntps1-1.uni-erlangen.de iburst
server ntp1.fau.de iburst
server ntp2.fau.de iburst
server ntp.dianacht.de iburst
server zeit.fu-berlin.de iburst
server ptbtime1.ptb.de iburst
server ptbtime2.ptb.de iburst
server rustime01.rus.uni-stuttgart.de iburst
server rustime02.rus.uni-stuttgart.de iburst
server chime1.surfnet.nl iburst
server ntp.vsl.nl iburst
server asynchronos.iiss.at iburst
server ntp.nic.cz iburst
server time.ufe.cz iburst
server ntp.fizyka.umk.pl iburst
server tempus1.gum.gov.pl iburst
server tempus2.gum.gov.pl iburst
server ntp1.usv.ro iburst
server ntp3.usv.ro iburst
server timehost.lysator.liu.se iburst
server time1.stupi.se iburst
server time.nrc.ca iburst
server clock.uregina.ca iburst
server cronos.cenam.mx iburst
server ntp.lcf.mx iburst
server hora.roa.es iburst
server minuto.roa.es iburst
server ntp1.inrim.it iburst
server ntp2.inrim.it iburst
server ntp1.oma.be iburst
server ntp2.oma.be iburst
server ntp.atomki.mta.hu iburst
server ntp.i2t.ehu.eus iburst
server ntp.neel.ch iburst
server ntp.neu.edu.cn iburst
server ntp.nict.jp iburst
server ntps1.pads.ufrj.br iburst
server ntp.shoa.cl iburst
server time.esa.int iburst
server time1.esa.int iburst
    '';

  };
}
