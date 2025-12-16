#!/bin/bash

# Navigate to the script's directory to ensure docker-compose finds the correct files
cd "$(dirname "$0")"

function show_help {
    echo "Usage: ./opencti.sh [command]"
    echo "Commands:"
    echo "  start   - Start the OpenCTI stack (docker compose up -d)"
    echo "  stop    - Stop and remove the OpenCTI stack containers (docker compose down)"
    echo "  down    - Stop and remove containers and networks (docker compose down)"
    echo "  clean   - Stop and remove containers, networks, AND volumes (docker compose down -v)"
    echo "  logs    - View logs (docker compose logs -f)"
}

if [ -z "$1" ]; then
    show_help
    exit 1
fi

case "$1" in
    start)
        echo "Starting OpenCTI..."
        docker compose up -d
        
        if [ -f .env ]; then
            set -a
            source .env
            set +a
        fi

        echo ""
        echo "OpenCTI Platform is accessible at: ${OPENCTI_BASE_URL:-http://localhost:8080}"
        echo "Login with:"
        echo "  User: ${OPENCTI_ADMIN_EMAIL:-admin@opencti.io}"
        echo "  Password: ${OPENCTI_ADMIN_PASSWORD:-changeme}"
        echo ""
        ;;
    stop)
        echo "Stopping OpenCTI and removing containers..."
        # Use `docker compose down` to both stop and remove containers and networks
        docker compose down
        ;;
    down)
        echo "Removing OpenCTI containers and networks..."
        docker compose down
        ;;
    clean)
        echo "Removing OpenCTI containers, networks, and volumes..."
        docker compose down -v
        ;;
    logs)
        docker compose logs -f
        ;;
    *)
        echo "Unknown command: $1"
        show_help
        exit 1
        ;;
esac
