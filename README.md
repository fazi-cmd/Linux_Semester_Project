
<div align="center">
  <h1>🚀 VirtuFS</h1>
  <p><strong>DevOps Storage Automation Tool</strong></p>
  <p>A Virtual File System Automation Tool written in Bash for DevOps engineers and system administrators</p>
  
  <p>
    <img src="https://img.shields.io/badge/version-1.0.0-blue.svg" alt="Version">
    <img src="https://img.shields.io/badge/bash-5.0+-brightgreen.svg" alt="Bash">
    <img src="https://img.shields.io/badge/license-MIT-orange.svg" alt="License">
    <img src="https://img.shields.io/badge/DevOps-Ready-ff69b4.svg" alt="DevOps Ready">
  </p>
</div>

---

## 📋 Overview

**VirtuFS** is a powerful Virtual File System Automation Tool designed to simplify storage management for DevOps professionals. Built entirely in Bash, it provides comprehensive solutions for managing virtual drives, automated backups, access control, system monitoring, and email notifications.

> 🎓 Developed as part of my 5th semester coursework

## ✨ Features

### 📁 **Drive Management**
- Create, delete, mount, and unmount virtual drives effortlessly
- Symbolic link mounting for easy access and navigation
- Seamless integration with existing file system

### 💾 **Backup System**
- Create plain and encrypted backups using `tar` and OpenSSL
- Restore drives from encrypted or plain backups
- Automated backup logging for audit trails
- Multiple backup formats supported

### 🔐 **Access Control**
- Assign ownership of drives to specific users
- Set granular permissions with Linux chmod
- View detailed drive ownership and permission information
- Multi-user support for collaborative environments

### 📊 **Status & Health Monitoring**
- Display total drives and real-time disk usage
- View recent backups and system logs
- Proactive health checks and monitoring
- Resource utilization tracking

### 📝 **Logging System**
- All operations logged in `logs/virtuFS.log`
- Color-coded messages for different severity levels:
  - ✅ Info (Green)
  - ⚠️ Warning (Yellow)
  - ❌ Error (Red)

### 📧 **Email Notifications**
- Real-time alerts for critical events
- Notifications for drive creation, deletion, and backup completion
- Configurable email settings
- Integration with `mail`/`sendmail`

## 🛠️ Installation

```bash
# Clone the repository
git clone https://github.com/<your-username>/VirtuFS.git

# Navigate to project directory
cd VirtuFS

# Make the script executable
chmod +x virtuFS.sh

# View help menu
./virtuFS.sh --help
```

> **Note:** Required directories and logs are created automatically on first run.

## 🚀 Usage Examples

### Drive Management Commands
```bash
# Create a new virtual drive
./virtuFS.sh drive create MyDrive

# Mount a virtual drive
./virtuFS.sh drive mount MyDrive

# Unmount a virtual drive
./virtuFS.sh drive unmount MyDrive

# Delete a virtual drive
./virtuFS.sh drive delete MyDrive
```

### Backup Operations
```bash
# Create a backup
./virtuFS.sh backup create MyDrive

# Restore from backup
./virtuFS.sh backup restore MyDrive backups/encrypted/MyDrive_20260218_120000.tar.gz.enc
```

### Access Control
```bash
# Set drive owner
./virtuFS.sh access owner MyDrive faizan

# Set permissions
./virtuFS.sh access chmod MyDrive 700

# View drive information
./virtuFS.sh access info MyDrive
```

### System Status
```bash
# Check system status
./virtuFS.sh status

# View system health
./virtuFS.sh health

# View operation logs
./virtuFS.sh logs
```

## 📁 Project Structure

```
VirtuFS/
├── 📜 virtuFS.sh           # Main Bash script
├── 📘 README.md            # Project documentation
├── 📄 project_report.pdf   # Detailed project report (PPT style)
├── 📂 logs/                # Automatic log directory
│   └── virtuFS.log        # Operation logs
├── 📂 backups/             # Backup storage
│   ├── 📂 plain/           # Unencrypted backups
│   └── 📂 encrypted/       # Encrypted backups
└── 📂 drives/              # Virtual drive storage
```

## 💻 Technologies Used

- **Linux Shell Scripting (Bash)** - Core functionality
- **OpenSSL** - Encryption/Decryption
- **tar** - Backup compression
- **Standard Linux Utilities** - `chmod`, `stat`, `ln`, `rm`
- **mail/sendmail** - Email notifications (optional)

## 🔧 Prerequisites

- Linux-based operating system
- Bash 5.0 or higher
- OpenSSL installed
- Basic Linux permissions

## 📊 System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| OS | Linux Kernel 4.x | Linux Kernel 5.x+ |
| RAM | 512 MB | 1 GB+ |
| Disk Space | 100 MB | 500 MB+ |
| Bash Version | 4.0 | 5.0+ |

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
