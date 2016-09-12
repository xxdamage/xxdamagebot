local action = function(msg, blocks, ln)
local hash = 'chat:'..msg.chat.id..':topic'
local topic = db:get(hash)
local texto = blocks[2]

if not (msg.chat.type == 'private') then 

 if blocks[1] == 'topic' then
  if not texto then
	if topic then
		api.sendMessage(msg.chat.id, '📍 *Topic*\n'..topic, true)
	elseif not topic and roles.is_admin(msg) then
		api.sendReply(msg, '❌ *No hay topic*\nPero puedes añadir uno con:\n`/topic texto`\nMás ayuda /topichelp', true)		
	end
  end
 end
	
if roles.is_admin(msg) then
	
 if blocks[1] == 'topic' and texto then
	db:set(hash, texto)
	api.sendMessage(msg.chat.id, '🆕 *Nuevo topic*\n' ..texto, true)
 end
 
 if blocks[1] == 'topichelp' then
	api.sendMessage(msg.chat.id, 'ℹ️ *Topics*\n\n`/topic` Muestra el topic actual.\n`/topic texto` Establece un nuevo topic.\n`/addtopic texto` Añade una sola línea al topic sin eliminarlo.\n`/remtopic` Elimina el topic actual.', true)
 end
 
 if blocks[1] == 'remtopic' then
	if topic then
		db:del(hash, text)
		api.sendMessage(msg.chat.id, '✅ *Topic removido*.', true)
	else
		api.sendReply(msg, '❌ *No hay un topic establecido anteriormente*.\nPuedes establecer uno con:\n`/topic texto`', true)
	end
 end
  
 if blocks[1] == 'addtopic' then
	if topic then
		db:set(hash, topic..'\n'..texto)
		api.sendMessage(msg.chat.id, '🆕 *Linea de topic agregada*\n\n' ..texto, true)
	else
		api.sendMessage(msg.chat.id, '❌ *No puedes añadir una línea nueva si no hay topic*.\nPuedes establecerlo con:\n`/topic texto`', true)
	end
 end
end -- cierra el if is mod
 else
 api.sendMessage(msg.from.id, make_text(lang[ln].pv))
end -- cierra el if not private
end -- cierra la funcion/plugin

return {
	action = action,
	triggers = {
			'^/(topic)$',
			'^/(topic)@'..bot.username..'$',
			'^/(topic) (.*)$',
			'^/(remtopic)$',
			'^/(addtopic) (.*)$',
			'^/(topichelp)'
				}
		}
