execute store result storage ss_shake args.magnitude double 0.003921568627451 run scoreboard players get @s SS.ScreenShake.Magnitude
execute store result storage ss_shake args.frequency double 0.003921568627451 run scoreboard players get @s SS.ScreenShake.Frequency

data modify storage ss_shake args.magnitude set string storage ss_shake args.magnitude 0 -1
data modify storage ss_shake args.frequency set string storage ss_shake args.frequency 0 -1

function ss_shake:particle with storage ss_shake args

execute if score .debug SS.ScreenShake.Magnitude matches 1 run title @s actionbar [{"text":"M="},{"score":{"objective":"SS.ScreenShake.Magnitude","name":"@s"}},{"text":", F="},{"score":{"objective":"SS.ScreenShake.Frequency","name":"@s"}}]