local action = function(msg, matches, blocks, ln)
    
if not(msg.chat.type == 'private') and not roles.is_admin(msg) then         

    if db:hget('chat:'..msg.chat.id..':settings', 'spam') == 'disable' then
    local id = msg.from.id
    local name = msg.from.first_name
    if msg.from.username then
        name = name..' @'..msg.from.username
end
     action_sucess = api.banUser(msg.chat.id, msg.from.id)
     if action_sucess then
     api.sendKeyboard(msg.chat.id, name.. ' ('..id.. ') ha sido *banead@* por hacer SPAM 🔨\n\n🔸 `Informe enviado al administrador`', {inline_keyboard = {{{text = 'Desbanear', callback_data = 'unban:'..id}}}}, true))
     misc.forwardToAdmins(msg.chat.id, msg.message_id)
     misc.sendMessageToAdmins(msg.chat.id, '👆 SPAM en el grupo: ➡️ *'..msg.chat.title..'*')
        end
     end
  end
end

 return {
    action = action,
    triggers = {
                "[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm]%.[Mm][Ee]",
                 "[Tt][Ll][Gg][Rr][Mm]%.[Mm][Ee]",
                 "[Cc][Hh][Aa][Tt]%.[Ww][Hh][Aa][Tt][Ss][Aa][Pp][Pp]%.[Cc][Oo][Mm]"
                }
}
