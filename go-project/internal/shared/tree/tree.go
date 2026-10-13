package tree

import "github.com/gogf/gf/v2/util/gconv"

func Build(rows []map[string]interface{}, idKey, pidKey, childKey string) []map[string]interface{} {
	if idKey == "" {
		idKey = "id"
	}
	if pidKey == "" {
		pidKey = "parent_id"
	}
	if childKey == "" {
		childKey = "children"
	}
	byID := map[int]map[string]interface{}{}
	for _, row := range rows {
		id := gconv.Int(row[idKey])
		cp := map[string]interface{}{}
		for k, v := range row {
			cp[k] = v
		}
		byID[id] = cp
	}
	var roots []map[string]interface{}
	for _, row := range rows {
		id := gconv.Int(row[idKey])
		pid := gconv.Int(row[pidKey])
		node := byID[id]
		if pid > 0 {
			if parent, ok := byID[pid]; ok {
				kids, _ := parent[childKey].([]map[string]interface{})
				parent[childKey] = append(kids, node)
				continue
			}
		}
		roots = append(roots, node)
	}
	if roots == nil {
		return []map[string]interface{}{}
	}
	return roots
}
