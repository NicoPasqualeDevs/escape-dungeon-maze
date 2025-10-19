// Generador para room_triple_60x60_example.tscn
const fs = require('fs');

// Función para generar tiles de piso para una habitación
function generateFloorTiles(roomIndex, offsetX, startFloorIndex) {
    let floorContent = '';
    let floorIndex = startFloorIndex;
    
    for (let row = 0; row < 60; row++) {
        for (let col = 0; col < 60; col++) {
            const x = 512 + offsetX + (col * 16);
            const y = 268 + (row * 16);
            
            floorContent += `
[node name="Floor${floorIndex}" type="Sprite2D" parent="."]
position = Vector2(${x}, ${y})
texture = ExtResource("2_sgxkn")`;
            floorIndex++;
        }
    }
    return { content: floorContent, nextIndex: floorIndex };
}

// Función para generar paredes para una habitación
function generateWalls(roomIndex, offsetX) {
    let wallContent = '';
    const baseX = 512 + offsetX;
    const baseY = 268;
    const roomWidth = 60;
    const roomHeight = 60;
    
    // Esquinas superiores
    wallContent += `
[node name="WallEdgeTopLeft${roomIndex}" type="Sprite2D" parent="."]
position = Vector2(${baseX}, ${baseY - 32})
texture = ExtResource("10_mf8q8")

[node name="WallEdgeTopRight${roomIndex}" type="Sprite2D" parent="."]
position = Vector2(${baseX + (roomWidth-1)*16}, ${baseY - 32})
texture = ExtResource("11_0av3c")`;

    // Paredes superiores centrales
    for (let i = 1; i < roomWidth - 1; i++) {
        wallContent += `
[node name="WallTopMid${roomIndex}_${i}" type="Sprite2D" parent="."]
position = Vector2(${baseX + i*16}, ${baseY - 32})
texture = ExtResource("12_xiaua")`;
    }
    
    // Paredes laterales
    for (let i = 0; i < roomHeight; i++) {
        wallContent += `
[node name="WallEdgeMidLeft${roomIndex}_${i+1}" type="Sprite2D" parent="."]
position = Vector2(${baseX}, ${baseY + i*16})
texture = ExtResource("13_w7fvf")

[node name="WallEdgeMidRight${roomIndex}_${i+1}" type="Sprite2D" parent="."]
position = Vector2(${baseX + (roomWidth-1)*16}, ${baseY + i*16})
texture = ExtResource("14_vrob6")`;
    }
    
    // Esquinas inferiores
    const lastRowY = baseY + (roomHeight-1)*16;
    wallContent += `
[node name="WallEdgeBottomLeft${roomIndex}" type="Sprite2D" parent="."]
position = Vector2(${baseX}, ${lastRowY})
texture = ExtResource("3_4b0be")

[node name="WallEdgeBottomRight${roomIndex}" type="Sprite2D" parent="."]
position = Vector2(${baseX + (roomWidth-1)*16}, ${lastRowY})
texture = ExtResource("4_ub74j")`;

    // Paredes inferiores centrales
    for (let i = 1; i < roomWidth - 1; i++) {
        wallContent += `
[node name="WallTopMidBottom${roomIndex}_${i}" type="Sprite2D" parent="."]
position = Vector2(${baseX + i*16}, ${lastRowY})
texture = ExtResource("12_xiaua")`;
    }
    
    // T-shapes de conexión
    wallContent += `
[node name="WallEdgeTshapeLeft${roomIndex}" type="Sprite2D" parent="."]
position = Vector2(${baseX}, ${baseY - 16})
texture = ExtResource("5_hmxe8")

[node name="WallEdgeTshapeRight${roomIndex}" type="Sprite2D" parent="."]
position = Vector2(${baseX + (roomWidth-1)*16}, ${baseY - 16})
texture = ExtResource("6_rcuux")`;

    // Paredes centrales superiores
    for (let i = 1; i < roomWidth - 1; i++) {
        wallContent += `
[node name="WallMidTop${roomIndex}_${i}" type="Sprite2D" parent="."]
position = Vector2(${baseX + i*16}, ${baseY - 16})
texture = ExtResource("9_nihv0")`;
    }
    
    // Paredes inferiores extendidas
    wallContent += `
[node name="WallLeft${roomIndex}" type="Sprite2D" parent="."]
position = Vector2(${baseX}, ${lastRowY + 16})
texture = ExtResource("8_0qtma")

[node name="WallRight${roomIndex}" type="Sprite2D" parent="."]
position = Vector2(${baseX + (roomWidth-1)*16}, ${lastRowY + 16})
texture = ExtResource("7_p1tpc")`;

    for (let i = 1; i < roomWidth - 1; i++) {
        wallContent += `
[node name="WallMidBottom${roomIndex}_${i}" type="Sprite2D" parent="."]
position = Vector2(${baseX + i*16}, ${lastRowY + 16})
texture = ExtResource("9_nihv0")`;
    }
    
    return wallContent;
}

// Generar el contenido completo del archivo
const header = `[gd_scene load_steps=15 format=3 uid="uid://ctriple60x60room2024"]

[ext_resource type="Script" uid="uid://c5b2ym3ym27ov" path="res://scripts/world/room.gd" id="1_peo88"]
[ext_resource type="Texture2D" uid="uid://17ff2w7xtrnv" path="res://assets/tiles/floor_1.png" id="2_sgxkn"]
[ext_resource type="Texture2D" uid="uid://bew0em8rg8hs2" path="res://assets/tiles/wall_edge_bottom_left.png" id="3_4b0be"]
[ext_resource type="Texture2D" uid="uid://bb56tiesadi12" path="res://assets/tiles/wall_edge_bottom_right.png" id="4_ub74j"]
[ext_resource type="Texture2D" uid="uid://feosqmmjukl6" path="res://assets/tiles/wall_edge_tshape_left.png" id="5_hmxe8"]
[ext_resource type="Texture2D" uid="uid://dje1ixwgbsm" path="res://assets/tiles/wall_edge_tshape_right.png" id="6_rcuux"]
[ext_resource type="Texture2D" uid="uid://bujke4t4o1nwa" path="res://assets/tiles/wall_right.png" id="7_p1tpc"]
[ext_resource type="Texture2D" uid="uid://bsn3nevbb0ny8" path="res://assets/tiles/wall_left.png" id="8_0qtma"]
[ext_resource type="Texture2D" uid="uid://bt7v8607xrye0" path="res://assets/tiles/wall_mid.png" id="9_nihv0"]
[ext_resource type="Texture2D" uid="uid://g71ctstcigan" path="res://assets/tiles/wall_edge_top_left.png" id="10_mf8q8"]
[ext_resource type="Texture2D" uid="uid://dme0hmufay8bq" path="res://assets/tiles/wall_edge_top_right.png" id="11_0av3c"]
[ext_resource type="Texture2D" uid="uid://bkjonewj5i5xl" path="res://assets/tiles/wall_top_mid.png" id="12_xiaua"]
[ext_resource type="Texture2D" uid="uid://dkmf0od3q8q5v" path="res://assets/tiles/wall_edge_mid_left.png" id="13_w7fvf"]
[ext_resource type="Texture2D" uid="uid://bft5rj4lglxw1" path="res://assets/tiles/wall_edge_mid_right.png" id="14_vrob6"]

[node name="Room" type="Node2D"]
script = ExtResource("1_peo88")

[node name="ColorRect" type="ColorRect" parent="."]
z_index = -10
offset_left = -285.0
offset_top = -447.0
offset_right = 4500.0
offset_bottom = 1553.0
color = Color(0.1, 0.1, 0.12, 1)`;

let content = header;
let floorIndex = 1;

// Generar las tres habitaciones
console.log('Generando habitación 1...');
const room1 = generateFloorTiles(1, 0, floorIndex);
content += room1.content;
floorIndex = room1.nextIndex;

console.log('Generando habitación 2...');
const room2 = generateFloorTiles(2, 1200, floorIndex);
content += room2.content;
floorIndex = room2.nextIndex;

console.log('Generando habitación 3...');
const room3 = generateFloorTiles(3, 2400, floorIndex);
content += room3.content;

console.log('Generando paredes...');
content += generateWalls(1, 0);
content += generateWalls(2, 1200);
content += generateWalls(3, 2400);

// Escribir el archivo
fs.writeFileSync('./scenes/world/room_triple_60x60_example.tscn', content);
console.log('Archivo room_triple_60x60_example.tscn generado exitosamente!');
console.log(`Total de tiles de piso: ${floorIndex - 1}`);