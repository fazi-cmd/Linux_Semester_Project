VirtuFS – DevOps Storage Automation Tool

VirtuFS is a Virtual File System Automation Tool written in Bash (Linux Shell Scripting).
It is designed for DevOps engineers and system administrators to manage virtual drives, perform automated backups, control access, monitor system health, and send email notifications for key events.

This project was developed as part of my 5th semester coursework.

🔹 Features
Drive / File Management

Create, delete, mount, and unmount virtual drives.

Symbolic link mounting for easy access.

Backup System

Create plain and encrypted backups using tar and OpenSSL.

Restore drives from backups.

Maintain automatic backup logs.

User Access Control

Assign ownership of drives to specific users.

Set permissions with Linux chmod.

View drive ownership and permission info.

Status & Health Monitoring

Show total drives and disk usage.

Display recent backups and logs.

Logging

All operations are logged in logs/virtuFS.log.

Color-coded messages for Info, Warning, and Error.

Email Notifications

Alerts for important events like drive creation, deletion, and backup completion.

🔹 Installation
# Clone the repository
git clone https://github.com/<your-username>/VirtuFS.git
cd VirtuFS

# Make the script executable
chmod +x virtuFS.sh

# View help menu
./virtuFS.sh --help


Required directories and logs are created automatically on first run.

🔹 Usage Examples
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

🔹 Project Files

virtuFS.sh – Main Bash script

project_report.pdf – PPT-style project report

README.md – Project overview and instructions

🔹 Technologies Used

Linux Shell Scripting (Bash)

OpenSSL – Encryption

Standard Linux utilities: tar, chmod, stat, ln, rm

Optional: mail / sendmail for email notifications
