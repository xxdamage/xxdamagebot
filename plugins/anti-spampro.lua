-- detecta alias de canales y supergrupos

local action = function(msg, blocks)
local id = msg.from.id
local name = msg.from.first_name
	if msg.chat.type == 'private' or roles.is_admin(msg) then return true end
	if not msg.entities then return true end

	if db:hget('chat:'..msg.chat.id..':settings', 'spam') == 'disable' then
		local listablanca = {
			"@APirateK",
		}

		for i,entity in pairs(msg.entities) do
			canal = string.sub(msg.text, entity.offset+1, entity.offset+entity.length+1)
			for _,alias in pairs(listablanca) do
				if canal:lower() == alias:lower() then goto continue end
			end

			chat = api.getChat(canal)
			if chat then
				if chat.ok == true then
					api.sendKeyboard(msg.chat.id, name.. ' ('..id.. ') ha sido *banead@* por hacer SPAM 🔨\n\n🔸 `Informe enviado al administrador`', {inline_keyboard = {{{text = 'Desbanear', callback_data = 'unban:'..id}}}}, true))
					api.banUser(msg.chat.id, msg.from.id)
					misc.forwardToAdmins(msg.chat.id, msg.message_id)
					misc.sendMessageToAdmins(msg.chat.id, '👆 SPAM en el grupo: ➡️ *'..msg.chat.title..'*')
					return true
				end
			end
			::continue::
		end

	end
end

return {
	action = action,
	triggers = {
		'^.*(@[^%s]*).*'
	}
}
