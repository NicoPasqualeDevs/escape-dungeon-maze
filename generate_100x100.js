const fs = require('fs');

// Generar los 10,000 floor tiles
let floorTiles = '';
let floorIndex = 1;

for (let fila = 0; fila < 100; fila++) {
    for (let columna = 0; columna < 100; columna++) {
        const posX = 512 + (columna * 16);
        const posY = 268 + (fila * 16);
        
        floorTiles += `[node name="Floor${floorIndex}" type="Sprite2D" parent="."]\n`;
        floorTiles += `position = Vector2(${posX}, ${posY})\n`;
        floorTiles += `texture = ExtResource("2_d3e4f")\n\n`;
        floorIndex++;
    }
}

console.log('Floor tiles generados: ' + (floorIndex - 1));
fs.writeFileSync('floor_tiles_100x100.txt', floorTiles);

// Generar las paredes
let wallTiles = '';

// Esquinas superiores
wallTiles += `[node name="WallEdgeTopLeft" type="Sprite2D" parent="."]\n`;
wallTiles += `position = Vector2(512, 236)\n`;
wallTiles += `texture = ExtResource("10_b9c0d")\n\n`;

wallTiles += `[node name="WallEdgeTopRight" type="Sprite2D" parent="."]\n`;
wallTiles += `position = Vector2(2096, 236)\n`;
wallTiles += `texture = ExtResource("11_e1f2g")\n\n`;

// Paredes superiores centrales (98 tiles)
for (let i = 1; i < 99; i++) {
    const posX = 512 + (i * 16);
    wallTiles += `[node name="WallTopMid${i}" type="Sprite2D" parent="."]\n`;
    wallTiles += `position = Vector2(${posX}, 236)\n`;
    wallTiles += `texture = ExtResource("12_h3i4j")\n\n`;
}

// Paredes laterales izquierdas (100 tiles)
for (let i = 0; i < 100; i++) {
    const posY = 268 + (i * 16);
    wallTiles += `[node name="WallEdgeMidLeft${i + 1}" type="Sprite2D" parent="."]\n`;
    wallTiles += `position = Vector2(512, ${posY})\n`;
    wallTiles += `texture = ExtResource("13_k5l6m")\n\n`;
}

// Paredes laterales derechas (100 tiles)
for (let i = 0; i < 100; i++) {
    const posY = 268 + (i * 16);
    wallTiles += `[node name="WallEdgeMidRight${i + 1}" type="Sprite2D" parent="."]\n`;
    wallTiles += `position = Vector2(2096, ${posY})\n`;
    wallTiles += `texture = ExtResource("14_n7o8p")\n\n`;
}

// Esquinas inferiores
wallTiles += `[node name="WallEdgeBottomLeft" type="Sprite2D" parent="."]\n`;
wallTiles += `position = Vector2(512, 1852)\n`;
wallTiles += `texture = ExtResource("3_g5h6i")\n\n`;

wallTiles += `[node name="WallEdgeBottomRight" type="Sprite2D" parent="."]\n`;
wallTiles += `position = Vector2(2096, 1852)\n`;
wallTiles += `texture = ExtResource("4_j7k8l")\n\n`;

// Paredes inferiores centrales (98 tiles)
for (let i = 1; i < 99; i++) {
    const posX = 512 + (i * 16);
    wallTiles += `[node name="WallBottomMid${i}" type="Sprite2D" parent="."]\n`;
    wallTiles += `position = Vector2(${posX}, 1852)\n`;
    wallTiles += `texture = ExtResource("12_h3i4j")\n\n`;
}

// T-shapes
wallTiles += `[node name="WallEdgeTshapeLeft" type="Sprite2D" parent="."]\n`;
wallTiles += `position = Vector2(512, 252)\n`;
wallTiles += `texture = ExtResource("5_m9n0o")\n\n`;

wallTiles += `[node name="WallEdgeTshapeRight" type="Sprite2D" parent="."]\n`;
wallTiles += `position = Vector2(2096, 252)\n`;
wallTiles += `texture = ExtResource("6_p1q2r")\n\n`;

// Paredes centrales superiores (98 tiles)
for (let i = 1; i < 99; i++) {
    const posX = 512 + (i * 16);
    wallTiles += `[node name="WallMidTop${i}" type="Sprite2D" parent="."]\n`;
    wallTiles += `position = Vector2(${posX}, 252)\n`;
    wallTiles += `texture = ExtResource("9_y7z8a")\n\n`;
}

// Paredes inferiores extendidas
wallTiles += `[node name="WallLeft" type="Sprite2D" parent="."]\n`;
wallTiles += `position = Vector2(512, 1868)\n`;
wallTiles += `texture = ExtResource("8_v5w6x")\n\n`;

wallTiles += `[node name="WallRight" type="Sprite2D" parent="."]\n`;
wallTiles += `position = Vector2(2096, 1868)\n`;
wallTiles += `texture = ExtResource("7_s3t4u")\n\n`;

// Paredes centrales inferiores extendidas (98 tiles)
for (let i = 1; i < 99; i++) {
    const posX = 512 + (i * 16);
    wallTiles += `[node name="WallMidBottom${i}" type="Sprite2D" parent="."]\n`;
    wallTiles += `position = Vector2(${posX}, 1868)\n`;
    wallTiles += `texture = ExtResource("9_y7z8a")\n\n`;
}

fs.writeFileSync('wall_tiles_100x100.txt', wallTiles);
console.log('Wall tiles generados');