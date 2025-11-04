## 2. 完整介绍 (Chinese Version)

### UvIntrov3 概述

**UvIntrov3** 引入了一个名为 **`my-uv`** 的精简命令行界面包装器，专为使用高效的 **`uv`** 工具管理 Python 虚拟环境而设计。这套增强型工具集通过单一、直观的命令及其多个子命令和便捷别名，提供了完整的环境管理解决方案。

此版本的核心改进在于**统一的命令行界面**，遵循现代 CLI 约定。当您使用适当的子命令运行 `my-uv` 时，它为所有环境管理任务提供了一致且用户友好的体验。

### 主要特点

1. **统一命令结构**：所有操作均通过 `my-uv` 命令后跟特定子命令完成
2. **命令别名**：简短别名（如 `a` 代表 `activate`）以加快工作流程
3. **友好输出**：彩色编码的控制台消息，提高可视性和用户体验
4. **环境变量管理**：自动设置和清除关键环境变量
5. **内置帮助系统**：通过 `my-uv help` 访问全面的帮助文档

### AI大模型开发环境使用流程

对于AI大模型开发，请遵循以下标准化流程：

1. **查看可用环境**: `my-uv list`（或 `my-uv l`）
2. **激活实验环境**: `my-uv activate {experimentname}`（或 `my-uv a {experimentname}`）
3. **运行脚本**: 在激活的环境中使用标准 `uv run` 命令

例如：
```powershell
my-uv list
my-uv activate AIPS1
uv run train_model.py
```

### 前置准备与配置

在使用 `my-uv` 命令之前，必须完成以下关键的配置步骤：

1. **配置中央环境目录（`UV_ENVS_DIR`）**:
   * 设置系统环境变量 **`UV_ENVS_DIR`**，指定所有 UV 虚拟环境的统一存储路径（例如 `C:\UV_Envs`）。
   * **重要步骤**: 设置环境变量后，必须关闭并重新打开所有活动的 PowerShell 窗口，配置才能生效。

2. **安装脚本**:
   * 将 `my-uv.ps1` 脚本放置在 PATH 环境变量包含的目录中，或者
   * 在 PowerShell 配置文件 (`$PROFILE`) 中创建指向脚本位置的别名。
   * 如果遇到权限问题，您可能需要执行一次 `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` 命令。

---

### my-uv 核心命令

| 命令 | 功能描述 | 语法示例 | 关键详情 |
| :--- | :--- | :--- | :--- |
| **`my-uv new`** | 创建一个新的 UV 环境 | `my-uv new myproject` | 支持指定 Python 版本：`my-uv new ml-env 3.9`。别名：`my-uv n` |
| **`my-uv activate`** | 激活已存在的环境 | `my-uv activate myproject` | 设置全局环境变量 `UV_PROJECT_ENVIRONMENT` 和 `UV_PYTHON`。别名：`my-uv a` |
| **`my-uv deactivate`** | 停用当前活动的 UV 环境 | `my-uv deactivate` | 调用原始的 `deactivate` 脚本，并移除 UV 环境变量。别名：`my-uv d` |
| **`my-uv list`** | 查看所有已创建的 UV 环境 | `my-uv list` | 显示在 `UV_ENVS_DIR` 路径下找到的所有环境名称和总数。别名：`my-uv l` |
| **`my-uv delete`** | 删除指定的 UV 环境 | `my-uv delete old-env` | 会提示确认 (Y/N)，并且**不能删除当前处于活动状态的环境**。别名：`my-uv del` |
| **`my-uv help`** | 显示帮助文档 | `my-uv help` | 显示所有命令及其别名的使用信息 |