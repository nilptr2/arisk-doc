#!/usr/bin/env python3
"""
批量將簡體中文文檔轉換為繁體中文（台灣標準）
"""
import opencc
import os
from pathlib import Path

# 創建轉換器
converter = opencc.OpenCC('s2twp')

# 定義目錄
zh_dir = Path('/Users/admin/workspace/Arisk/arisk-doc/zh')
tw_dir = Path('/Users/admin/workspace/Arisk/arisk-doc/tw')

# 需要轉換的文件擴展名
extensions = ['.mdx', '.json', '.md']

# 統計
total = 0
success = 0
failed = 0

print("🚀 開始批量轉換簡體中文到繁體中文（台灣標準）\n")

# 遍歷 zh 目錄下的所有文件
for ext in extensions:
    for source_file in zh_dir.rglob(f'*{ext}'):
        # 計算相對路徑
        rel_path = source_file.relative_to(zh_dir)
        target_file = tw_dir / rel_path
        
        total += 1
        
        try:
            # 讀取源文件
            with open(source_file, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # 轉換為繁體中文
            converted = converter.convert(content)
            
            # 確保目標目錄存在
            target_file.parent.mkdir(parents=True, exist_ok=True)
            
            # 寫入目標文件
            with open(target_file, 'w', encoding='utf-8') as f:
                f.write(converted)
            
            success += 1
            print(f"✅ {rel_path}")
            
        except Exception as e:
            failed += 1
            print(f"❌ {rel_path}: {str(e)}")

print(f"\n{'='*60}")
print(f"📊 轉換完成統計")
print(f"{'='*60}")
print(f"總文件數: {total}")
print(f"成功轉換: {success}")
print(f"轉換失敗: {failed}")
print(f"成功率: {success/total*100:.1f}%")
print(f"{'='*60}")
