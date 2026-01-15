#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// v1 文件路径
const files = [
    './en/api-reference/v1/open-v1.json',
    './zh/api-reference/v1/open-v1.json',
    './tw/api-reference/v1/open-v1.json'
];

// 递归删除对象中的 required 字段
function removeRequired(obj) {
    if (typeof obj !== 'object' || obj === null) {
        return;
    }

    if (Array.isArray(obj)) {
        obj.forEach(item => removeRequired(item));
        return;
    }

    // 删除当前对象的 required 字段
    if ('required' in obj) {
        delete obj.required;
    }

    // 递归处理所有属性
    Object.values(obj).forEach(value => removeRequired(value));
}

// 处理每个文件
files.forEach(filePath => {
    const fullPath = path.join(__dirname, filePath);

    try {
        // 读取文件
        const content = fs.readFileSync(fullPath, 'utf8');
        const data = JSON.parse(content);

        // 处理 responses 部分
        if (data.paths) {
            Object.values(data.paths).forEach(pathItem => {
                Object.values(pathItem).forEach(operation => {
                    if (operation.responses) {
                        removeRequired(operation.responses);
                    }
                });
            });
        }

        // 写回文件（保持格式化）
        fs.writeFileSync(fullPath, JSON.stringify(data, null, 2), 'utf8');

        console.log(`✅ Processed: ${filePath}`);
    } catch (error) {
        console.log(`⚠️  Skipped: ${filePath} (${error.message})`);
    }
});

console.log('\n🎉 V1 files processing completed!');
