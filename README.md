Installation:

1. Place hyperboria.sh in `/etc/init.d/hyperboria`
2. `chmod +x /etc/init.d/hyperboria`
3. `update-rc.d hyperboria defaults`

This will cause it to automatically start with your computer. You can control it with `/etc/init.d/hyperboria <start|stop|restart|upgrade>`. Some systems (Ubuntu, not sure about others) allow you to use the `service` command, which shortens the command to `service hyperboria <start|stop|restart|upgrade`. Message thefinn93 on EFNet if you have issues