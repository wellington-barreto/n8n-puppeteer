![n8n.io - Workflow Automation](https://user-images.githubusercontent.com/65276001/173571060-9f2f6d7b-bac0-43b6-bdb2-001da9694058.png)

# n8n - Secure Workflow Automation for Technical Teams

n8n is a workflow automation platform that gives technical teams the flexibility of code with the speed of no-code. With 400+ integrations, native AI capabilities, and a fair-code license, n8n lets you build powerful automations while maintaining full control over your data and deployments. Note: This repository is forked from the [official n8nio.n8n image](https://github.com/n8n-io/n8n.git) and includes additional components to allow for Puppeteer to function properly within code nodes.

## Usage

```bash
# Clone Repo
git clone https://github.com/devszilla/n8n-puppeteer.git

# Navigate to the project directory
cd n8n-puppeteer/docker/images/n8n

# Create a .env file with required versions
printf "N8N_VERSION=1.59.4\nPUPPETEER_VERSION=23.1.0\n" > .env

# Build and start n8n-puppeteer as a container (requires Docker & Make)
make up

```
