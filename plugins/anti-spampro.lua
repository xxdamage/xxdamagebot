-- detecta alias de canales y supergrupos
function string:split( inSplitPattern, outResults )
  if not outResults then
    outResults = { }
  end
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  while theSplitStart do
    table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
  end
  table.insert( outResults, string.sub( self, theStart ) )
  return outResults
end

function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function n2s(s)
	if s == nil then return "" else return s end
end



local action = function(msg, blocks)
	local id = msg.from.id
	local name = msg.from.first_name

	if blocks[1] == "lb" and roles.is_admin(msg) and #blocks >= 2 then
		--set y add
		if blocks[2] == "set" or blocks[2] == "add" then
			if (not msg.entities) or (#msg.entities == 1 and msg.entities[1].offset == 0) or (#msg.entities == 0) then
				api.sendMessage(msg.chat.id, "ℹ️ Introduce una lista de canales a permitir en este grupo")
				return false
			end
			if blocks[2] == "set" then
				canales = ""
			else
				canales = n2s(db:hget('chat:'..msg.chat.id..':settings', 'listablanca'))
			end
			nocanal={}
			repes={}
			modified=false
			for i,entity in pairs(msg.entities) do
				canal = trim(string.sub(msg.text, entity.offset+1, entity.offset+entity.length+1))
				if canal ~= "/"..blocks[1] then
					if api.getChat(canal) then
						if string.match(canales, canal) == nil then
							canales = canales..","..canal
							modified=true
						else
							repes[#repes+1]=canal
						end
					else
						nocanal[#nocanal+1]=canal
					end
				end
			end
			db:hset('chat:'..msg.chat.id..':settings', 'listablanca', canales)
			if modified then
				if blocks[2] == "set" then
					message="✅ Lista seteada correctamente. Esos alias seran ignorados por el antispam en este grupo."
				else
					message="✅ Añadidas excepciones correctamente. Esos alias seran ignorados por el antispam en este grupo."
				end
			else
				message=""
			end
			if #nocanal > 0 then
				message = message.."\n\n"
				for i,canal in pairs(nocanal) do
					if i == 1 then
						message=message..canal
					elseif i == #nocanal then
						message=message.." y "..canal
					else
						message=message..", "..canal
					end
				end
				if #nocanal == 1 then
					message=message.." no es un canal válido, no se añadirá a la lista."
				else
					message=message.." no son canales válidos, no se añadirán a la lista."
				end
			end
			if #repes > 0 then
				message = message.."\n\n"
				for i,canal in pairs(repes) do
					if i == 1 then
						message=message..canal
					elseif i == #repes then
						message=message.." y "..canal
					else
						message=message..", "..canal
					end
				end
				if #repes == 1 then
					message=message.." está repetido, no se añadirá a la lista."
				else
					message=message.." están repetidos, no se añadirán a la lista."
				end
			end
			api.sendReply(msg, message)
			return true
		end
		--reset
		if blocks[2] == "reset" then
			db:hdel('chat:'..msg.chat.id..':settings', 'listablanca')
			api.sendReply(msg, "🔁 Lista blanca de antispam reseteada para este grupo")
			return true
		end
		--del
		if blocks[2] == "del" then
			if (not msg.entities) or (#msg.entities == 1 and msg.entities[1].offset == 0) or (#msg.entities == 0) then
				api.sendMessage(msg.chat.id, "ℹ️ Introduce una lista de canales a eliminar en este grupo")
				return false
			end
			canales = db:hget('chat:'..msg.chat.id..':settings', 'listablanca')
			if canales == nil or canales == "" then
				api.sendReply(msg, "ℹ️ No hay ningun canal en la lista blanca para eliminar")
				return false
			end
			t1 = {}
			for _,entity in pairs(msg.entities) do
				canal = trim(string.sub(msg.text, entity.offset+1, entity.offset+entity.length+1))
				canales = string.gsub(canales, ","..canal, "")
			end
			db:hset('chat:'..msg.chat.id..':settings', 'listablanca', canales)
			api.sendReply(msg, "🔁 Canal/es eliminado/s de la lista blanca de este grupo")
			return true
		end
		--show
		if blocks[2] == "show" then
			canales = db:hget('chat:'..msg.chat.id..':settings', 'listablanca')
			if canales == nil or canales == "" then
				api.sendReply(msg, "ℹ️ No hay ningun canal en la lista blanca")
				return false
			else
				api.sendReply(msg, "✅ Lista de canales permitidos en este grupo:\n"..string.gsub(trim(string.gsub(canales, ",", " ")), " ", ", ").." y por último, pero no por ello menos importante: @APirateK")
				return true
			end
		end

		if blocks[2] == "help" then
			api.sendReply(msg, [[
*Comandos de lb (lista blanca)*

`!lb set <canales>` - Inicia una nueva lista blanca con los canales especificados

`!lb add <canales>` - Añade canales a una lista blanca ya existente.

`!lb del <canales>` - Elimina uno o varios canales de la lista blanca.

`!lb show` - Muestra la lista de canales permitidos.

`!lb reset` - Elimina todos los canales de la lista blanca

Recuerda tener el antispam activado con el comando !spam disable para que esto funcione

*Algunos ejemplos:*

!lb set @micanal1 @micanal2

!lb add @micanal3

!lb del @micanal1 @micanal2
			]], true)
		end
	end


	if msg.chat.type == 'private' or roles.is_admin(msg) then return true end
	if not msg.entities then return true end

	if db:hget('chat:'..msg.chat.id..':settings', 'spam') == 'disable' then
		canales = db:hget('chat:'..msg.chat.id..':settings', 'listablanca')
		canales = "@apiratek,@chollosk,@modapks"..n2s(canales)
		listablanca={}
		for i,alias in pairs(canales:split(",")) do
			listablanca[#listablanca+1] = alias
		end
		for _,entity in pairs(msg.entities) do
			canal = trim(string.sub(msg.text, entity.offset+1, entity.offset+entity.length+1))
			for _,alias in pairs(listablanca) do
				if canal:lower() == alias then goto continue end
			end

			chat = api.getChat(canal)
			if chat then
				if chat.ok == true then
					api.sendKeyboard(msg.chat.id, name.. ' ('..id.. ') ha sido *banead@* por hacer SPAM 🔨\n\n🔸 `Informe enviado al administrador`', {inline_keyboard = {{{text = 'Desbanear', callback_data = 'unban:'..id}}}}, true)
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
		'^.*(@[^%s]*).*',
		'^[!/](lb) (set) .*',
		'^[!/](lb) (reset)',
		'^[!/](lb) (add) .*',
		'^[!/](lb) (del) .*',
		'^[!/](lb) (show)',
		'^[!/](lb) (help)'
	}
}
