variable "cert" {
  type    = string
  default = <<eot
  MIIC5TCCAc2gAwIBAgIQMtWgvn6HoaVGRbBPJguVTzANBgkqhkiG9w0BAQsFADAV
MRMwEQYDVQQDDApXYXRjaFRvd2VyMB4XDTIxMDYwMjEzMTIxNloXDTIyMDYwMjEz
MzIxNlowFTETMBEGA1UEAwwKV2F0Y2hUb3dlcjCCASIwDQYJKoZIhvcNAQEBBQAD
ggEPADCCAQoCggEBAM7dvy29HPFWlKiNC5NX2L9pAfVL9u/D2P8MlAiznSvFRodM
ufin1SiFwu+3Ygkz2gbQSro8d2I/iPOAJexuz5VAUjIQLO5OqZlM6OjHKQKyPvr8
l0Uy94AEjK59wKYVvS+2cw+E+MjhRHW8a2HxluuZJeDnO0pCFJZszSdnEYCBg+J6
cJc/oVHLCzk+8kNX09Pj85X9QbL1u5WKJ4gP4JoZ+wn+vDRicNZlGuvzuPA6J4lN
cJ1c9ozySE9ZyWpRr0cRAuzA8XcrBC0aZmpMpO0t+cK9DgmW+r6GGPAa6ilUeGg6
nO2w/tozEkrtkOxW60GdfJKpGkehz9p642aAKv0CAwEAAaMxMC8wDgYDVR0PAQH/
BAQDAgIEMB0GA1UdDgQWBBTyEM7al2eHYeCZ9VyzrH/A5ELQejANBgkqhkiG9w0B
AQsFAAOCAQEAmNT3UHoFf4hsYzmPvLbplLFQ+nySfMMZ/FBHQ1LRhVRduPAj9r5w
swAax8wARN4TKqGZdZHUXDWOj4XPupnSy/4kZ2O/RuLoe+4Qlpn0/MW6X7E0xB0B
wap9eY0W7OOw4ssMhX8QHG+qWcoueU364+0avgwWjSxoehymDEXeF4hDPeFr/EhP
HHfW1NQTjBM8jOJpZ7SZDsikeoeGvHkgNWAD3BhuVE5jfwxUhQOVt7fY+LLoqls2
FPQQEtzZl1CA1N1ImWnS2xkutBSS5qdjpFQvMkm2ubsSQRUDe3v9ylEFKcsB8iO+
qx+4v0hcaC8emWLkaskeans8S+EpBFevOg==
eot
}

variable "user" {
  type      = string
  default   = "Symbol"
  sensitive = true
}

variable "pass" {
  type      = string
  default   = "Hundred11"
  sensitive = true

}
variable "prefix" {
  type    = string
  default = "WatchTower"
}

variable "location" {
  type    = string
  default = "South Africa North"
}

variable "AD-NET" {
  type    = string
  default = "192.168.0.0/16"
}
variable "FW-Sub" {
  type    = string
  default = "192.168.0.0/26"
}
variable "GW-Sub" {
  type    = string
  default = "192.168.6.0/27"
}
variable "VPN-Pool" {
  type    = string
  default = "172.10.10.0/24"
}
variable "VM-Sub" {
  type    = string
  default = "192.168.10.0/24"
}

variable "VM-IP" {
  type    = string
  default = "192.168.10.10"
}