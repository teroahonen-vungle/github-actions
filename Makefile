CMD=hello

PROJECT_IMAGE?=320005014399.dkr.ecr.us-east-1.amazonaws.com/buildx-test:dev

code-build-multi-arch:
	@echo "[code-build-multi-arch] Compiling $(CMD)"
	@mkdir -p cmd/$(CMD)/_out
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o cmd/$(CMD)/_out/$(CMD)_amd64 ./cmd/$(CMD)
	CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -a -o cmd/$(CMD)/_out/$(CMD)_arm64 ./cmd/$(CMD)

_prepare-multiarch:
	# Ensure there is an available docker container builder for buildx.
	docker buildx ls | grep 'multiarch-builder' > /dev/null || { docker buildx create --use --name multiarch-builder; docker buildx inspect --bootstrap; }
	docker buildx inspect | grep 'Name:' | grep 'multiarch-builder' > /dev/null || { docker buildx use multiarch-builder; docker buildx inspect --bootstrap; }

# ECR does not support HEAD on digest-only (untagged) manifests.
# Push each platform with an explicit tag, then assemble the manifest list.
image-build-and-push-multi-arch: _prepare-multiarch code-build-multi-arch
	@echo "[image-build-and-push-multi-arch] Building Docker image (cross platform multi-arch): $(PROJECT_IMAGE)"
	docker buildx build \
		--platform linux/amd64 \
		--provenance=false \
		--push \
		--tag $(PROJECT_IMAGE)-amd64 \
		--file cmd/$(CMD)/Dockerfile \
		-- cmd/$(CMD)
	docker buildx build \
		--platform linux/arm64 \
		--provenance=false \
		--push \
		--tag $(PROJECT_IMAGE)-arm64 \
		--file cmd/$(CMD)/Dockerfile \
		-- cmd/$(CMD)
	docker buildx imagetools create \
		--tag $(PROJECT_IMAGE) \
		$(PROJECT_IMAGE)-amd64 \
		$(PROJECT_IMAGE)-arm64

build: image-build-and-push-multi-arch
