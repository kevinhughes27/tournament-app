Playbook
========

Renewing SSL certificate
-------------------------

** To obtain a new or tweaked
   version of this certificate in the future, simply run certbot-auto
   again. To non-interactively renew *all* of your certificates, run
   "certbot-auto renew"

1. Download latest `certbot-auto`. If you have an exisiting version it will auto-update itself when executed.

2. Login to Namecheap and get ready to add a TXT record on the Advanced DNS tab for ultimate-tournament

3. Run:

  ```
  sudo ./certbot-auto certonly --server https://acme-v02.api.letsencrypt.org/directory --manual --preferred-challenges dns -d '*.ultimate-tournament.io'
  ```

4. Update the _acme-challenge txt record

5. Run:

  ```
  dig -t txt _acme-challenge.ultimate-tournament.io
  ```

  To confirm the response before continuing

6. Run:

  ```
  sudo heroku certs:update /etc/letsencrypt/live/ultimate-tournament.io/fullchain.pem /etc/letsencrypt/live/ultimate-tournament.io/privkey.pem --app ultimate-tournament
  ```

  To upload the new certificate to Heroku
