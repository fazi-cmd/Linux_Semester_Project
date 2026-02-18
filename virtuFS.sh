#!/bin/bash

# =========================================================
# VirtuFS – Advanced DevOps Storage Automation
# Description: Virtual file system automation tool in Bash
# =========================================================

# ---------------- GLOBAL CONFIG ----------------
BASE_DIR="$HOME/VirtuFS"
DRIVE_DIR="$BASE_DIR/data/drives"
MOUNT_DIR="$BASE_DIR/mounts"
BACKUP_DIR="$BASE_DIR/backups"
LOG_DIR="$BASE_DIR/logs"
LOG_FILE="$LOG_DIR/virtuFS.log"

ENCRYPT_PASS="MyStrongPassword123"
EMAIL="fhatzsff@gmail.com"

# Create required directories
mkdir -p "$DRIVE_DIR" "$MOUNT_DIR" "$BACKUP_DIR/encrypted" "$BACKUP_DIR/plain" "$LOG_DIR"

# ---------------- LOGGING ----------------
log_info() { echo -e "\e[32m[INFO]\e[0m $(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"; }
log_warn() { echo -e "\e[33m[WARN]\e[0m $(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"; }
log_error() { echo -e "\e[31m[ERROR]\e[0m $(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"; }
fail() { log_error "$1"; return 1; }

# ---------------- EMAIL ----------------
send_email() {
    local subject="$1"
    local message="$2"
    echo -e "$message" | mail -s "$subject" "$EMAIL"
}

# ---------------- STEP 1: DRIVE / FILE MANAGEMENT ----------------
drive_create() {
    local name="$1"
    local path="$DRIVE_DIR/$name"
    [ -z "$name" ] && fail "Drive name required" && return
    [ -d "$path" ] && fail "Drive '$name' already exists" && return
    mkdir "$path" || { fail "Failed to create drive"; return; }
    log_info "Drive '$name' created"
}

drive_delete() {
    local name="$1"
    local path="$DRIVE_DIR/$name"
    [ ! -d "$path" ] && fail "Drive '$name' does not exist" && return
    if [ "$(stat -c '%U' "$path")" != "$(whoami)" ]; then
        fail "You do not own drive '$name'. Permission denied."
        return
    fi
    rm -rf "$path"
    log_warn "Drive '$name' deleted"
}

drive_mount() {
    local name="$1"
    local mount_point="$MOUNT_DIR/$name"
    local path="$DRIVE_DIR/$name"
    [ ! -d "$path" ] && fail "Drive '$name' does not exist" && return
    [ -L "$mount_point" ] && fail "Drive '$name' already mounted" && return
    ln -s "$path" "$mount_point"
    log_info "Drive '$name' mounted at $mount_point"
}

drive_unmount() {
    local name="$1"
    local mount_point="$MOUNT_DIR/$name"
    [ ! -L "$mount_point" ] && fail "Drive '$name' is not mounted" && return
    rm "$mount_point"
    log_info "Drive '$name' unmounted"
}

# ---------------- STEP 2: BACKUP SYSTEM ----------------
verify_backup() {
    local encfile="$1"
    local temp="$BACKUP_DIR/plain/verify.tar.gz"
    if openssl enc -d -aes-256-cbc -in "$encfile" -out "$temp" -k "$ENCRYPT_PASS"; then
        tar -tzf "$temp" >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            log_info "Backup '$encfile' integrity verified ✅"
        else
            log_error "Backup '$encfile' is corrupted ❌"
        fi
    else
        log_error "Failed to decrypt '$encfile' for verification ❌"
    fi
    rm -f "$temp"
}

backup_create() {
    local name="$1"
    local drive="$DRIVE_DIR/$name"
    [ ! -d "$drive" ] && fail "Drive '$name' does not exist" && return
    if [ "$(stat -c '%U' "$drive")" != "$(whoami)" ]; then
        fail "You do not own drive '$name'. Permission denied."
        return
    fi

    local ts=$(date +%Y%m%d_%H%M%S)
    local tarfile="$BACKUP_DIR/plain/${name}_${ts}.tar.gz"
    local encfile="$BACKUP_DIR/encrypted/${name}_${ts}.tar.gz.enc"

    tar -czf "$tarfile" -C "$DRIVE_DIR" "$name"
    openssl enc -aes-256-cbc -salt -in "$tarfile" -out "$encfile" -k "$ENCRYPT_PASS"
    rm "$tarfile"

    log_info "Encrypted backup created for drive '$name'"
    verify_backup "$encfile"

    send_email "VirtuFS Backup Complete" "Encrypted backup created for drive '$name': $encfile"
    rotate_backups "$name" 5  # keep last 5 backups
}

backup_restore() {
    local name="$1"
    local file="$2"
    [ ! -f "$file" ] && fail "Backup file not found" && return
    local temp="$BACKUP_DIR/plain/restore.tar.gz"
    openssl enc -d -aes-256-cbc -in "$file" -out "$temp" -k "$ENCRYPT_PASS"
    tar -xzf "$temp" -C "$DRIVE_DIR"
    rm "$temp"
    log_warn "Drive '$name' restored from backup"
}

rotate_backups() {
    local drive="$1"
    local max_backups="$2"
    local backups=( $(ls -1t "$BACKUP_DIR/encrypted/${drive}"_*.tar.gz.enc 2>/dev/null) )
    local count=${#backups[@]}

    if (( count > max_backups )); then
        for ((i=max_backups; i<count; i++)); do
            rm -f "${backups[$i]}"
            log_info "Deleted old backup: ${backups[$i]}"
            send_email "VirtuFS Backup Cleanup" "Deleted old backup: ${backups[$i]}"
        done
    fi
}

# ---------------- AUTO BACKUP SHORT TERM ----------------
auto_backup_short_term() {
    local drive="$1"
    local interval="$2"   # in seconds
    local retention="$3"  # in seconds

    log_info "Starting short-term auto-backup for '$drive' every $interval seconds, deleting backups older than $retention seconds."

    while true; do
        backup_create "$drive"
        find "$BACKUP_DIR/encrypted" -type f -name "${drive}_*.tar.gz.enc" -mmin +$((retention/60)) -exec bash -c 'rm -f "$0"; send_email "VirtuFS Cleanup" "Deleted old backup: $0"' {} \;
        sleep "$interval"
    done
}

# ---------------- STEP 3: USER ACCESS CONTROL ----------------
set_drive_owner() {
    local drive="$1"
    local user="$2"
    local path="$DRIVE_DIR/$drive"
    [ ! -d "$path" ] && fail "Drive '$drive' does not exist" && return
    if ! id "$user" &>/dev/null; then fail "User '$user' does not exist" && return; fi
    sudo chown -R "$user":"$user" "$path"
    log_info "Owner of drive '$drive' set to '$user'"
}

set_drive_permissions() {
    local drive="$1"
    local perms="$2"
    local path="$DRIVE_DIR/$drive"
    [ ! -d "$path" ] && fail "Drive '$drive' does not exist" && return
    chmod -R "$perms" "$path"
    log_info "Permissions of drive '$drive' set to '$perms'"
}

drive_owner_info() {
    local drive="$1"
    local path="$DRIVE_DIR/$drive"
    [ ! -d "$path" ] && fail "Drive '$drive' does not exist" && return
    local owner=$(stat -c '%U' "$path")
    local perms=$(stat -c '%A' "$path")
    echo "Drive: $drive | Owner: $owner | Permissions: $perms"
}

# ---------------- STEP 4: STATUS & HEALTH ----------------
disk_alert() {
    local threshold="$1"
    local usage=$(df "$DRIVE_DIR" | tail -1 | awk '{print $5}' | tr -d '%')
    if (( usage >= threshold )); then
        log_warn "Disk usage at $usage% ⚠️"
        send_email "VirtuFS Disk Alert" "Disk usage is high: $usage%"
    fi
}

show_status() {
    echo "----- VirtuFS Status -----"
    echo "Total Drives: $(ls "$DRIVE_DIR" | wc -l)"
    echo "Total Size: $(du -sh "$DRIVE_DIR" | cut -f1)"
    disk_alert 80
}

show_health() {
    echo "----- Health Report -----"
    echo "Last Backups:"
    ls -lt "$BACKUP_DIR/encrypted" | head -5
}

show_logs() {
    tail -n 20 "$LOG_FILE"
}

# ---------------- STEP 5: SNAPSHOT ----------------
drive_snapshot() {
    local drive="$1"
    local ts=$(date +%Y%m%d_%H%M%S)
    local snapshot="$BACKUP_DIR/plain/${drive}_snapshot_$ts.tar.gz"
    tar -czf "$snapshot" -C "$DRIVE_DIR" "$drive"
    log_info "Snapshot created: $snapshot"
    send_email "VirtuFS Snapshot" "Snapshot created for drive '$drive': $snapshot"
}

# ---------------- CLI PARSER ----------------
case "$1" in
    drive)
        case "$2" in
            create) drive_create "$3" ;;
            delete) drive_delete "$3" ;;
            mount) drive_mount "$3" ;;
            unmount) drive_unmount "$3" ;;
            *) echo "Invalid drive command";;
        esac
        ;;
    backup)
        case "$2" in
            create) backup_create "$3" ;;
            restore) backup_restore "$3" "$4" ;;
            *) echo "Invalid backup command";;
        esac
        ;;
    access)
        case "$2" in
            owner) set_drive_owner "$3" "$4" ;;
            chmod) set_drive_permissions "$3" "$4" ;;
            info) drive_owner_info "$3" ;;
            *) echo "Invalid access command";;
        esac
        ;;
    auto-backup)
        case "$2" in
            short-term) auto_backup_short_term "$3" "$4" "$5" ;;
            *) echo "Invalid auto-backup command";;
        esac
        ;;
    snapshot) drive_snapshot "$2" ;;
    status) show_status ;;
    health) show_health ;;
    logs) show_logs ;;
    --help|*) cat <<EOF
VirtuFS – DevOps Storage Automation Tool

Commands:
  drive create <name>
  drive delete <name>
  drive mount <name>
  drive unmount <name>

  backup create <drive>
  backup restore <drive> <file>

  access owner <drive> <user>
  access chmod <drive> <permissions>
  access info <drive>

  auto-backup short-term <drive> <interval-sec> <retention-sec>

  snapshot <drive>

  status
  health
  logs
EOF
;;
esac

