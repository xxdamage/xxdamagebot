 ---------------------------------- COMO INSTALAR CORRECTAMENTE ----------------------------------------

--En el directorio root, poner esto en consola: sudo aptitude install fortunes-es fortunes-es-off

 --------------------------------------------------------------------------------------------------------

local s = io.popen('fortune'):read('*all')
if s:match('not found$') then
	print('fortuna no esta instalado en el pc.')
	print('fortune.lua no esta activado.')
	return
end

local command = 'frase'
local doc = '`Retorna una cita famosa.`'

local triggers = {
	'^[!/]frase[@'..bot.username..']*'
}

local action = function(msg)
	if db:hget('chat:'..msg.chat.id..':settings', 'say') == 'enable' then

	local message = io.popen('fortune'):read('*all')
	api.sendMessage(msg.chat.id, message, true)

	end
end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command
}