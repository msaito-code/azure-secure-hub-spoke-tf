# 13. Generate Root CA Private Key
resource "tls_private_key" "vpn_root_key" {
	algorithm	= "RSA"
	rsa_bits	= 2048
}

# 14. Generate Self-Signed Root Certificate
resource "tls_self_signed_cert" "vpn_root_cert" {
	private_key_pem = tls_private_key.vpn_root_key.private_key_pem

	subject {
		common_name 	= "PortfolioP2SRootCA"
		organization	= "Portfolio Security"
	}

	validity_period_hours = 87600

	allowed_uses = [
		"cert_signing",
		"crl_signing",
	]
}

# 3. Format the public certificate data for Azure Gateway
# (Azure requires base64 string WITHOUT PEM headers for headers or new lines)
locals {
	vpn_root_cert_base64 = replace(
		replace(
			replace(tls_self_signed_cert.vpn_root_cert.cert_pem, "-----BEGIN CERTIFICATE-----", ""),
			"-----END CERTIFICATE-----", ""
		),
		"\n", ""
	)
}
