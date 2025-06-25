# NixPress: A Modern WordPress Development Environment

This project provides a fully containerized and reproducible WordPress development environment using Nix, Podman, and Direnv.

### Prerequisites

1.  **Nix:** Must be installed with Flakes enabled.
2.  **Direnv:** Must be installed and hooked into your shell.
3.  **Podman:** The container engine.

### First-Time Setup

1.  **Clone the Repository:**
    ```bash
    git clone <your-repo-url> my-new-site
    cd my-new-site
    ```

2.  **Configure Environment:** Copy the template `.envrc` file and customize it for your project.
    ```bash
    cp .envrc.template .envrc
    ```
    Now, edit `.envrc` to set your `COMPOSE_PROJECT_NAME`, database passwords, and any API keys like `ACF_PRO_KEY`.

3.  **Allow Direnv:** Authorize `direnv` to load the environment variables.
    ```bash
    direnv allow
    ```

4.  **Enter the Nix Shell:** This will download all the necessary tools like `podman-compose`.
    ```bash
    nix develop
    ```

5.  **Start the Services:** Build the custom image and launch all the containers.
    ```bash
    make start
    ```
    The first time you run this, it will take a few minutes to download and build the WordPress image. Subsequent starts will be much faster.

6.  **Run WordPress Setup:** After the containers are running, visit `http://localhost:8080` in your browser to complete the famous WordPress 5-minute installation.

7.  **Install Recommended Plugins:** Use the built-in `make` command to automatically install plugins like WPGraphQL.
    ```bash
    make setup
    ```

### Daily Usage

-   **Start environment:** `make start`
-   **Stop environment:** `make stop`
-   **View logs:** `make logs`
-   **Restart:** `make restart`

Your WordPress files are located in the `./src` directory. You can now start developing your theme or plugin.
