# Variables
DOCKER_IMAGE_NAME = medusa-app
DOCKER_REGISTRY = atknatk/medusa
VERSION = latest
PLATFORMS = linux/amd64,linux/arm64

# Default target
.PHONY: build

# Build the multi-platform image using Buildx
build:
	@echo "Building the Docker image for platforms: $(PLATFORMS)"
	docker buildx build \
		--platform $(PLATFORMS) \
		--tag $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(VERSION) \
		--push .

# Build the image without pushing (useful for local testing)
build-local:
	@echo "Building the Docker image for platforms: $(PLATFORMS) (no push)"
	docker buildx build \
		--platform $(PLATFORMS) \
		--tag $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(VERSION) .

# Create a new builder instance if it doesn't exist
.PHONY: create-builder
create-builder:
	@echo "Creating a new builder instance"
	docker buildx create --name multiarch-builder --use

# Inspect the builder instance
.PHONY: inspect-builder
inspect-builder:
	@echo "Inspecting the builder instance"
	docker buildx inspect --bootstrap

# Remove the builder instance
.PHONY: remove-builder
remove-builder:
	@echo "Removing the builder instance"
	docker buildx rm multiarch-builder

# Clean all images (local cleanup)
.PHONY: clean
clean:
	@echo "Cleaning up local Docker images"
	docker image prune -af
