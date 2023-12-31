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
    - 会暂停所有节点，包括当前ui节点。
    - 因此对于ui节点，需要将其Process Mode改为always。
    - 其他节点有必要的话，也需要改
- 切换场景: get_tree().change_scene_to_file(scene_file)
- 退出游戏: get_tree().quit()
- get_tree().root.set_input_as_handled() 终止事件冒泡
- 调用Group中所有节点的方法: get_tree().call_group("group_name", "method_name")

### Node2D/CanvasItem
Y Sort Enabled: 根据y坐标决定渲染顺序

### tilemap
1. setup: 选择要用的tile
2. paint properties
    - 设置填充属性
    - 设置物理碰撞

### AnimationPlayer
- player.play("anim_flip_name")
- player.play_backwards("anim_flip_name")

### AudioStreamPlayer/AudioStreamPlayer2D
- player.play()
- stream: 音频
- max_distance: 能听见声音的最远距离(发声点到屏幕中心像素,在2D中)
- bus: 音轨。可以分开设置音效和背景音乐。
- AudioStreamPlayer没有距离概念，就单纯播放一段声音。适合UI音效。
- 循环播放: 在Godot中打开音频文件，选中Loop后Reimport

## 基础机制

### 碰撞检测
- 线段是否检测到和Collision Layer中物体的碰撞。
- 返回一个字典。
- 未检测到碰撞: result.is_empty() == true
```python
var query_parameters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_parameters)
```

### 制造延迟
- await get_tree().create_timer(delay_time).timeout
- 创建一个一次性定时器
- 等到timeout信号前，挂起当前程序

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

func on_area_entered(other_area: Area2D):
    Callable(disable_collision).call_deferred() # 不要在物体碰撞计算过程中改变Collision的属性

    var tween = create_tween()
    tween.set_parallel() # 设置多个tween并行执行
    tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
    .set_ease(Tween.EASE_IN)\
    .set_trans(Tween.TRANS_BACK)
    tween.tween_property(sprite, "scale", Vector2.ZERO, 0.1).set_delay(0.4)
    tween.chain() # 等待所有tween执行完成
    tween.tween_callback(collect)
```

### 音量控制
```python
func get_bus_volume_percent(bus_name: String):
    var bus_index = AudioServer.get_bus_index(bus_name)
    var volume_db = AudioServer.get_bus_volume_db(bus_index)
    return db_to_linear(volume_db)


func set_bus_volume_percent(bus_name: String, percent: float):
    var bus_index = AudioServer.get_bus_index(bus_name)
    var volume_db = linear_to_db(percent)
    AudioServer.set_bus_volume_db(bus_index, volume_db)
```

### 全屏显示
```python
var mode = DisplayServer.window_get_mode()

if mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
else:
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
```

### Save&Load
- 设置保存目录: Project->General->config->custom user dir相关
- 打开该目录: Project->Open User Data Folder

```python
func load_save_file():
    if FileAccess.file_exists(SAVE_FILE_PATH):
        var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
        save_data = file.get_var()


func save():
    var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
    file.store_var(save_data)
```

## UI

### 鼠标事件
- Mouse->Stop/Ignore/Pass
- PanelContainer默认为Stop

### 字体设置
- 像素字体，将Antialiasing, Hint, Subpixel location全设置为None。
- 创建一个theme资源文件，用于设置UI默认行为
- 在project settings->GUI->Themes->Custom (Advanced Settings)

### 9-patch Panel
- theme.tres->Type: panel container
- StyleBoxTexture
    - Texture: UI图
    - Subregion: 选择UI图中的子区域并划分9个宫格
    - 四个角不变，四条边和中间块会根据缩放自适应拉伸
    - content margin

## 构建可执行文件
- Project Settings菜单中的Add，可以为当前选中设置选项添加在不同环境下的配置。
- Project Settings->export
- 需要在Editor Settings->export->windows 中配置rcedit.exe路径