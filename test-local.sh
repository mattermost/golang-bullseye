#!/usr/bin/env bash
set -Eeuo pipefail

# Local testing script - builds and tests images locally
# Usage: ./test-local.sh [version]
#   ./test-local.sh        # Test all versions
#   ./test-local.sh 1.25   # Test specific version

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

if [ "$#" -eq 0 ]; then
	versions="$(jq -r 'keys[]' versions.json)"
else
	versions="$@"
fi

for version in $versions; do
	echo "=========================================="
	echo "Testing version: $version"
	echo "=========================================="
	
	# Generate Dockerfiles if needed
	if [ ! -f "$version/bullseye/Dockerfile" ]; then
		echo "Generating Dockerfile for $version..."
		./apply-templates.sh "$version"
	fi
	
	image="mattermost/golang-bullseye:$version"
	
	# Build the image
	echo "Building $image..."
	docker build \
		-t "$image" \
		-t "mattermost/golang-bullseye:$version-bullseye" \
		-f "$version/bullseye/Dockerfile" \
		"$version/bullseye"
	
	# Test the image
	echo "Testing $image..."
	
	echo "  ✓ Testing go version..."
	docker run --rm "$image" go version
	
	echo "  ✓ Testing go env..."
	docker run --rm "$image" go env GOROOT
	docker run --rm "$image" go env GOPATH
	
	echo "  ✓ Testing go run..."
	docker run --rm "$image" sh -c 'echo "package main; import \"fmt\"; func main() { fmt.Println(\"Hello, World!\") }" > /tmp/hello.go && go run /tmp/hello.go'
	
	echo "  ✓ Testing go build..."
	docker run --rm "$image" sh -c 'echo "package main; import \"fmt\"; func main() { fmt.Println(\"Build test\") }" > /tmp/build.go && go build -o /tmp/test /tmp/build.go && /tmp/test'
	
	echo "✅ All tests passed for $image"
	echo ""
done

echo "=========================================="
echo "All versions tested successfully!"
echo "=========================================="
echo ""
echo "Built images:"
docker images | grep "mattermost/golang-bullseye" || true

