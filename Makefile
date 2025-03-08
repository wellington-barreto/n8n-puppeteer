include .env

up:
	@echo "Checking if network exists..."
	@docker network inspect n8n_network > /dev/null 2>&1 && echo "Network 'n8n_network' already exists, hopping to the next task 🦘." || (echo "Creating network..." && docker network create n8n_network)
	@docker volume inspect n8n_data-${N8N_VERSION} > /dev/null 2>&1 && echo "Volume 'n8n_data-${N8N_VERSION}' already exists, hopping to the next task 🦘." || (echo "Creating volume..." && docker volume create n8n_data-${N8N_VERSION})
	@echo "Building Docker image..."
	docker build \
		--build-arg N8N_VERSION=${N8N_VERSION} \
		--build-arg PUPPETEER_VERSION=${PUPPETEER_VERSION} \
		-t n8n-${N8N_VERSION} \
		.
	@echo "Running Docker container..."
	docker run -d \
		--name n8n-${N8N_VERSION} \
		-e N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
		-e N8N_RUNNERS_ENABLED=true \
		-e N8N_ENCRYPTION_KEY=${N8N_ENCRYPTION_KEY} \
		-e N8N_SECURE_COOKIE=${IS_PRODUCTION_TRUE} \
		-e N8N_LOG_LEVEL=info \
		-e N8N_LOG_OUTPUT=console \
		-e NODE_FUNCTION_ALLOW_EXTERNAL=${EXTERNAL_PACKAGES} \
		-p 5678:5678 \
		--restart unless-stopped \
		-v n8n_data-${N8N_VERSION}:/home/node/.n8n \
		--network n8n_network \
		n8n-${N8N_VERSION}

down:
	@echo "Stopping and removing Docker container..."
	docker stop n8n-${N8N_VERSION}
	docker rm n8n-${N8N_VERSION}
	# Optionally remove the image:
	# docker rmi n8n-${N8N_VERSION}
	# docker network rm n8n_network

build:
	@echo "Building Docker image..."
	docker build \
		--build-arg N8N_VERSION=${N8N_VERSION} \
		--build-arg PUPPETEER_VERSION=${PUPPETEER_VERSION} \
		-t n8n-${N8N_VERSION} \
		.
