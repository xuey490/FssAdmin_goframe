# FssAdmin 后台管理系统 SoybeanAdmin 适配版

---

<p align="left">
  基于 <a href="https://github.com/soybeanjs/soybean-admin">Soybean Admin</a> 二次开发的 FssAdmin 管理系统的前端<br/>
  对接 FssPHP框架自研后端 API，提供企业级中后台完整解决方案, 跟FssAdmin(Art Design Pro适配版）两个前端共用一个后台。
</p>

<p align="center">
  <a href="https://v4.phpframe.org/">在线演示</a> ·
  <a href="#快速开始">快速开始</a> ·
  <a href="#功能模块">功能模块</a> ·
  <a href="#目录结构">目录结构</a> ·
  <a href="README.en.md">English</a>
</p>

---

## 项目介绍

**FssAdmin 后台管理系统 SoybeanAdmin 适配版** 是 FssAdmin 全栈 monorepo 中的 **Soybean Admin 前端工程**，基于 [Soybean Admin Element Plus 版](https://github.com/soybeanjs/soybean-admin)（`@sa/elp`）深度定制，搭配 **FssAdmin 后端** 程序使用。

本前端采用前后分离架构，通过 REST API 与后端通信，已实现：

- 登录鉴权、Token 刷新、动态菜单与按钮级权限
- 系统管理（用户、角色、部门、岗位、菜单、租户、配置）
- 运维监控（字典、附件、日志、缓存、服务器/Redis 监控、数据库维护）
- 工作流（流程模板、审批、抄送、委托、消息中心、固定表单）
- 开发工具（代码生成、定时任务、插件市场）
- 内容管理（文章 CMS）
- 多租户 SaaS 场景下的菜单与数据隔离

与<a href="https://github.com/xuey490/FssAdmin">FssAdmin</a> 仓库中的 `web/`（Art Design Pro 版）**共用同一套后端 API**，可按团队 UI 偏好选择其一或双端并行维护。

### 为什么选择本版本

| 特点 | 说明 |
|------|------|
| 清新简洁 | 继承 Soybean Admin 的布局与主题体系，开箱即用 |
| 类型安全 | 全量 TypeScript + 自动导入，开发体验友好 |
| 路由自动化 | `@elegant-router/vue` 文件路由 + 后端菜单动态注册 |
| 请求统一 | `@sa/axios` 封装，自动携带 JWT、统一解包 `data` |
| 业务完备 | 已对接 FssAdmin 全模块 API，非空壳模板 |
| 工作流可视化 | 集成 `@antflow design , @vue-flow` 流程设计器与审批组件 |

### 在线演示

- 地址：https://v4.phpframe.org/
- 账号：`admin`
- 密码：`123456`

> 演示环境需配合后端服务；本地开发请先启动 FssAdmin 后端，再启动本前端。

---

## 技术栈

### 核心框架

| 类别 | 技术 | 版本 | 说明 |
|------|------|------|------|
| 脚手架 | Soybean Admin Element Plus | 1.4.x | `@sa/elp` |
| 框架 | Vue.js | 3.5.x | Composition API + `<script setup>` |
| 构建 | Vite (rolldown-vite) | 7.3.x | 开发默认端口 **9527** |
| 语言 | TypeScript | 5.9.x | 严格类型检查 |
| UI | Element Plus | ^2.13 | 组件库 |
| 样式 | UnoCSS + Sass | 66.x | 原子化 CSS + 局部样式 |
| 状态 | Pinia | 3.0.x | 模块化 Store |
| 路由 | vue-router + elegant-router | 5.0.x | 静态路由 + 后端动态路由 |
| 国际化 | vue-i18n | 11.x | 中英文切换 |
| HTTP | @sa/axios | workspace | 主请求层（JWT、刷新、错误处理） |
| 工具 | @vueuse/core | 14.x | 组合式工具库 |

### 业务与扩展

| 类别 | 技术 | 用途 |
|------|------|------|
| 图表 | ECharts、@antv/g2、@visactor/vchart | 仪表盘与数据可视化 |
| 富文本 | @wangeditor/editor、md-editor-v3、vditor | 文章与表单编辑 |
| 工作流 | @vue-flow/core | BPMN 风格流程设计 |
| 表格/甘特 | @visactor/vue-vtable、dhtmlx-gantt | 高级表格与排期 |
| 图标 | @iconify/vue | 海量图标 + 本地 SVG |
| 包管理 | pnpm workspace | `@sa/*`  monorepo 子包 |

### 运行环境

| 软件 | 版本要求 |
|------|----------|
| Node.js | >= 20.19.0 |
| pnpm | >= 8.7.0 |

### 后端依赖（同 monorepo 根目录）

本前端**不能独立运行**，需配合 FssAdmin 后端https://github.com/xuey490/FssAdmin：

| 类别 | 技术 |
|------|------|
| PHP | >= 8.3 |
| 数据库 | MySQL / MariaDB >= 8.0 |
| 缓存 | Redis >= 6.0 |
| 认证 | JWT + Casbin RBAC |
| API 前缀 | `/api/core`、`/api/system`、`/api/flow`、`/api/tool` 等 |

后端安装与数据库导入请参考仓库根目录 [README.md](../README.md)。

---

## 功能模块

### 仪表盘

- 工作台（统计 / 办公双模式）
- 分析页、电子商务、HRM 看板
- 个人中心、赞助支持

### 系统管理

- 用户管理（分配角色、分配菜单、重置密码、工作台设置）
- 角色管理（菜单权限、按钮权限）
- 部门管理（树形结构）
- 岗位管理
- 菜单管理
- 租户管理（多租户 SaaS）
- 系统配置（分组键值）

### 运维管理

- 数据字典
- 附件管理
- 登录日志 / 操作日志 / 邮件日志
- 缓存管理
- 服务监控 / Redis 监控
- 数据表维护与回收站

### 工作流

- 流程分类、流程模板、流程设计器
- 我的发起、待办审批、已办审批、抄送给我
- 流程中心、消息中心、流程委托
- 固定表单（请假、报销、采购等）

### 开发工具

- 代码生成器（CRUD 一键生成）
- 定时任务
- 插件市场

### 内容管理

- 文章列表与分类
- 富文本编辑、Banner 管理

---

## 快速开始

### 1. 准备后端

在 monorepo **根目录**完成以下步骤（若已部署可跳过）：

```bash
# 安装 PHP 依赖
composer install

# 配置 .env（数据库、Redis、JWT 等）
cp .env.example .env

# 导入数据库
mysql -u root -p your_database < database/fssoa.sql

# 启动后端（任选其一）
php -S 127.0.0.1:8000 -t public
# 或 Workerman：php start.php start
```

默认后端地址：`http://127.0.0.1:8000`

### 2. 安装前端依赖

```bash
cd back
pnpm install
```

### 3. 配置环境变量

开发环境主要编辑 `.env` 与 `.env.test`：

```env
# 应用标题
VITE_APP_TITLE=FssAdmin

# 后端 API 地址（开发代理目标）
VITE_SERVICE_BASE_URL=http://127.0.0.1:8000
VITE_SERVICE_PROXY_TARGET=http://127.0.0.1:8000

# 开发模式启用 HTTP 代理
VITE_HTTP_PROXY=Y

# 后端成功业务码（NovaPHP 约定为 200）
VITE_SERVICE_SUCCESS_CODE=200

# 路由模式：history | hash
VITE_ROUTER_HISTORY_MODE=history

# 静态路由模式下首页 routeKey
VITE_ROUTE_HOME=console

# 鉴权路由模式：static | dynamic
VITE_AUTH_ROUTE_MODE=static
```

### 4. 启动开发服务器

```bash
pnpm dev
```

浏览器访问：**http://localhost:9527**

默认登录接口：`POST /api/core/login`

### 5. 生产构建

```bash
# 类型检查 + 构建
pnpm build

# 本地预览构建产物
pnpm preview
```

构建产物输出至 `back/dist/`，由 Nginx 等静态服务器托管，并将 `/api` 反向代理至 PHP 后端。

---

## 目录结构

```
back/
├── build/                  # Vite 插件与构建配置
├── packages/               # @sa/* workspace 子包（axios、hooks、utils…）
├── public/                 # 静态资源
├── src/
│   ├── assets/             # 图片、样式资源
│   ├── components/         # 全局组件（flow 设计器、custom 业务组件等）
│   ├── layouts/            # 布局（侧边栏、顶栏、标签页）
│   ├── locales/            # 国际化语言包
│   ├── router/
│   │   ├── elegant/        # elegant-router 生成路由
│   │   └── dynamic/        # 后端菜单动态路由注册
│   ├── service/
│   │   ├── api/            # 按模块划分的 API 封装
│   │   └── request/        # @sa/axios 实例与拦截器
│   ├── store/modules/      # Pinia 模块（auth、route、tab…）
│   ├── theme/              # 主题与布局配置
│   ├── views/              # 页面视图
│   │   ├── console/        # 默认首页工作台
│   │   ├── dashboard/      # 仪表盘子页
│   │   ├── system/         # 系统管理
│   │   ├── safeguard/      # 运维管理
│   │   ├── flow/           # 工作流
│   │   ├── tool/           # 开发工具
│   │   └── article-manage/ # 文章 CMS
│   └── main.ts
├── .env                    # 基础环境变量
├── .env.test               # 开发/测试环境
├── .env.prod               # 生产环境
├── vite.config.ts          # Vite 配置（dev 端口 9527）
└── package.json
```

---

## 开发说明

### API 对接约定

后端统一响应格式：

```json
{
  "code": 200,
  "msg": "ok",
  "message": "ok",
  "data": {}
}
```

- 业务成功：`code === 200`（与 `VITE_SERVICE_SUCCESS_CODE` 一致）
- 请求头：`Authorization: Bearer {access_token}`
- 字段命名：后端多为 **snake_case**（如 `create_time`、`dept_id`）

主要 API 分组：

| 前缀 | 说明 |
|------|------|
| `/api/core/` | 登录、用户信息、菜单、权限、上传、监控 |
| `/api/system/` | 用户、角色、部门、菜单、租户、岗位 |
| `/api/flow/` | 工作流引擎 |
| `/api/tool/` | 代码生成、定时任务 |
| `/api/article*` | 文章 CMS |

API 封装位于 `src/service/api/`，新增模块时请保持与后端 Controller 路径一致。

### 路由与权限

- **静态路由**：`pnpm gen-route` 根据 `src/views` 生成 elegant-router 路由
- **动态路由**：登录后从 `/api/core/system/menu` 拉取菜单，由 `router/dynamic/` 注册
- **按钮权限**：后端 `Permission` 注解 slug（如 `core:user:save`）与菜单表 `type=3` 按钮对应
- **首页**：`.env` 中 `VITE_ROUTE_HOME=console` 对应 `/console` 工作台

### 常用脚本

```bash
pnpm dev          # 开发（test 模式，带代理）
pnpm dev:prod     # 开发（prod 模式配置）
pnpm build        # 生产构建
pnpm lint         # ESLint 修复
pnpm typecheck    # TypeScript 类型检查
pnpm gen-route    # 重新生成 elegant-router 路由
```

### 新增页面建议流程

1. 在 `src/views/{module}/` 新建页面组件
2. 在 `src/service/api/` 添加接口封装
3. 执行 `pnpm gen-route`（静态路由场景）或在后端菜单表配置动态路由
4. 配置 Casbin / 菜单按钮权限 slug

---

## 部署建议

### Nginx 静态 + API 反代示例

```nginx
server {
    listen 80;
    server_name admin.example.com;
    root /path/to/back/dist;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api/ {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 环境切换

| 命令 | 环境文件 | 用途 |
|------|----------|------|
| `pnpm dev` | `.env.test` | 本地开发 |
| `pnpm build` | `.env.prod` | 生产构建 |

生产构建前请确认 `VITE_SERVICE_BASE_URL` 指向正式 API 域名。

---

## 与同仓库其他工程的关系

```
project/                 # FssAdmin monorepo
├── app/                 # PHP 业务层
├── framework/           # NovaPHP 框架核心
├── config/              # 后端配置
├── database/            # SQL 与迁移
├── back/                # ← 本工程（Soybean Admin 前端）
└── web/                 # Art Design Pro 前端（同 API）
```

- 仅需 **Soybean 风格 UI**：使用本 `back/` 工程
- 需要 **Art Design Pro 风格**：使用 `web/` 工程
- 后端改动一次，两前端均可对接（注意分别维护 API 封装层）

---

## 致谢

- [Soybean Admin](https://github.com/soybeanjs/soybean-admin) — 优秀的中后台开源模板
- [Element Plus](https://element-plus.org/) — Vue 3 组件库
- [Vue.js](https://vuejs.org/) / [Vite](https://vitejs.dev/)

---

## 作者与社区

- 作者：blue2004 (xuey863toy)
- 邮箱：xuey863toy@gmail.com
- GitHub：https://github.com/xuey490
- 官方文档：https://v3.phpframe.org/

<p align="center">
  ⭐ 如果这个项目对您有帮助，欢迎 Star 支持！⭐
</p>

---

## License

MIT
