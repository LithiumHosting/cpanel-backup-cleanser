# cPanel Backup Cleanser
Sometimes a cPanel import fails, in that case, support may ask for a sanitized backup file.
The process of digging through a backup and removing customer info can be daunting, this quick script automates it.

Simply clone the repo to your ApisCP server and run the script against the backup that fails to import.
The original backup file will be preserved.
## Usage
```bash
git clone https://github.com/LithiumHosting/cpanel-backup-cleanser.git /root/cleanser
chmod +x /root/cleanser/cleanse.sh /root/cleanser/parser.php

/root/cleanser/cleanse.sh /path/to/cpbackup.tar.gz
```
Once it completes, if there's no errors, it will give you the path to the sanitized backup file in /var/www/html/user_sanitized.tar.gz
Simply take that file name, append it to your server hostname and share it with ApisCP Support!

## Contributing

Submit a PR and have fun!