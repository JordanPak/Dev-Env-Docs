# Misc Tips

## See disk/directory usage
```
sudo apt install ncdu
```

Usage:
```
cd /
ncdu
```


## Clean up `/var/log/journal`

https://www.sitelint.com/blog/how-do-i-clear-a-big-var-log-journal-folder

```
sudo journalctl --vacuum-size=100M
```

To change maximum journal size:
1. `vim /etc/systemd/journald.conf`
2. Set `SystemMaxUse` to something more reasonable like `50M` or `100M`
3. Restart the service with `sudo systemctl restart systemd-journald.service`
