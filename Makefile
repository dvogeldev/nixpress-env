# Makefile (Corrected plugin slug)

# Default command is 'help'
.DEFAULT_GOAL := help

# Phony targets don't represent files
.PHONY: help setup start stop restart logs install-plugins install-wpgraphql install-faustwp install-acf-pro db-import

help:
	@echo "Usage: make [command]"
	@echo ""
	@echo "Commands:"
	@echo "  setup         Run interactive first-time setup (e.g., install plugins)."
	@echo "  start         Start all services in the background."
	@echo "  stop          Stop all services."
	@echo "  restart       Restart all services."
	@echo "  logs          Follow the logs of all services."
	@echo "  db-import     Import a database. Usage: make db-import FILE=path/to/dump.sql"

setup:
	@read -p "Do you want to install recommended plugins (WPGraphQL, FaustWP, ACF Pro)? [y/N] " choice; \
	case "$$choice" in \
	  y|Y ) \
	    echo "✅ Proceeding with plugin installation..."; \
	    $(MAKE) install-plugins; \
	    ;; \
	  * ) \
	    echo "Skipping plugin installation."; \
	    ;; \
	esac

start:
	@echo "🚀 Building custom image (if needed) and starting NixPress environment..."
	podman-compose up -d --build

stop:
	@echo "🛑 Stopping NixPress environment..."
	podman-compose down

restart: stop start

logs:
	@echo "🔎 Following logs... (Press Ctrl+C to stop)"
	podman-compose logs -f

# --- Plugin Installation Targets ---

install-plugins: install-wpgraphql install-faustwp install-acf-pro
	@echo "✅ All requested plugins installed."

install-wpgraphql:
	@echo "-> Installing WPGraphQL..."
	podman exec --user www-data $(COMPOSE_PROJECT_NAME)-wordpress /usr/local/bin/wp plugin install wp-graphql --activate

install-faustwp:
	@echo "-> Installing FaustWP..."
	podman exec --user www-data $(COMPOSE_PROJECT_NAME)-wordpress /usr/local/bin/wp plugin install faustwp --activate

install-acf-pro:
	@if [ -z "$(ACF_PRO_KEY)" ]; then \
		echo "⚠️  Skipping ACF Pro: ACF_PRO_KEY is not set in your .envrc file."; \
	else \
		echo "-> Installing ACF Pro using your license key..."; \
		podman exec --user www-data $(COMPOSE_PROJECT_NAME)-wordpress /usr/local/bin/wp plugin install "https://connect.advancedcustomfields.com/v2/plugins/download?p=pro&k=$(ACF_PRO_KEY)" --activate; \
	fi

# --- Database Management ---

db-import:
	@if [ -z "$(FILE)" ]; then \
		echo "Error: Please provide a file path. Usage: make db-import FILE=path/to/dump.sql"; \
		exit 1; \
	fi
	@echo "🔄 Importing database from $(FILE)..."
	podman exec -i $(COMPOSE_PROJECT_NAME)-db sh -c 'mysql -u root -p"$(DB_ROOT_PASSWORD)" "$(DB_NAME)"' < $(FILE)
	@echo "✅ Database import complete."
