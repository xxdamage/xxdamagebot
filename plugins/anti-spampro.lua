
-- detecta alias de canales o supergrupos como spam

-- en local lista blanca, puedes añadir que alias de canales o supergrupos el bot ignorara

local action = function(msg, blocks)
	if db:hget('chat:'..msg.chat.id..':settings', 'spam') == 'disable' then
		local listablanca = {
			"@apiratek",
		}

		for _,alias in pairs(listablanca) do
			if blocks[1] == alias then 
				return true
			end
		end

		if not(msg.chat.type == 'private') and not roles.is_admin(msg) then
			local id = msg.from.id
			local name = msg.from.first_name
			chat = api.getChat(blocks[1])
			if chat then
				if chat.ok == true then
          api.banUser(msg.chat.id, msg.from.id)
					api.sendReply(msg, name.. ' ('..id.. ') *ha sido baneado por hacer spam*\n\n` 🔹Informe enviado a los administradores`', true)
					misc.forwardToAdmins(msg.chat.id, msg.message_id)
					misc.sendMessageToAdmins(msg.chat.id, '👆 SPAM en el grupo: ➡️ *'..msg.chat.title..'*')
				end
			end
		end
	end
end

return {
	action = action,
	triggers = {
		'^.*(@[^%s]*).*'
	}
}
