let
  # pub key for users used for encryption
  # from github.com/smolpatches.keys
  # from .ssh/id_e25519.pub
  users = [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGfTzzkTvt0wOIZNPj/x3kGkmp7A6TSCZDmFneFO7g+x watashi@nixos"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM59Abp8bYdeNRWE0tzOVFzabSjTrj58/VinSk+vMcie"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILSrPtRlo9Op6+rAKMy23vurrgmKHwucEr4kiLevt87u"
  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdAoaWMVkzCBalha316LIn9nHMEnSjEL4e56aRS6hJJS7gSD4+KJo6N/kLRDpEDfVsQY+ixuxyxi6aiLt4GUhr0dbPRJS9FAq28ca2/uaAyKSp4dK3dE/fT6w6aJrWmnfL1/t2cGQUHisIYWMNJP/aDBuK2KzhWwYjzkw+ezZ0BRjbvXVh3/vLCgKmRHoOmJukNYOqWc4pbCwAUV0JVheevPpICIGHNKRKqhYBdH2/uycHyyXNFNPdYPJ+PZvzPQBmcEhEC3uMXLFY2dALG1Nw9B/t96KMuyDrVnVmiUQt7W7gkHRBkbt0YuCCQDzgRKUrT5xlxmvXJTvmF6fJUDAz"
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGp/Mh0lTFHuXPWRVlhxJllW9Wo2bDYGxG/KQ80olu2y"
  ];
  # key for the actual system
  # from /etc/ssh/ ssh-ed25519 pub key
 systems = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMw76fx3baf2vr3hhjRhKy+DJmTcbB+YOuPwyTmd4PNO root@nixos" ];
in {
  "secret1.age".publicKeys = users ++ systems;
}
