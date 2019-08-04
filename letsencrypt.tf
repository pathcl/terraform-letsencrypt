provider "acme" {
  // this setting is for production api
  // if you want to use staging change it to:
  //
  // https://acme-staging-v02.api.letsencrypt.org/directory
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = "${tls_private_key.private_key.private_key_pem}"
  email_address   = "youremail@domain.tld"
}


resource "acme_certificate" "certificate" {
  account_key_pem           = "${acme_registration.reg.account_key_pem}"
  common_name               = "domain.tld"
  subject_alternative_names = ["alternative.domain.tld"]

  // this is how you prove you own the domain.
  // In this case we're using digitalocean so you need to create a token
  // https://www.digitalocean.com/docs/api/create-personal-access-token/
  // Then you can use a enviroment variable DO_AUTH_TOKEN

  dns_challenge {
    provider = "digitalocean"
  }
}

resource "local_file" "private_key" {
  filename = "server.key"
  content  = "${acme_certificate.certificate.private_key_pem}"
}

resource "local_file" "public_key" {
  filename = "server.pem"
  content  = "${acme_certificate.certificate.certificate_pem}+${acme_certificate.certificate.issuer_pem}"
}
