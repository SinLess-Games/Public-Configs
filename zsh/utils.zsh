# [<level] | <message>
# 0: INFO - Blue with info emoji
# 1: WARN - Yellow with warning emoji
# 2: ERROR - bold bright Red with error emoji
# message should return to white

function log_info() {
    local msg="$1"
    echo -e "\e[34mℹ️  INFO: \e[0m$msg"
}

function log_warn() {
    local msg="$1"
    echo -e "\e[33m⚠️  WARN: \e[0m$msg"
}

function log_error() {
    local msg="$1"
    echo -e "\e[1;31m❌ ERROR: \e[0m$msg"
}