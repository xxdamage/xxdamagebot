local triggers = {
	"[Xx][Xx][Dd][Aa][Mm][Aa][Gg][Ee]",   --cambia los triggers por tu nombre o alias
        "@xxdamage"
}

local action = function(msg, matches, blocks, ln)
	if db:hget('chat:'..msg.chat.id..':settings', 'mencion') == 'enable' then
	if msg.from.id == config.admin.owner then return
end
	user = msg.from.first_name
	api.sendReply(msg, '▶️ _mencion enviada_', true)
	local res = api.forwardMessage(85497660, msg.chat.id, msg.message_id)  -- substituye la ID por la tuya
	if res then
	api.sendMessage(TUID, '❗️ Aviso de mencion en el grupo ➡️ ' ..msg.chat.title, false, res.result.message_id, true)-- substituye TU ID por la tuya
	api.sendMessage(TUID, '-------------------------------- ', true) -- substituye TUID por la tuya
	end
end
end
    
 return {
	action = action,
	triggers = triggers
}
