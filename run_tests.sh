#!/bin/bash
# Script to build docker image and run unit tests
# Usage: ./run_tests.sh

set -e

IMAGE_NAME="dag-test"
CONTAINER_NAME="dag-test-container"

echo "========================================="
echo "DAG Unit Test Runner"
echo "PR patches: #2 (Golden solution), #1 (Test_Patch)"
echo "========================================="

# Build the Docker image
echo ""
echo "==> Building Docker image..."
docker build -t "${IMAGE_NAME}" -f Dockerfile .

# Remove existing container if exists
docker rm -f "${CONTAINER_NAME}" 2>/dev/null || true

# Run tests inside the container
echo ""
echo "==> Running unit tests in Docker container..."
docker run --name "${CONTAINER_NAME}" "${IMAGE_NAME}" bash -c '
    set -e
    cd /app
    
    echo "==> Running go test..."
    go test -v ./...
    
    echo ""
    echo "========================================="
    echo "All tests completed!"
    echo "========================================="
'

EXIT_CODE=$?

# Cleanup
docker rm -f "${CONTAINER_NAME}" 2>/dev/null || true

if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Tests passed!"
else
    echo "❌ Tests failed!"
fi

exit $EXIT_CODE
