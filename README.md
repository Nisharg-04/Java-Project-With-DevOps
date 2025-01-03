# Java Project with DevOps

![Architecture Diagram](Architecture_Diagram.png)

## Table of Contents
- [Project Overview]
- [Features]
- [Technologies Used]
- [Setup and Installation]
- [Continuous Integration and Deployment]
- [Project Structure]
- [How to Use]
- [Testing]

## Project Overview
This project demonstrates the integration of DevOps principles with a Java application. It includes the complete lifecycle of software development, deployment, and monitoring, following industry best practices. The project utilizes tools and technologies for source control, continuous integration, containerization, orchestration, and monitoring.

## Features
- Modular Java application
- Continuous Integration with automated builds
- Continuous Deployment to a containerized environment
- Infrastructure as Code (IaC)

## Technologies Used
- **Programming Language:** Java
- **Build Tool:** Maven/Gradle
- **Version Control:** Git
- **CI/CD:** Jenkins
- **Containerization:** Docker
- **Orchestration:** Kubernetes
- **Infrastructure as Code:** Terraform/Ansible

## Setup and Installation

### Prerequisites
1. Java Development Kit (JDK 11 or later)
2. Maven or Gradle
3. Docker and Docker Compose
4. Kubernetes cluster (Minikube, AKS, EKS, or GKE)
5. Terraform/Ansible for infrastructure provisioning



# Infrastructure Setup with Terraform, Ansible

## Overview
This documentation outlines the process for setting up a complete  infrastructure for a Java-based application. The infrastructure is provisioned using Terraform, and Ansible is used to configure the instances, including setting up a Kubernetes cluster and related services like Jenkins, SonarQube, and Nexus.

---

## Prerequisites

1. **Terraform**: Ensure Terraform is installed on your local machine.
2. **Ansible**: Install Ansible and ensure the required roles are configured.
3. **AWS Account**: Ensure access to an AWS account with the necessary permissions.
4. **Public Key**: Place your public key file (`devops-key.pub`) in the appropriate directory.
5. **AMI**: Replace placeholder AMI IDs in the Terraform configuration with appropriate values.

---

## Steps to Provision Infrastructure

### 1. Clone the Repository
```bash
$ git clone <repository-url>
$ cd <repository-directory>
```

### 2. Initialize Terraform
```bash
$ terraform init
```

### 3. Validate the Configuration
```bash
$ terraform validate
```

### 4. Apply the Configuration
```bash
$ terraform apply
```
- Review the plan and type `yes` to proceed.
- Terraform provisions the VPC, security groups, EC2 instances, and other resources.

---

## Update Inventory Script
After the Terraform provisioning is complete, update the Ansible inventory file dynamically:

1. Run the inventory update script:
```bash
$ ./update_inventory.sh
```
- This script fetches the public/private IPs of the provisioned instances and updates the Ansible inventory file.

---

## Configure Instances with Ansible

### Configure all the Instances
```bash
   $ ansible-playbook -i inventories/inventory playbook.yml
   ```

---

## Kubernetes Cluster Verification

1. **Verify Nodes**:
   Run the following command on the master node:
   ```bash
   $ kubectl get nodes
   ```
   Ensure all nodes are in the `Ready` state.

---

## Notes

- **Terraform Modules**: The `infra` directory contains reusable Terraform modules for EC2 instances.
- **Ansible Roles**: Ensure roles for Docker, Kubernetes, SonarQube, Jenkins, and Nexus are properly configured in the `roles` directory.

---

This document provides a high-level guide to setting up and configuring the infrastructure. For detailed configurations, refer to the respective directories and files in the repository.

### Clone the Repository
```bash
git clone https://github.com/Nisharg-04/Java-Project-With-DevOps.git
cd Java-Project-With-DevOps
```

### Build the Project
```bash
mvn clean install
```

### Run Locally
To run the application locally:
```bash
java -jar target/your-application.jar
```


### Docker Setup
1. Build the Docker image:
   ```bash
   docker build -t nishargsoni/boardgame:latest .
   ```
2. Run the Docker container:
   ```bash
   docker run -p 8080:8080 nishargsoni/boardgame:latest
   ```


### Kubernetes Deployment
1. Apply the Kubernetes manifests:
   ```bash
   kubectl apply -f deployment-service.yaml
   ```
2. Verify the deployment:
   ```bash
   kubectl get pods -n webapps
   kubectl get svc -n webapps
   ``

## Continuous Integration and Deployment
The project uses Jenkins for CI/CD.

### Jenkins Pipeline Overview
The Jenkins pipeline automates the entire CI/CD workflow for a Java-based project. It includes the following stages:

1. **Code Checkout:** Pulls the source code from the GitHub repository.
2. **Compile the Code:** Compiles the Java project using Maven.
3. **Test the Code:** Runs unit tests to ensure code quality.
4. **Scan the Code:** Scans the codebase using Trivy for security vulnerabilities.
5. **SonarQube Analysis:** Analyzes the code for quality metrics using SonarQube.
6. **Build:** Packages the application into a JAR/WAR file.
7. **Publish to Nexus:** Deploys the build artifact to Nexus Repository Manager.
8. **Build Docker Image:** Creates a Docker image for the application.
9. **Push Docker Image:** Pushes the Docker image to Docker Hub.
10. **Deploy to Kubernetes:** Deploys the application to a Kubernetes cluster.
11. **Verify Deployment:** Ensures the application is running correctly in the cluster.

### Notes
- **Tools and Plugins:** Ensure Jenkins has the required plugins installed (e.g., Git, Maven Integration, Docker Pipeline, SonarQube Scanner, and Kubernetes CLI).
- **SonarQube Configuration:** Configure SonarQube in Jenkins with the appropriate credentials and tools.
- **Docker Hub Credentials:** Store Docker Hub credentials securely in Jenkins Credentials Manager.
- **Kubernetes Configuration:** Ensure Kubernetes is properly configured with valid credentials and the correct context.

## Project Structure
```plaintext
Java-Project-With-DevOps/
├── Ansible/            # Configuration of Infrastructure
├── Terraform/          # Setup Infrastructure
├── src/                # Source code
├── target/             # Compiled files
├── Dockerfile          # Docker image definition
├── k8s-config/                # Kubernetes manifests
├── Jenkinsfile         # Jenkins pipeline configuration
├── README.md           # Project documentation
```

## How to Use
1. Clone the repository and set up the environment.
2. Use Jenkins to run the pipeline and deploy the application.
3. Verify the deployment on the Kubernetes cluster.


## Contributing
Contributions are welcome! Please fork the repository and submit a pull request.

### Steps to Contribute
1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit your changes: `git commit -m 'Add feature-name'`
4. Push to the branch: `git push origin feature-name`
5. Open a pull request
