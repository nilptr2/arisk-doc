# Arisk 文档

本仓库包含了 Arisk 的文档，使用 [Mintlify](https://mintlify.com/) 构建。文档提供中文（zh）和英文（en）两个版本。

## 目录

- [前置要求](#前置要求)
- [快速开始](#快速开始)
- [项目结构](#项目结构)
- [配置说明](#配置说明)
- [内容编写](#内容编写)
- [API 文档](#api-文档)
- [多语言支持](#多语言支持)
- [常见任务](#常见任务)
- [部署](#部署)
- [资源链接](#资源链接)

## 前置要求（仅本地预览需要）

- 已安装 Node.js 18+
- Mintlify CLI（`npm i -g mintlify`）

## 快速开始

### 1. 安装依赖

```bash
npm install -g mintlify
```

### 2. 运行开发服务器

```bash
mint dev
```

这将在 `http://localhost:3000` 启动本地开发服务器。服务器支持热重载，对文档的更改会立即反映。

### 3. 部署文档

推荐使用 Mintlify 托管文档，只需要在个人账号下创建一个项目，绑定对应的github仓库，后续对于仓库的提交都将自动更新文档。关于如何绑定github仓库，可以参考 [Mintlify 文档](https://www.mintlify.com/docs/zh/deploy/github)。

## 项目结构

```
arisk-doc/
├── docs.json              # 主配置文件
├── zh/                    # 中文文档
│   ├── index.mdx         # 首页
│   ├── quickstart.mdx    # 快速入门指南
│   ├── api-reference/    # API 文档
│   │   ├── openapi.json  # OpenAPI 规范（中文）
│   │   └── endpoint/     # 各个 API 端点页面
│   └── updatelog/        # 更新日志
├── en/                    # 英文文档
│   ├── index.mdx
│   ├── quickstart.mdx
│   ├── api-reference/
│   │   ├── openapi.json  # OpenAPI 规范（英文）
│   │   └── endpoint/
│   └── updatelog/
├── logo/                  # Logo 资源
│   ├── light.svg
│   └── dark.svg
└── favicon.svg
```

### 文件命名规范

- 文件名使用小写字母和连字符：`quick-start.mdx`
- MDX 文件应使用 `.mdx` 扩展名
- 将资源文件（图片、Logo 等）放在适当的目录中

## 配置说明

### docs.json

`docs.json` 文件是 Mintlify 文档的核心配置文件，它控制：

- 站点元数据（名称、颜色、图标、Logo）
- 导航结构
- 多语言支持
- 标签页和页面组织
- 页脚配置
- 其他配置可参考 [Mintlify 文档](https://www.mintlify.com/docs/zh/organize/settings)

#### 基本结构

```json
{
  "$schema": "https://mintlify.com/docs.json",
  "name": "您的文档名称",
  "theme": "willow",
  "colors": {
    "primary": "#0066FF",
    "light": "#3B82F6",
    "dark": "#2563EB"
  },
  "logo": {
    "light": "/logo/light.svg",
    "dark": "/logo/dark.svg"
  },
  "favicon": "/favicon.svg",
  "navigation": {
    // 导航结构在这里
  }
}
```

#### 导航结构

导航通过 **语言（languages）**、**标签页（tabs）**、**分组（groups）** 和 **页面（pages）** 进行组织：

```json
"navigation": {
  "languages": [
    {
      "language": "zh",
      "tabs": [
        {
          "tab": "指南",
          "groups": [
            {
              "group": "快速开始",
              "pages": [
                "zh/index",
                "zh/quickstart"
              ]
            }
          ]
        }
      ]
    }
  ]
}
```

**核心概念：**

- **Languages（语言）**：定义不同的语言版本（如 `zh`、`en`）
- **Tabs（标签页）**：顶层导航项（如指南、API 参考、更新日志）
- **Groups（分组）**：标签页内的分组，用于组织相关页面
- **Pages（页面）**：单个文档页面（相对于项目根目录的路径，**不包含** `.mdx` 扩展名）

#### 添加新页面

1. 在适当的目录中创建 MDX 文件（如 `zh/new-page.mdx`）
2. 在 `docs.json` 的相应分组中添加页面路径：

```json
{
  "group": "快速开始",
  "pages": [
    "zh/index",
    "zh/quickstart",
    "zh/new-page"  // 在这里添加
  ]
}
```

#### 颜色自定义

自定义文档的配色方案：

```json
"colors": {
  "primary": "#0066FF",    // 主品牌色
  "light": "#3B82F6",      // 浅色模式强调色
  "dark": "#2563EB",       // 深色模式强调色
  "background": {
    "light": "#FFFFFF",
    "dark": "#0D1117"
  }
}
```

## 内容编写

### MDX 文件

Mintlify 使用 MDX（Markdown + JSX），允许在 Markdown 中使用 React 组件。

#### 基本结构

```mdx
---
title: "页面标题"
description: "用于 SEO 的页面描述"
---

# 主标题

您的内容...
```

#### 前置元数据（Frontmatter）

必需的前置元数据字段：

```yaml
---
title: "页面标题"              # 必需：页面标题
description: "页面描述"        # 必需：Meta 描述
---
```

可选字段：

```yaml
---
title: "页面标题"
description: "页面描述"
icon: "rocket"                # 导航图标
iconType: "solid"             # 图标样式：solid, regular, brands
sidebarTitle: "简短标题"      # 覆盖侧边栏显示名称
keywords: ["关键词1", "关键词2"] # 搜索关键词
---
```

#### 常用组件

**提示框：**

```mdx
<Note>
这是一条信息提示。
</Note>

<Info>
附加信息。
</Info>

<Warning>
警告消息。
</Warning>

<Tip>
实用提示。
</Tip>
```

**卡片：**

```mdx
<Card title="卡片标题" icon="rocket" href="/link">
  卡片内容
</Card>

<CardGroup cols={2}>
  <Card title="卡片 1" icon="shield">
    内容 1
  </Card>
  <Card title="卡片 2" icon="lock">
    内容 2
  </Card>
</CardGroup>
```

**代码块：**

````mdx
```javascript
const example = "代码示例";
```

<CodeGroup>
```javascript JavaScript
const js = "示例";
```

```python Python
py = "示例"
```
</CodeGroup>
````

**标签页：**

```mdx
<Tabs>
  <Tab title="标签 1">
    标签 1 的内容
  </Tab>
  <Tab title="标签 2">
    标签 2 的内容
  </Tab>
</Tabs>
```

**步骤：**

```mdx
<Steps>
  <Step title="第一步">
    先做这个
  </Step>
  <Step title="第二步">
    然后做这个
  </Step>
</Steps>
```

**手风琴：**

```mdx
<AccordionGroup>
  <Accordion title="问题 1">
    答案 1
  </Accordion>
  <Accordion title="问题 2">
    答案 2
  </Accordion>
</AccordionGroup>
```

完整的组件列表，请参阅 [Mintlify 组件文档](https://www.mintlify.com/docs/zh/components/accordions)。

## API 文档

Mintlify 对 OpenAPI/Swagger 规范有出色的支持，允许您自动生成 API 文档。

### OpenAPI 集成

#### 方法 1：在 MDX 中使用 OpenAPI 指令

为每个端点创建单独的 MDX 文件：

**示例：`zh/api-reference/endpoint/analyze-address.mdx`**

```mdx
---
title: "分析地址"
description: "分析单个区块链地址的风险等级"
---

---
openapi: /zh/api-reference/openapi.json post /analyze/address
---
```

**指令格式：**

```
openapi: <OpenAPI-JSON-路径> <HTTP-方法> <端点路径>
```

- `<OpenAPI-JSON-路径>`：OpenAPI 规范文件的路径
- `<HTTP-方法>`：HTTP 方法（get、post、put、delete、patch）
- `<端点路径>`：OpenAPI 规范中定义的 API 端点路径

#### 方法 2：直接在 docs.json 中引用 OpenAPI（传统方法）

也可以在 `docs.json` 中引用整个 OpenAPI 规范：

```json
{
  "tab": "API 参考",
  "openapi": "/api-reference/openapi.json"
}
```

**注意：** 推荐使用方法 1（单独的 MDX 文件），因为它提供了更好的控制：
- 页面标题和描述
- API 参考前后的自定义内容
- 多语言支持
- SEO 优化

### 更新 API 文档

1. **更新 OpenAPI 规范：**

   编辑相应的 OpenAPI JSON 文件：
   - 中文：`zh/api-reference/openapi.json`
   - 英文：`en/api-reference/openapi.json`

2. **OpenAPI 规范结构：**

```json
{
  "openapi": "3.1.0",
  "info": {
    "title": "Arisk API",
    "description": "Arisk 的 API",
    "version": "1.0.0"
  },
  "servers": [
    {
      "url": "https://api.arisk.com/v1",
      "description": "生产服务器"
    }
  ],
  "paths": {
    "/analyze/address": {
      "post": {
        "summary": "分析地址",
        "description": "分析单个区块链地址的风险等级。",
        "requestBody": { ... },
        "responses": { ... }
      }
    }
  },
  "components": {
    "schemas": { ... },
    "securitySchemes": { ... }
  }
}
```

3. **添加新端点：**

   a. 在 OpenAPI 规范中添加端点
   
   b. 创建新的 MDX 文件（如 `zh/api-reference/endpoint/new-endpoint.mdx`）：
   
   ```mdx
   ---
   openapi: /zh/api-reference/openapi.json post /new/endpoint
   ---
   ```
   
   c. 将页面添加到 `docs.json`：
   
   ```json
   {
     "group": "API 参考",
     "pages": [
       "zh/api-reference/endpoint/analyze-address",
       "zh/api-reference/endpoint/new-endpoint"
     ]
   }
   ```

4. **测试您的更改：**

   运行 `mint dev` 并验证 API 文档渲染正确。

### OpenAPI 最佳实践

- **Gozero支持导出openapi.json，可以使用goctl openapi init命令生成openapi.json**
- **使用描述性的摘要和说明** 以获得更好的文档
- **在 `components.schemas` 中定义可重用的模式** 以避免重复
- **在请求/响应体中包含示例**
- **记录所有状态码** 并提供适当的描述
- **使用标签** 按类别组织端点
- **对不同语言保持单独的 OpenAPI 规范**（如果翻译有所不同）
- **对于部分接口，完全使用openapi.json中的描述可能不够，可以在mdx中单独添加组件说明，例如**

  ```mdx
  ---
  openapi: /zh/admin-openapi.json GET /agent/{projectId}/job/{id}
  keywords: [ "代理作业", "状态", "检索", "详情" ]
  ---

  <div id="usage">
    ## 用法
  </div>

  此端点通过代理任务的唯一标识符获取该任务的详细信息和状态。可用于查看先前创建的代理任务的进度、状态和结果。

  <div id="job-details">
    ## 作业详情
  </div>

  响应包含以下信息：

  - 作业执行状态与完成情况
  - branch 信息和拉取请求（PR；亦称“合并请求”/Merge Request）详情
  - 会话 metadata 与时间戳
  ```
- 也可以完全不依赖openapi.json，直接完全编写mdx文件定义端点，这需要自己定义请求参数、响应参数、状态码以及Playground（try it out，参考[Mintlify api-playground](https://mintlify.com/docs/api-playground/)）组件, 这种方式不易维护，但灵活性较高。

更多关于 OpenAPI 的信息，请参阅：
- [Mintlify API 组件](https://www.mintlify.com/docs/zh/api-playground/openapi-setup)
- [OpenAPI 规范](https://spec.openapis.org/oas/latest.html)

## 多语言支持

本文档支持中文（`zh`）和英文（`en`）, 可按照目录结构进行其他语言扩展。

### 文件组织

- **中文内容：** `zh/` 目录
- **英文内容：** `en/` 目录
- **特定语言的 OpenAPI 规范：** `zh/api-reference/openapi.json` 和 `en/api-reference/openapi.json`

### 添加多语言内容

1. **在两个目录中创建内容：**
   - `zh/your-page.mdx`（中文版本）
   - `en/your-page.mdx`（英文版本）

2. **在 `docs.json` 的两个语言部分中添加：**

```json
{
  "navigation": {
    "languages": [
      {
        "language": "zh",
        "tabs": [
          {
            "tab": "指南",
            "groups": [
              {
                "group": "快速开始",
                "pages": ["zh/your-page"]
              }
            ]
          }
        ]
      },
      {
        "language": "en",
        "tabs": [
          {
            "tab": "Guide",
            "groups": [
              {
                "group": "Quick Start",
                "pages": ["en/your-page"]
              }
            ]
          }
        ]
      }
    ]
  }
}
```

### 语言切换

当配置了多种语言时，Mintlify 会在导航中自动提供语言切换器。确保：

- 各语言的页面结构并行
- 内部链接使用特定语言的路径（如 `/zh/quickstart` vs `/en/quickstart`）

### 翻译提示

- 保持各语言的文件名和目录结构一致
- 翻译所有前置元数据（title、description）
- 更新内部链接以指向正确的语言版本
- 翻译 MDX 文件中的自定义内容，但代码示例可以保留英文

## 常见任务

### 添加新的指南页面

1. 创建 MDX 文件：
```bash
touch zh/guides/new-guide.mdx
touch en/guides/new-guide.mdx
```

2. 为两个文件添加前置元数据和内容

3. 更新 `docs.json`：
```json
{
  "group": "快速开始",
  "pages": [
    "zh/index",
    "zh/quickstart",
    "zh/guides/new-guide"
  ]
}
```

### 添加新的 API 端点

1. 更新 OpenAPI 规范（`zh/api-reference/openapi.json` 和 `en/api-reference/openapi.json`）

2. 创建端点 MDX 文件：
```bash
touch zh/api-reference/endpoint/new-endpoint.mdx
touch en/api-reference/endpoint/new-endpoint.mdx
```

3. 添加 openapi 指令：
```mdx
---
openapi: /zh/api-reference/openapi.json post /new/endpoint
---
```

4. 更新 `docs.json` 导航

### 更新首页

直接编辑 `zh/index.mdx` 和 `en/index.mdx`。首页通常包括：
- 产品概述
- 核心功能
- 快速入门链接
- 视觉卡片或提示框

### 更改颜色/主题

编辑 `docs.json` 中的 `colors` 部分：

```json
{
  "colors": {
    "primary": "#您的颜色",
    "light": "#您的浅色",
    "dark": "#您的深色"
  }
}
```

### 添加图片

1. 在项目根目录创建 `images/` 目录
2. 将图片放在那里
3. 在 MDX 中引用：

```mdx
![替代文本](/images/your-image.png)

或使用 Frame 组件：
<Frame>
  <img src="/images/your-image.png" alt="描述" />
</Frame>
```

## 部署

### Mintlify 托管

1. 将更改推送到 GitHub
2. 在 [mintlify.com/dashboard](https://mintlify.com/dashboard) 连接您的仓库
3. Mintlify 将在每次推送到主分支时自动部署

### 自定义域名

在 Mintlify 仪表板的设置 > 域名中配置自定义域名。


## 资源链接

### Mintlify 官方文档

- [Mintlify 快速入门](https://mintlify.com/docs/quickstart)


### 实用工具

- [OpenAPI 编辑器](https://editor.swagger.io/) - 编辑和验证 OpenAPI 规范

### 获取帮助

- [Mintlify 官方文档GitHub仓库](https://github.com/mintlify/docs)
- [Mintlify 支持](mailto:support@mintlify.com)

## 贡献

为文档做贡献时：

1. 创建功能分支
2. 如适用，在两个语言目录中进行更改
3. 使用 `mint dev` 在本地测试
4. 提交带有清晰变更描述的拉取请求

---

**由 Arisk 团队维护**
