# FssAdmin Admin Console — SoybeanAdmin Edition

---

<p align="center">
  FssAdmin management frontend built on <a href="https://github.com/soybeanjs/soybean-admin">Soybean Admin</a><br/>
  Powered by the FssPHP backend API — a complete enterprise admin solution.<br/>
  Shares one backend with <strong>FssAdmin (Art Design Pro Edition)</strong>.
</p>

<p align="center">
  <a href="https://v4.phpframe.org/">Live Demo</a> ·
  <a href="#quick-start">Quick Start</a> ·
  <a href="#features">Features</a> ·
  <a href="#project-structure">Structure</a> ·
  <a href="README.md">中文</a>
</p>

---

## Overview

**FssAdmin Admin Console — SoybeanAdmin Edition** (`back/`) is the **Soybean Admin frontend** in the FssAdmin full-stack monorepo. It is a tailored fork of [Soybean Admin Element Plus](https://github.com/soybeanjs/soybean-admin) (`@sa/elp`), designed to work with the **FssAdmin backend** at the repository root.

The app follows a decoupled front-end / back-end architecture and communicates with the API over REST. Out of the box it includes:

- Authentication, token refresh, dynamic menus, and button-level permissions
- System administration (users, roles, departments, posts, menus, tenants, settings)
- Operations & monitoring (dictionaries, attachments, logs, cache, server/Redis metrics, database tools)
- Workflow (templates, approvals, CC, delegation, message center, fixed forms)
- Developer tools (code generator, scheduled tasks, plugin marketplace)
- Content management (article CMS)
- Multi-tenant SaaS menu and data isolation

It shares the **same backend API** as the `web/` package (Art Design Pro edition) in the [FssAdmin repository](https://github.com/xuey490/FssAdmin)—choose the UI that fits your team, or maintain both frontends in parallel.

### Why this edition

| Highlight | Description |
|-----------|-------------|
| Clean & minimal | Soybean Admin layouts and theming, ready to use |
| Type-safe | Full TypeScript with auto-imports for a smooth developer experience |
| Routing automation | `@elegant-router/vue` file-based routes + backend-driven menu registration |
| Unified HTTP layer | `@sa/axios` with JWT injection and consistent `data` unwrapping |
| Production-ready | Wired to FssAdmin APIs across all modules—not a bare template |
| Visual workflow | `@vue-flow` designer and approval UI components |

### Live demo

- URL: https://v4.phpframe.org/
- Username: `admin`
- Password: `123456`

> The demo requires the backend service. For local development, start the FssAdmin backend first, then this frontend.

---

## Tech Stack

### Core

| Category | Technology | Version | Notes |
|----------|------------|---------|-------|
| Scaffold | Soybean Admin Element Plus | 1.4.x | `@sa/elp` |
| Framework | Vue.js | 3.5.x | Composition API + `<script setup>` |
| Build | Vite (rolldown-vite) | 7.3.x | Dev server on port **9527** |
| Language | TypeScript | 5.9.x | Strict type checking |
| UI | Element Plus | ^2.13 | Component library |
| Styling | UnoCSS + Sass | 66.x | Atomic CSS + scoped styles |
| State | Pinia | 3.0.x | Modular stores |
| Routing | vue-router + elegant-router | 5.0.x | Static + backend-driven routes |
| i18n | vue-i18n | 11.x | Chinese / English |
| HTTP | @sa/axios | workspace | JWT, refresh, error handling |
| Utilities | @vueuse/core | 14.x | Composition utilities |

### Business & extensions

| Category | Technology | Use case |
|----------|------------|----------|
| Charts | ECharts, @antv/g2, @visactor/vchart | Dashboards and data visualization |
| Rich text | @wangeditor/editor, md-editor-v3, vditor | Articles and form editing |
| Workflow | @vue-flow/core | BPMN-style process design |
| Tables / Gantt | @visactor/vue-vtable, dhtmlx-gantt | Advanced grids and scheduling |
| Icons | @iconify/vue | Icon sets + local SVG |
| Package manager | pnpm workspace | `@sa/*` monorepo packages |

### Runtime requirements

| Software | Version |
|----------|---------|
| Node.js | >= 20.19.0 |
| pnpm | >= 8.7.0 |

### Backend dependency (monorepo root)

This frontend **does not run standalone**. It requires the [FssAdmin backend](https://github.com/xuey490/FssAdmin):

| Category | Technology |
|----------|------------|
| PHP | >= 8.3 |
| Database | MySQL / MariaDB >= 8.0 |
| Cache | Redis >= 6.0 |
| Auth | JWT + Casbin RBAC |
| API prefixes | `/api/core`, `/api/system`, `/api/flow`, `/api/tool`, etc. |

For backend setup and database import, see the root [README.md](../README.md).

---

## Features

### Dashboard

- Console (statistics / workspace modes)
- Analytics, e-commerce, HRM boards
- User center, sponsorship page

### System administration

- Users (role assignment, menu assignment, password reset, workspace settings)
- Roles (menu and button permissions)
- Departments (tree structure)
- Posts, menus, tenants (multi-tenant SaaS)
- System configuration (grouped key-value settings)

### Operations

- Data dictionaries
- Attachments
- Login, operation, and email logs
- Cache management
- Server and Redis monitoring
- Database maintenance and recycle bin

### Workflow

- Categories, templates, visual designer
- My submissions, pending/completed approvals, CC inbox
- Workflow hub, message center, delegation
- Fixed forms (leave, expense, procurement, etc.)

### Developer tools

- CRUD code generator
- Scheduled tasks (crontab)
- Plugin marketplace

### Content management

- Articles and categories
- Rich-text editing and banner management

---

## Quick Start

### 1. Prepare the backend

At the **monorepo root** (skip if already deployed):

```bash
# Install PHP dependencies
composer install

# Configure .env (database, Redis, JWT, etc.)
cp .env.example .env

# Import the database
mysql -u root -p your_database < database/fssoa.sql

# Start the backend (either option)
php -S 127.0.0.1:8000 -t public
# Or Workerman: php start.php start
```

Default backend URL: `http://127.0.0.1:8000`

### 2. Install frontend dependencies

```bash
cd back
pnpm install
```

### 3. Configure environment variables

For development, edit `.env` and `.env.test`:

```env
# App title
VITE_APP_TITLE=FssAdmin

# Backend API URL (dev proxy target)
VITE_SERVICE_BASE_URL=http://127.0.0.1:8000
VITE_SERVICE_PROXY_TARGET=http://127.0.0.1:8000

# Enable HTTP proxy in dev
VITE_HTTP_PROXY=Y

# Backend success code (FssPHP / NovaPHP convention: 200)
VITE_SERVICE_SUCCESS_CODE=200

# Router mode: history | hash
VITE_ROUTER_HISTORY_MODE=history

# Home route key in static route mode
VITE_ROUTE_HOME=console

# Auth route mode: static | dynamic
VITE_AUTH_ROUTE_MODE=static
```

### 4. Start the dev server

```bash
pnpm dev
```

Open **http://localhost:9527** in your browser.

Default login endpoint: `POST /api/core/login`

### 5. Production build

```bash
# Type check + build
pnpm build

# Preview the production bundle locally
pnpm preview
```

Output goes to `back/dist/`. Serve it with Nginx (or similar) and reverse-proxy `/api` to the PHP backend.

---

## Project Structure

```
back/
├── build/                  # Vite plugins and build config
├── packages/               # @sa/* workspace packages (axios, hooks, utils…)
├── public/                 # Static assets
├── src/
│   ├── assets/             # Images and styles
│   ├── components/         # Global components (flow designer, custom widgets…)
│   ├── layouts/            # Shell layout (sidebar, header, tabs)
│   ├── locales/            # i18n message files
│   ├── router/
│   │   ├── elegant/        # Routes generated by elegant-router
│   │   └── dynamic/        # Backend menu → route registration
│   ├── service/
│   │   ├── api/            # API modules by domain
│   │   └── request/        # @sa/axios instance and interceptors
│   ├── store/modules/      # Pinia modules (auth, route, tab…)
│   ├── theme/              # Theme and layout settings
│   ├── views/              # Page views
│   │   ├── console/        # Default home / console
│   │   ├── dashboard/      # Dashboard sub-pages
│   │   ├── system/         # System admin
│   │   ├── safeguard/      # Operations
│   │   ├── flow/           # Workflow
│   │   ├── tool/           # Developer tools
│   │   └── article-manage/ # Article CMS
│   └── main.ts
├── .env                    # Base env vars
├── .env.test               # Dev / test
├── .env.prod               # Production
├── vite.config.ts          # Vite config (dev port 9527)
└── package.json
```

---

## Development Guide

### API contract

Standard backend response shape:

```json
{
  "code": 200,
  "msg": "ok",
  "message": "ok",
  "data": {}
}
```

- Success: `code === 200` (must match `VITE_SERVICE_SUCCESS_CODE`)
- Header: `Authorization: Bearer {access_token}`
- Field names: backend uses **snake_case** (e.g. `create_time`, `dept_id`)

Main API groups:

| Prefix | Purpose |
|--------|---------|
| `/api/core/` | Login, user info, menus, permissions, upload, monitoring |
| `/api/system/` | Users, roles, departments, menus, tenants, posts |
| `/api/flow/` | Workflow engine |
| `/api/tool/` | Code generator, scheduled tasks |
| `/api/article*` | Article CMS |

API wrappers live in `src/service/api/`. Keep paths aligned with backend controllers when adding modules.

### Routing & permissions

- **Static routes**: `pnpm gen-route` generates elegant-router entries from `src/views`
- **Dynamic routes**: After login, menus from `/api/core/system/menu` are registered via `router/dynamic/`
- **Button permissions**: Backend `Permission` slug (e.g. `core:user:save`) maps to menu rows with `type=3`
- **Home page**: `VITE_ROUTE_HOME=console` → `/console` workspace

### Common scripts

```bash
pnpm dev          # Dev server (test mode, with proxy)
pnpm dev:prod     # Dev with prod env config
pnpm build        # Production build
pnpm lint         # ESLint with auto-fix
pnpm typecheck    # TypeScript check
pnpm gen-route    # Regenerate elegant-router routes
```

### Adding a new page

1. Create the view under `src/views/{module}/`
2. Add API wrappers in `src/service/api/`
3. Run `pnpm gen-route` (static routes) or register a backend menu entry (dynamic routes)
4. Configure Casbin / menu button permission slugs

---

## Deployment

### Nginx: static frontend + API proxy

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

### Environment profiles

| Command | Env file | Purpose |
|---------|----------|---------|
| `pnpm dev` | `.env.test` | Local development |
| `pnpm build` | `.env.prod` | Production build |

Before building for production, set `VITE_SERVICE_BASE_URL` to your live API origin.

---

## Relationship to other packages in the repo

```
project/                 # FssAdmin monorepo
├── app/                 # PHP application layer
├── framework/           # FssPHP / NovaPHP framework core
├── config/              # Backend configuration
├── database/            # SQL dumps and migrations
├── back/                # ← This project (Soybean Admin frontend)
└── web/                 # Art Design Pro frontend (same API)
```

- Prefer **Soybean Admin UI** → use `back/`
- Prefer **Art Design Pro UI** → use `web/`
- Backend changes apply to both frontends; maintain each frontend’s API layer separately

---

## Acknowledgements

- [Soybean Admin](https://github.com/soybeanjs/soybean-admin) — Elegant open-source admin template
- [Element Plus](https://element-plus.org/) — Vue 3 component library
- [Vue.js](https://vuejs.org/) / [Vite](https://vitejs.dev/)

---

## Author & Community

- Author: blue2004 (xuey863toy)
- Email: xuey863toy@gmail.com
- GitHub: https://github.com/xuey490
- Documentation: https://v3.phpframe.org/

<p align="center">
  ⭐ If this project helps you, a Star is much appreciated! ⭐
</p>

---

## License

MIT
