*This project has been created as part of the 42 curriculum by albealva.*

# Inception - Virtualization and Infrastructure

## 📝 Description
The **Inception** project is a fundamental deep dive into system administration and virtualization. The primary goal is to orchestrate a complex infrastructure of multiple services using **Docker Compose**. 

The project involves building a multi-container architecture from scratch using **Debian Bookworm** as the base image for all services. This infrastructure includes a high-performance web server (Nginx), a content management system (WordPress with PHP-FPM), and a relational database (MariaDB). Additionally, several bonus services have been integrated to enhance the stack: Redis for caching, Adminer for database management, an FTP server for file handling, and a dedicated static website.

### Design Choices & Infrastructure
- **Base Image**: Debian was chosen for its stability and widespread use in server environments.
- **Custom Dockerfiles**: Every image is built from scratch to ensure no "pre-made" magic is used, adhering to the project's educational constraints.
- **Service Isolation**: Each service runs in its own container to maintain a microservices architecture.

---

## 🛠️ Instructions

### Prerequisites
- **Docker** and **Docker Compose** installed.
- Access to a Unix-based environment (preferably Debian/Ubuntu).

### Installation & Execution
1.  **Host Configuration**: Add the domain to your `/etc/hosts`:
    ```bash
    127.0.0.1 albealva.42.fr
    ```
2.  **Environment Setup**: Create a `.env` file in the `srcs/` directory based on the provided requirements (Database names, passwords, users).
3.  **Compilation**: Run the following command from the root of the project:
    ```bash
    make
    ```
    *This will trigger the build of all Dockerfiles and launch the containers in detached mode.*
4.  **Verification**: Visit `https://albealva.42.fr` in your browser.

---

## 📊 Technical Comparisons

### Virtual Machines vs Docker
- **Virtual Machines (VMs)**: Virtualize the hardware. Each VM includes a full copy of an operating system, the application, necessary binaries, and libraries - taking up tens of GBs.
- **Docker**: Virtualizes the Operating System. Containers share the host’s OS kernel, making them significantly more lightweight, faster to start, and efficient in resource usage.

### Secrets vs Environment Variables
- **Environment Variables**: Great for configuration (URLs, ports) but visible to any process and often logged in clear text.
- **Secrets**: Specifically designed for sensitive data (passwords, API keys). They are encrypted at rest and only decrypted when mounted into the container's memory, offering a higher security tier.

### Docker Network vs Host Network
- **Host Network**: The container shares the host's networking namespace directly (no isolation).
- **Docker Network (Bridge)**: Creates an isolated private network. Containers can communicate with each other using service names (DNS), but are protected from the outside world unless ports are explicitly mapped.

### Docker Volumes vs Bind Mounts
- **Bind Mounts**: Depend on the directory structure of the host machine (e.g., `/home/user/data`). They are sensitive to host OS changes.
- **Docker Volumes**: Managed by Docker itself. They are abstracted from the host's file system structure, safer for migrations, and better for performance in specialized environments.

---

## 📚 Resources

### References
- [Docker Documentation](https://docs.docker.com/) - Official guide for Dockerfiles and Compose.
- [Nginx TLS Configuration](https://nginx.org/en/docs/http/configuring_https_servers.html) - Best practices for SSL/TLS.
- [WordPress CLI Guide](https://make.wordpress.org/cli/handbook/) - Automating WordPress installation via scripts.
- [vsftpd Manual](http://vsftpd.beasts.org/vsftpd_conf.html) - Configuration for secure FTP.

### Use of Artificial Intelligence
AI (Gemini 3 Flash) was utilized as a **collaborative peer** during this project for the following tasks:
- **Script Optimization**: Assistance in debugging the `setup.sh` logic for WordPress to ensure idempotent installations.
- **Debugging**: Helping identify syntax errors in Dockerfiles (e.g., missing dependencies or incorrect paths).
- **Documentation**: Structuring and translating technical comparisons for this README to ensure clarity and professional tone.
- **Troubleshooting**: Providing insights into Redis-WordPress connectivity issues.

---
