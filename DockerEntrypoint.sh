#!/bin/sh

# Start fail2ban with the easyxray-ipl jail
if [ "$EASYXRAY_ENABLE_FAIL2BAN" = "true" ]; then
    LOG_FOLDER="${EASYXRAY_LOG_FOLDER:-/var/log/easyxray}"
    mkdir -p "$LOG_FOLDER"

    # A container keeps its writable layer across `docker restart`, so the pre-rename
    # jail written by an earlier image survives there. Left alone it would come back
    # pointing at a log nothing writes, and its chain would be rebuilt for good.
    rm -f /etc/fail2ban/jail.d/3x-ipl.conf /etc/fail2ban/jail.d/3x-ipl-backend.conf \
        /etc/fail2ban/filter.d/3x-ipl.conf /etc/fail2ban/action.d/3x-ipl.conf
    # The chain lives in the host netns (--network=host) and outlives a daemon that
    # died without running its actionstop, so drop it here rather than never.
    if iptables -n -L f2b-3x-ipl > /dev/null 2>&1; then
        iptables -D INPUT -j f2b-3x-ipl 2> /dev/null
        iptables -F f2b-3x-ipl 2> /dev/null
        iptables -X f2b-3x-ipl 2> /dev/null
    fi
    for old_log in 3xipl.log 3xipl-banned.log 3xipl-banned.prev.log; do
        new_log=$(echo "$old_log" | sed 's/^3xipl/easyxray-ipl/')
        if [ -f "$LOG_FOLDER/$old_log" ] && [ ! -e "$LOG_FOLDER/$new_log" ]; then
            mv "$LOG_FOLDER/$old_log" "$LOG_FOLDER/$new_log"
        fi
    done

    touch "$LOG_FOLDER/easyxray-ipl.log" "$LOG_FOLDER/easyxray-ipl-banned.log"

    mkdir -p /etc/fail2ban/jail.d /etc/fail2ban/filter.d /etc/fail2ban/action.d

    cat > /etc/fail2ban/jail.d/easyxray-ipl.conf << EOF
[easyxray-ipl]
enabled=true
backend=auto
filter=easyxray-ipl
action=easyxray-ipl
logpath=$LOG_FOLDER/easyxray-ipl.log
maxretry=1
findtime=32
bantime=30m
EOF

    cat > /etc/fail2ban/filter.d/easyxray-ipl.conf << 'EOF'
[Definition]
datepattern = ^%%Y/%%m/%%d %%H:%%M:%%S
failregex   = \[LIMIT_IP\]\s*Email\s*=\s*<F-USER>.+</F-USER>\s*\|\|\s*Disconnecting OLD IP\s*=\s*<ADDR>\s*\|\|\s*Timestamp\s*=\s*\d+
ignoreregex =
EOF

    # Ports to exempt from the ban so an over-limit proxy client can never lock
    # the administrator out of SSH or the panel. The ban still covers every other
    # TCP port (including all Xray inbounds), so IP-limit keeps working for inbounds
    # added later without regenerating these files.
    SSH_PORTS=$(grep -oE '^[[:space:]]*Port[[:space:]]+[0-9]+' /etc/ssh/sshd_config 2>/dev/null | grep -oE '[0-9]+' | paste -sd, -)
    [ -z "$SSH_PORTS" ] && SSH_PORTS="22"
    PANEL_PORT=$(/app/easyxray setting -show true 2>/dev/null | grep -Eo 'port: .+' | awk '{print $2}')
    EXEMPT_PORTS="$SSH_PORTS"
    [ -n "$PANEL_PORT" ] && EXEMPT_PORTS="$EXEMPT_PORTS,$PANEL_PORT"

    cat > /etc/fail2ban/action.d/easyxray-ipl.conf << EOF
[INCLUDES]
before = iptables-allports.conf

[Definition]
actionstart = <iptables> -N f2b-<name>
              <iptables> -A f2b-<name> -j <returntype>
              <iptables> -I <chain> -j f2b-<name>

actionstop = <iptables> -D <chain> -j f2b-<name>
             <actionflush>
             <iptables> -X f2b-<name>

actioncheck = <iptables> -n -L <chain> | grep -q 'f2b-<name>[ \t]'

actionban = <iptables> -I f2b-<name> 1 -s <ip> -p tcp -m multiport ! --dports <exemptports> -j <blocktype>
            <iptables> -I f2b-<name> 1 -s <ip> -p udp -m multiport ! --dports <exemptports> -j <blocktype>
            echo "\$(date +"%%Y/%%m/%%d %%H:%%M:%%S")   BAN   [Email] = <F-USER> [IP] = <ip> banned for <bantime> seconds." >> $LOG_FOLDER/easyxray-ipl-banned.log

actionunban = <iptables> -D f2b-<name> -s <ip> -p tcp -m multiport ! --dports <exemptports> -j <blocktype>
              <iptables> -D f2b-<name> -s <ip> -p udp -m multiport ! --dports <exemptports> -j <blocktype>
              echo "\$(date +"%%Y/%%m/%%d %%H:%%M:%%S")   UNBAN   [Email] = <F-USER> [IP] = <ip> unbanned." >> $LOG_FOLDER/easyxray-ipl-banned.log

[Init]
name = default
chain = INPUT
exemptports = $EXEMPT_PORTS
EOF

    fail2ban-client -x start
fi

# Certificate auto-renewal: acme.sh (installed by the panel's SSL menu) relies
# on a root crontab entry, but the crontab is lost when the container is
# recreated and crond was never started. Re-register the job and run crond so
# renewals actually fire; mount /root/.acme.sh as a volume to keep acme state.
if [ -f /root/.acme.sh/acme.sh ]; then
    /root/.acme.sh/acme.sh --install-cronjob >/dev/null 2>&1
    crond
fi

# Run easyxray
exec /app/easyxray
