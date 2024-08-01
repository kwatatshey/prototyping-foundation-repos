aws secretsmanager create-secret \
    --name sshPrivateKey \
    --description "My private key" \
    --secret-string file://private.pem
