# VSlike
Learn Godot

## Functions of Nodes

### get_tree()
- 暂停/继续: get_tree().paused = true/false
    - 会暂停所有节点，包括当前ui节点。因此对于ui节点，需要将其Process Mode改为always。
- 切换场景: get_tree().change_scene_to_file(scene_file)
- 退出游戏: get_tree().quit()

### Node2D/CanvasItem
Y Sort Enabled: 根据y坐标决定渲染顺序

