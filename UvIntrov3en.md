## 1. Full Introduction (English Version)

### Overview of UvIntrov3

**UvIntrov3** introduces a streamlined command-line interface wrapper called **`my-uv`** for managing Python virtual environments with the efficient **`uv`** tool. This enhanced toolset provides a complete environment management solution through a single, intuitive command with multiple subcommands and convenient aliases.

The key improvement in this version is the **unified command-line interface** that follows modern CLI conventions. When you run `my-uv` with appropriate subcommands, it provides a consistent and user-friendly experience for all environment management tasks.

### Key Features

1. **Unified Command Structure**: All operations are performed through the `my-uv` command followed by specific subcommands
2. **Command Aliases**: Short aliases (like `a` for `activate`) for faster workflow
3. **Helpful Output**: Color-coded console messages for better visibility and user experience
4. **Environment Variable Management**: Automatic setting and clearing of critical environment variables
5. **Built-in Help System**: Comprehensive help documentation accessible via `my-uv help`

### AI Model Development Environment Usage Flow

For AI model development, follow this standardized process:

1. **View available environments**: `my-uv list` (or `my-uv l`)
2. **Activate experiment environment**: `my-uv activate {experimentname}` (or `my-uv a {experimentname}`)
3. **Run scripts**: Use standard `uv run` commands within the activated environment

Example:
```powershell
my-uv list
my-uv activate AIPS1
uv run train_model.py
```

### Setup and Configuration

Before using the `my-uv` command, you must complete these mandatory setup steps:

1. **Define the Central Environment Directory (`UV_ENVS_DIR`)**:
   * Set the system environment variable **`UV_ENVS_DIR`** to specify where all your UV virtual environments will reside (e.g., `C:\UV_Envs`).
   * **Important**: Close and reopen all active PowerShell windows for the new environment variable to take effect.

2. **Install the Script**:
   * Place the `my-uv.ps1` script in a directory that's in your PATH, or
   * Create an alias in your PowerShell profile (`$PROFILE`) that points to the script location.
   * If you encounter permission issues, you may need to run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` once.

---

### my-uv Core Commands

| Command | Function Description | Syntax Example | Key Details |
| :--- | :--- | :--- | :--- |
| **`my-uv new`** | Creates a new UV environment | `my-uv new myproject` | Supports specifying Python version: `my-uv new ml-env 3.9`. Alias: `my-uv n` |
| **`my-uv activate`** | Activates an existing environment | `my-uv activate myproject` | Sets the global `UV_PROJECT_ENVIRONMENT` and `UV_PYTHON` variables. Alias: `my-uv a` |
| **`my-uv deactivate`** | Deactivates the current environment | `my-uv deactivate` | Calls the original `deactivate` script and removes UV environment variables. Alias: `my-uv d` |
| **`my-uv list`** | Views all created UV environments | `my-uv list` | Displays names and total count of environments in the `UV_ENVS_DIR` path. Alias: `my-uv l` |
| **`my-uv delete`** | Deletes a specified UV environment | `my-uv delete old-env` | Prompts for confirmation (Y/N) and cannot delete an active environment. Alias: `my-uv del` |
| **`my-uv help`** | Shows help documentation | `my-uv help` | Displays usage information for all commands and their aliases |