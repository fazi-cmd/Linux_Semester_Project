VirtuFS – Storage Automation
Overview

VirtuFS is a Virtual File System Automation Tool built in Bash (Linux Shell Scripting). It helps manage virtual drives, create backups, control user access, monitor system health, and send email notifications for important events.

This project was developed as part of my 5th semester in DevOps.

Features

Drive Management: Create, delete, mount, and unmount virtual drives.

Backup System: Create encrypted and plain backups, and restore drives.

User Access Control: Set drive owners, permissions, and view ownership info.

Status & Health: Show total drives, drive size, recent backups, and logs.

Logging: All actions are logged in logs/virtuFS.log.

Email Notifications: Send alerts for drive creation, deletion, or backup events.

Installation
git clone https://github.com/<your-username>/VirtuFS.git
cd VirtuFS
chmod +x virtuFS.sh
./virtuFS.sh --help

Usage Examples
Drive Management
./virtuFS.sh drive create MyDrive
./virtuFS.sh drive mount MyDrive
./virtuFS.sh drive unmount MyDrive
./virtuFS.sh drive delete MyDrive

Backup
./virtuFS.sh backup create MyDrive
./virtuFS.sh backup restore MyDrive backups/encrypted/MyDrive_20260218_120000.tar.gz.enc

Access Control
./virtuFS.sh access owner MyDrive faizan
./virtuFS.sh access chmod MyDrive 700
./virtuFS.sh access info MyDrive

Status & Health
./virtuFS.sh status
./virtuFS.sh health
./virtuFS.sh logs

Project Files

virtuFS.sh – Main Bash script

project_report.pdf – PPT-style project report

README.md – Project overview and instructions
