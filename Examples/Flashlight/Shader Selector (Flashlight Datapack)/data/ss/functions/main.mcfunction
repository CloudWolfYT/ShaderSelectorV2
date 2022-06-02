execute as @a[scores={click=1..}] run function ss:toggle_flashlight
execute as @a[scores={flashlight=1..}] run function ss:flashlight

execute as @a[scores={flashlight=0}] run particle minecraft:entity_effect ~ ~ ~ 0.9960784313725490196078431372549 0.9921568627450980392156862745098 1 1 0 force @s