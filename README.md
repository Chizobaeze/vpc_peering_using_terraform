# VPC_PEERING_USING_TERRAFORM

At StellarTech, development was slowed because our testing environment, **Quest**, couldn’t access staging services in **Arena**. Developers had to copy services manually, and testers couldn’t check early changes easily.

We solved this by setting up a VPC peering connection, creating a secure link between Quest and Arena. Now, testers can see updates sooner, and development cycles are faster and more efficient. This simple connection boosted collaboration and helped our teams deliver higher-quality features, quicker.
# Quest-Arena VPC Peering

This repository contains the Terraform infrastructure code for establishing a **secure VPC peering connection** between the following environments:

* **Quest-Development**: The development environment where game developers build and test new features.
* **Arena-Staging**: The staging environment used for pre-release testing and validation.

##  Background

Initially, Quest-Development and Arena-Staging operated in isolation:

* Developers had to manually copy staging services into Quest.
* Testers couldn’t easily access early changes from developers.

This slowed down testing, introduced duplication of work, and delayed feedback.

##  Solution

To solve this, we implemented **VPC peering**:

* Created a secure network link between **Quest-Development** and **Arena-Staging**.
* Enabled Quest to access Arena services directly.
* Allowed testers to validate changes earlier.

  ![vpc screenshot](https://github.com/Chizobaeze/vpc_peering_using_terraform/blob/4e2de19b533d09149201282f0b8c0608cd228803/vpc_peering_connection.PNG)

### Benefits

* Faster development cycles.
* Easier collaboration between developers and testers.
* Reduced duplication of services.
* More efficient and secure testing.

## 🛠️ Infrastructure

The infrastructure is managed with **Terraform**:

* Creates and manages the VPC peering connection.
* Configures routing between environments.
* Ensures secure access controls.

## 📂 Repository Structure

```
quest-arena-peering/
├── vpc_peer.tf              # Main Terraform configuration
├── backend.tf           # Outputs after deployment
├── providers.tf         ## Remote backend configuration
├── README.md            # Project documentation
```

## ⚙️ Usage

### Prerequisites

* [Terraform](https://developer.hashicorp.com/terraform/downloads) v1.3+
* Access to both Quest and Arena cloud environments
* Proper IAM permissions to create VPC peering connections and modify routing tables

### Steps

1. Clone the repository:

   ```bash
   git clone https://github.com/Chizobaeze/vpc_peering_using_terraform.git
   cd vpc_peering_using_terraform

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Review and customize variables in `variables.tf` or create a `terraform.tfvars` file.

4. Plan the changes:

   ```bash
   terraform plan
   ```

5. Apply the infrastructure:

   ```bash
   terraform apply
   ```

##  Security

* Traffic between Quest and Arena flows securely through the VPC peering connection.
* No public exposure of services.
* Access is restricted via route tables and security groups.

##  Future Improvements

* Add automated tests for connectivity.
* Implement monitoring and logging for peering traffic.
* Extend peering setup for additional environments.

---

 **With VPC peering, Quest and Arena now collaborate seamlessly, making game development and testing faster, smoother, and more efficient.**
