# 计划

- [ ] 创建文章
- [ ] 发布文章
- [ ] 更新文章
- [ ] 删除文章
- [ ] 创建分类
- [ ] 删除分类
- [ ] 修改分类
- [ ] 创建页头

# 数据结构

```json
// db.json
{
  "posts":[{POST},{POST}, ...],
  "categories":[{CATEGORY},{CATEGORY}, ...]
}

// POST
{
  "id":number,
  "title":string,
  "file":string,
  "md5":string,
  "history_file": array, // ["file1","file2", ...]
  "categoryid":number
}

// CATEGORY
{
  "id":number,
  "title":string,
  "sort":number
}
```