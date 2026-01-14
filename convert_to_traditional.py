#!/usr/bin/env python3
import opencc

# 创建简体转繁体的转换器（台湾标准）
converter = opencc.OpenCC('s2twp')

# 从简体中文版本读取
source_file = '/Users/admin/workspace/Arisk/arisk-doc/zh/api-reference/v2/open-v2.json'
target_file = '/Users/admin/workspace/Arisk/arisk-doc/tw/api-reference/v2/open-v2.json'

print(f"📖 正在读取简体中文版本：{source_file}")
with open(source_file, 'r', encoding='utf-8') as f:
    content = f.read()

print("🔄 正在转换为繁体中文（台湾标准）...")
converted_content = converter.convert(content)

print(f"💾 正在写入繁体中文版本：{target_file}")
with open(target_file, 'w', encoding='utf-8') as f:
    f.write(converted_content)

print("✅ 转换完成！")
