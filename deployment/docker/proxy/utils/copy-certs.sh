#!/bin/sh

# Domain
domain=${DOMAIN:-"mqtt.buynowco.ir"}

# Paths to the certificate and key files
cert_file="/tmp/certs/${domain}/${domain}.crt"
key_file="/tmp/certs/${domain}/${domain}.key"

# Path to the destination directory
dest_dir="/tmp/emqx_certs"

# Wait for the certificate and key files to exist
while [ ! -f "$cert_file" ] || [ ! -f "$key_file" ]; do
  echo "Waiting for certificate and key files..."
  sleep 5
done

# Copy the certificate and key files to the destination directory
cp "$cert_file" "$dest_dir/${domain}.crt"
cp "$key_file" "$dest_dir/${domain}.key"

# Change the ownership of the copied files to the emqx user
chown 1000:1000 "$dest_dir/${domain}.crt" "$dest_dir/${domain}.key"

echo "Certificate and key files have been copied to $dest_dir"