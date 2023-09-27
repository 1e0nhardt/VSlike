# VSlike
Learn Godot  
https://www.udemy.com/course/create-a-complete-2d-arena-survival-roguelike-game-in-godot-4/

## 约定

### 代码组织顺序
1. 继承/类名
2. 信号
3. 常量
4. @export
5. @onready
6. 脚本变量
6. 脚本函数
7. 信号处理函数


## 节点主要功能

### get_tree()
- 暂停/继续: get_tree().paused = true/false
    - 会暂停所有节点，包括当前ui节点。因此对于ui节点，需要将其Process Mode改为always。
- 切换场景: get_tree().change_scene_to_file(scene_file)
- 退出游戏: get_tree().quit()

### Node2D/CanvasItem
Y Sort Enabled: 根据y坐标决定渲染顺序

### tilemap
1. setup: 选择要用的tile
2. paint properties
    - 设置填充属性
    - 设置物理碰撞


## 基础机制

### 碰撞检测
- 线段是否检测到和Collision Layer中物体的碰撞。
- 返回一个字典。
- 未检测到碰撞: result.is_empty() == true
```python
var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
```

### 程序动画
```python
func _ready():
    var tween = create_tween() # 自动绑定当前节点
    # callable, from, to, duration
    tween.tween_method(tween_method, 0.0, 2.0, 2)
    # 在结束时调用queue_free方法
    tween.tween_callback(queue_free)

func tween_method(input_value: float):
    # input_value = t/duration * (to - from) + from
    pass
```
