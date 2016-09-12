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
     api.sendMessage(msg.chat.id, name.. ' ('..id.. ') ha sido *banead@* por hacer SPAM 🔨 Para conocer mas sobre el spam y los terminos, usa /spamhelp\n\n🔸 `Informe enviado al administrador` ', true)
     api.sendAudio(msg.chat.id, './archivos/audio/haha.ogg')
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
                }
}
