# 📦 Tutorial: Managing EBS Volumes on Amazon Linux

This tutorial guides you through managing an EBS volume on an Amazon Linux EC2 instance — from formatting and mounting, to creating sample files and migrating to Amazon EFS for shared access across multiple instances.

---

## 🎯 Objective

You will:
- Format and mount an EBS volume.
- Create and manage files within a `/data` directory.
- Migrate those files to an Amazon EFS volume for shared use across EC2 instances.

---

## ⚙️ Prerequisites

- An **Amazon EC2** instance running **Amazon Linux**.
- An **EBS volume** attached as `/dev/xvdb`.
- **SSH access** to the instance.
- Basic familiarity with the Linux command line.

---

## 🚨 Important Notes

- Always use `sudo` for administrative commands.
- **Formatting a volume will erase all existing data.**
- The `/etc/fstab` file is critical for ensuring the volume is mounted after a reboot.

---

## 🛠️ Setup Steps

> 💡 You can run the provided [`setup-ebs-volume.sh`](./setup-ebs-volume.sh) script to automate steps 1–12. Then skip directly to step 13.

---

### 🔹 Step 1: Verify Volume Attachment
```bash
lsblk
