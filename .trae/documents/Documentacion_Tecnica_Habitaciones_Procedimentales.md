# Documentación Técnica: Sistema de Generación Procedimental de Habitaciones

## 1. Análisis de Patrones Existentes

### 1.1 Estructura Base de Datos
Basándome en el análisis de las habitaciones existentes (3x3, 3x4, 4x3, 4x4), he identificado los siguientes patrones:

**Parámetros Base:**
- Posición inicial del piso: `Vector2(512, 268)`
- Espaciado entre tiles: `16 píxeles` (tanto horizontal como vertical)
- Tamaño de tile: `16x16 píxeles`

### 1.2 Distribución de Tiles de Piso (Floor)

| Tamaño | Cantidad Tiles | Patrón de Distribución |
|--------|----------------|------------------------|
| 3x3    | 9 tiles        | Matriz 3x3 completa |
| 3x4    | 12 tiles       | Matriz 3 columnas × 4 filas |
| 4x3    | 12 tiles       | Matriz 4 columnas × 3 filas |
| 4x4    | 16 tiles       | Matriz 4x4 completa |

**Fórmula de Posicionamiento de Pisos:**
```
Para una habitación de ancho W y alto H:
- Posición X = 512 + (columna * 16)
- Posición Y = 268 + (fila * 16)
- Donde: columna ∈ [0, W-1] y fila ∈ [0, H-1]
```

## 2. Sistema de Clasificación de Tiles de Pared

### 2.1 Tipos de Tiles de Pared Identificados

| Tipo de Tile | Recurso | Posición Relativa | Uso |
|--------------|---------|-------------------|-----|
| `wall_edge_top_left` | ExtResource("10_*") | Esquina superior izquierda | Único |
| `wall_edge_top_right` | ExtResource("11_*") | Esquina superior derecha | Único |
| `wall_edge_bottom_left` | ExtResource("3_*") | Esquina inferior izquierda | Único |
| `wall_edge_bottom_right` | ExtResource("4_*") | Esquina inferior derecha | Único |
| `wall_top_mid` | ExtResource("12_*") | Borde superior central | Repetible |
| `wall_left` | ExtResource("8_*") | Borde izquierdo inferior | Único |
| `wall_right` | ExtResource("7_*") | Borde derecho inferior | Único |
| `wall_mid` | ExtResource("9_*") | Paredes centrales | Repetible |
| `wall_edge_mid_left` | ExtResource("13_*") | Borde izquierdo central | Repetible |
| `wall_edge_mid_right` | ExtResource("14_*") | Borde derecho central | Repetible |
| `wall_edge_tshape_left` | ExtResource("5_*") | Conexión izquierda superior | Único |
| `wall_edge_tshape_right` | ExtResource("6_*") | Conexión derecha superior | Único |

### 2.2 Patrones de Posicionamiento de Paredes

**Coordenadas Base para Paredes:**
- Offset superior: `-16 píxeles` (Y = 252 para fila superior)
- Offset inferior: `+16 píxeles` (Y = 316+ para fila inferior)
- Offset lateral: Mismo X que los pisos de borde

## 3. Algoritmo de Generación Procedimental

### 3.1 Función de Generación de Pisos
```pseudocode
function generarPisos(ancho, alto):
    pisos = []
    baseX = 512
    baseY = 268
    
    for fila in range(alto):
        for columna in range(ancho):
            posX = baseX + (columna * 16)
            posY = baseY + (fila * 16)
            pisos.append(crearPiso(posX, posY))
    
    return pisos
```

### 3.2 Función de Generación de Paredes
```pseudocode
function generarParedes(ancho, alto):
    paredes = []
    baseX = 512
    baseY = 268
    
    // Paredes superiores
    paredes.append(crearPared("wall_edge_top_left", baseX, baseY - 32))
    paredes.append(crearPared("wall_edge_top_right", baseX + (ancho-1)*16, baseY - 32))
    
    for i in range(1, ancho-1):
        paredes.append(crearPared("wall_top_mid", baseX + i*16, baseY - 32))
    
    // Paredes laterales
    for i in range(alto):
        if i < alto-1:  // No en la última fila
            paredes.append(crearPared("wall_edge_mid_left", baseX, baseY + i*16))
            paredes.append(crearPared("wall_edge_mid_right", baseX + (ancho-1)*16, baseY + i*16))
    
    // Paredes inferiores
    ultimaFilaY = baseY + (alto-1)*16
    paredes.append(crearPared("wall_edge_bottom_left", baseX, ultimaFilaY))
    paredes.append(crearPared("wall_edge_bottom_right", baseX + (ancho-1)*16, ultimaFilaY))
    
    // Paredes centrales inferiores
    for i in range(1, ancho-1):
        paredes.append(crearPared("wall_top_mid", baseX + i*16, ultimaFilaY))
    
    // Paredes de conexión y extensión
    paredes.append(crearPared("wall_edge_tshape_left", baseX, baseY - 16))
    paredes.append(crearPared("wall_edge_tshape_right", baseX + (ancho-1)*16, baseY - 16))
    
    // Paredes centrales superiores
    for i in range(1, ancho-1):
        paredes.append(crearPared("wall_mid", baseX + i*16, baseY - 16))
    
    // Paredes inferiores extendidas
    paredes.append(crearPared("wall_left", baseX, ultimaFilaY + 16))
    paredes.append(crearPared("wall_right", baseX + (ancho-1)*16, ultimaFilaY + 16))
    
    for i in range(1, ancho-1):
        paredes.append(crearPared("wall_mid", baseX + i*16, ultimaFilaY + 16))
    
    return paredes
```

## 4. Especificaciones para Nuevos Tamaños

### 4.1 Habitación 5x4 (20 tiles de piso)
- **Pisos:** 5 columnas × 4 filas
- **Rango X:** 512 a 576 (incrementos de 16)
- **Rango Y:** 268 a 316 (incrementos de 16)
- **Paredes superiores:** 5 tiles (1 esquina izq + 3 centrales + 1 esquina der)
- **Paredes laterales:** 4 tiles por lado
- **Paredes inferiores:** 5 tiles + extensión inferior

### 4.2 Habitación 5x5 (25 tiles de piso)
- **Pisos:** 5 columnas × 5 filas
- **Rango X:** 512 a 576 (incrementos de 16)
- **Rango Y:** 268 a 332 (incrementos de 16)
- **Paredes superiores:** 5 tiles
- **Paredes laterales:** 5 tiles por lado
- **Paredes inferiores:** 5 tiles + extensión inferior

### 4.3 Habitación 6x3 (18 tiles de piso)
- **Pisos:** 6 columnas × 3 filas
- **Rango X:** 512 a 592 (incrementos de 16)
- **Rango Y:** 268 a 300 (incrementos de 16)
- **Paredes superiores:** 6 tiles
- **Paredes laterales:** 3 tiles por lado
- **Paredes inferiores:** 6 tiles + extensión inferior

## 5. Reglas de Escalabilidad

### 5.1 Reglas Generales
1. **Cantidad de pisos:** `ancho × alto`
2. **Paredes superiores:** `ancho` tiles (2 esquinas + (ancho-2) centrales)
3. **Paredes laterales:** `alto` tiles por lado
4. **Paredes inferiores:** `ancho` tiles + extensión de `ancho` tiles
5. **Paredes de conexión:** 2 T-shapes + (ancho-2) centrales en Y-16

### 5.2 Límites Recomendados
- **Mínimo:** 3x3 (para mantener estructura de paredes)
- **Máximo:** 10x10 (por consideraciones de rendimiento)
- **Aspectos recomendados:** Ratios entre 1:1 y 2:1 para mejor jugabilidad

## 6. Implementación en Godot

### 6.1 Estructura de Nodos Requerida
```
Room (Node2D)
├── ColorRect (fondo)
├── Floor1..N (Sprite2D)
└── Wall1..M (Sprite2D)
```

### 6.2 Recursos Necesarios
- `floor_1.png` (tile de piso base)
- 11 tipos diferentes de tiles de pared
- Script `room.gd` para lógica de habitación

### 6.3 Ejemplo de Uso
```gdscript
# Para generar una habitación 5x4
var room_generator = RoomGenerator.new()
var room_scene = room_generator.generate_room(5, 4)
```

## 7. Consideraciones Adicionales

### 7.1 Optimizaciones
- Usar TileMap en lugar de Sprite2D individuales para habitaciones grandes
- Implementar pooling de objetos para generación dinámica
- Considerar LOD para habitaciones muy grandes

### 7.2 Extensiones Futuras
- Soporte para formas no rectangulares
- Tiles de piso variados (diferentes texturas)
- Puertas y conexiones entre habitaciones
- Decoraciones procedimentales (cofres, enemigos, etc.)

---

*Documento generado para el sistema de habitaciones procedimentales del proyecto Escape Dungeon Maze*