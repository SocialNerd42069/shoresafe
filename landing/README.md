# ShoreSafe landing page

This folder contains a static landing page built with Vite, React, and Tailwind CSS.

## Local build

1. Install packages:
   ```bash
   npm install
   ```
2. Build a production bundle:
   ```bash
   npm run build
   ```
3. Preview the build (optional):
   ```bash
   npm run preview -- --host
   ```

The production output is in `landing/dist`.

## Deploy behind Caddy (safe append only)

The goal is to serve `landing/dist` on a new hostname like `shoresafe.<VPS>.sslip.io`.

1. On your server, create a folder for the site:
   ```bash
   sudo mkdir -p /var/www/shoresafe
   ```
2. Copy the build output to the server:
   ```bash
   rsync -av --delete landing/dist/ user@your-vps:/var/www/shoresafe/
   ```
   If you do not use `rsync`, you can use `scp -r landing/dist/* user@your-vps:/var/www/shoresafe/`.

3. Update your Caddyfile.

   Important: append or merge this block into your existing Caddyfile. Do not overwrite your current file.

   ```caddyfile
   shoresafe.<VPS>.sslip.io {
     root * /var/www/shoresafe
     encode zstd gzip

     @assets {
       path /assets/*
     }
     header @assets Cache-Control "public, max-age=31536000, immutable"

     file_server
   }
   ```

   Replace `<VPS>` with your server IP in dashed form. Example: `shoresafe.203-0-113-10.sslip.io`.

4. Reload Caddy safely:
   ```bash
   sudo caddy reload --config /etc/caddy/Caddyfile
   ```

Caddy will handle HTTPS for the new hostname.
