#!/usr/bin/env python3
"""
Script para convertir todos los nodos de pared Sprite2D a StaticBody2D con colisiones
en el archivo room.tscn
"""

import re
import sys

def convert_wall_nodes(file_path):
    """Convierte todos los nodos de pared Sprite2D a StaticBody2D con colisiones"""
    
    # Leer el archivo
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Patrón para encontrar nodos de pared Sprite2D
    wall_pattern = r'\[node name="(Wall[^"]*)" type="Sprite2D" parent="\."\]\nposition = Vector2\(([^)]+)\)\ntexture = ([^\n]+)'
    
    def replace_wall_node(match):
        node_name = match.group(1)
        position = match.group(2)
        texture = match.group(3)
        
        # Crear el nuevo nodo StaticBody2D con Sprite2D hijo y CollisionShape2D
        replacement = f'''[node name="{node_name}" type="StaticBody2D" parent="."]
position = Vector2({position})

[node name="Sprite2D" type="Sprite2D" parent="{node_name}"]
texture = {texture}

[node name="CollisionShape2D" type="CollisionShape2D" parent="{node_name}"]
shape = SubResource("RectangleShape2D_WallTile")'''
        
        return replacement
    
    # Aplicar la conversión
    new_content = re.sub(wall_pattern, replace_wall_node, content)
    
    # Escribir el archivo modificado
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    # Contar cuántos nodos se convirtieron
    matches = re.findall(wall_pattern, content)
    print(f"Convertidos {len(matches)} nodos de pared de Sprite2D a StaticBody2D")
    
    return len(matches)

if __name__ == "__main__":
    file_path = r"c:\Users\TATA\Documents\GitHub\escape-dungeon-maze\scenes\world\room.tscn"
    
    try:
        converted_count = convert_wall_nodes(file_path)
        print(f"Conversión completada exitosamente. {converted_count} nodos convertidos.")
    except Exception as e:
        print(f"Error durante la conversión: {e}")
        sys.exit(1)