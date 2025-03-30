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
```
Lists block devices. Confirm that `/dev/xvdb` is attached.

---

### 🔹 Step 2: Format the Volume
```bash
sudo mkfs.xfs /dev/xvdb
```
Formats the volume with the **XFS** file system.

---

### 🔹 Step 3: Create the Mount Point
```bash
sudo mkdir /data
```
Creates the `/data` directory to mount the volume.

---

### 🔹 Step 4: Mount the Volume
```bash
sudo mount /dev/xvdb /data
```

---

### 🔹 Step 5: Verify the Mount
```bash
df -h
```
Checks that `/dev/xvdb` is mounted on `/data`.

---

### 🔹 Step 6: Make the Mount Persistent on Reboot
```bash
sudo bash -c 'echo "UUID=$(sudo blkid -s UUID -o value /dev/xvdb) /data xfs defaults,nofail 0 2" >> /etc/fstab'
```

> **Why this is better:** Using the UUID makes the mount more reliable, since device names like `/dev/xvdb` can change after a reboot.

---

### 🔹 Step 7: Verify `/etc/fstab` Entry
```bash
cat /etc/fstab
```

---

### 🔹 Step 8: Change Directory
```bash
cd /data
```

---

### 🔹 Step 9: Change Ownership of the Directory
```bash
sudo chown ec2-user:ec2-user /data
```

---

### 🔹 Step 10: Create Files
```bash
sudo touch file1 file2 file3 file4
```

---

### 🔹 Step 11: Add Content to Files
```bash
sudo bash -c 'echo "This is the content of file 1. Created on $(date)" > file1'
sudo bash -c 'echo "Welcome to file 2. This file was created in the data volume." > file2'
sudo bash -c 'echo "Welcome to file 3. This file was created for you in the data volume." > file3'
sudo bash -c 'echo "This is file 4. Created on $(date)" > file4'
```

---

### 🔹 Step 12: Verify File Creation
```bash
ls -l /data
```

---

### 🔹 Step 13: Display File Contents
```bash
cat /data/file1
cat /data/file2
cat /data/file3
cat /data/file4
```

---

## 🔄 Migrating to Amazon EFS

If you're moving from EBS to **Amazon EFS** for shared storage across multiple EC2 instances, use the provided [`switch-to-efs.sh`](./switch-to-efs.sh) script on the first server. This script will:
- Mount the EFS volume
- Copy contents from `/data` to the EFS
- Remap `/data` to point to the shared EFS volume

---

## 📁 Repository Files

| File Name | Description |
|-----------|-------------|
| [`CMDhist`](./CMDhist) | Full command history from all three Amazon Linux instances |
| [`setup-ebs-volume.sh`](./setup-ebs-volume.sh) | Script to automate EBS volume setup on each EC2 server |
| [`switch-to-efs.sh`](./switch-to-efs.sh) | Script to migrate `/data` directory to Amazon EFS |

---

## 🙌 Authors & Credits

This tutorial was created for use in an **Intro to AWS** training course. Contributions and improvements are welcome!

---

## 🧠 Tip

Remember to test mounts with `df -h` and ensure that security groups allow **NFS (TCP 2049)** if working with EFS.

---

## 📜 License

MIT License – feel free to use and adapt!
