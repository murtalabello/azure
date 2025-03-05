
# AI Training Infrastructure Deployment

🚀 Overview
This repository contains Terraform code and GitHub Actions workflows to deploy a **GPU Virtual Machine (VM) on Azure** for AI training. The infrastructure is managed using **GitHub Actions** for automation and **Azure Federated Credentials** for authentication.

---

📌 Prerequisites
Before deploying, ensure you have:
- An **Azure Subscription**.
- **Owner or Contributor access** to create resources.
- A **GitHub repository** with access to **GitHub Actions**.
- **Terraform installed locally** (optional, but useful for testing).

---

## 🔹 Step 1: Configure Azure Authentication in GitHub
### 1️⃣ Create an Azure App Registration
1. **Go to** [Azure Portal → Microsoft Entra ID (Azure AD)](https://portal.azure.com).
2. **Click "App registrations" → "New registration"**.
3. **Enter a Name** (e.g., `github-terraform`).
4. **Select "Single tenant"**.
5. **Click "Register"**.

### 2️⃣ Get the Required Credentials
After registration, collect the following from **Azure Portal → App Registrations → Your App → Overview**:
- **Application (Client) ID**
- **Directory (Tenant) ID**

---

## 🔹 Step 2: Configure Federated Credentials for GitHub Actions
### 1️⃣ Go to "Certificates & secrets" → "Federated credentials"
1. **Click "Add a credential"**.
2. **Select "GitHub Actions deploying Azure resources"**.
3. **Fill in the details**:
   - **Organization:** `<Your GitHub Organization>`
   - **Repository:** `<Your GitHub Repository>`
   - **Entity type:** `Environment`
   - **Subject Identifier:** `repo:<Your_GitHub_Org>/<Your_Repo>:environment:<env>`
4. **Click "Add"**.

### 2️⃣ Assign Required Permissions
Go to **"API Permissions" → "Add a permission"**:
- Select **Azure Management API**.
- Add **`Contributor` or `Owner` role** to your subscription:
  ```sh
  az role assignment create --assignee <APPLICATION_CLIENT_ID> --role Contributor --scope /subscriptions/<SUBSCRIPTION_ID>
  ```

---

## 🔹 Step 3: Store Secrets in GitHub
### 1️⃣ Go to GitHub Repository → Settings → Secrets and Variables → Actions
2. **Add the following secrets**:

| Secret Name          | Value |
|----------------------|-----------------------------------------------------------------|
| `AZURE_CLIENT_ID`    | **(Your Azure App Registration Client ID)** |
| `AZURE_TENANT_ID`    | **(Your Azure Tenant ID)** |
| `AZURE_SUBSCRIPTION_ID` | **(Your Azure Subscription ID)** |
| `SSH_PUBLIC_KEY`     | **(Your SSH public key for VM login)** |

---

## 🔹 Step 4: Deploy AI Training Infrastructure Using GitHub Actions
### 1️⃣ Repository Structure
```plaintext
.
├── .github/workflows/
│   ├── azure-ai-infra.yml    # GitHub Actions Workflow for Terraform deployment
│
├── ai-training-gpu-vm/
│   ├── backend.tf            # (Optional) Backend configuration for Terraform state
│   ├── main.tf               # Main Terraform configuration
│   ├── provider.tf           # Azure provider settings
│   ├── variables.tf          # Terraform input variables
│   ├── vm.tf                 # Defines GPU VM resources
```

### 2️⃣ Run the GitHub Actions Workflow
1. **Go to GitHub → Actions**.
2. **Manually trigger the workflow**.
3. **Click "Run Workflow"**.

The pipeline will:
✅ **Authenticate using Azure Federated Credentials**.  
✅ **Initialize Terraform and apply the configuration**.  
✅ **Deploy a GPU VM on Azure for AI training**.

---

## 🔹 Step 5: Verify Deployment
1. **Go to Azure Portal → Virtual Machines**.
2. Find the **GPU VM** deployed.
3. **Connect to the VM** using SSH:
   ```sh
   ssh azureuser@<VM_PUBLIC_IP>
   ```
4. **Install AI dependencies & check GPU**:
   ```sh
   sudo apt update && sudo apt install -y nvidia-driver-535
   nvidia-smi  # Should show GPU details
   ```

---

## 🔹 Step 6: Training AI Models on GPU VM
1. **Create a Python environment**:
   ```sh
   python3 -m venv ai-env
   source ai-env/bin/activate
   pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
   ```
2. **Run a simple training script**:
   ```python
   import torch
   print(torch.cuda.is_available())  # Should return True
   ```

---

## ✅ Next Steps
- Automate AI training inside the VM.
- Explore **Azure Machine Learning (AML)** for scalable AI workloads.
- Set up **cost monitoring** to optimize GPU usage.


