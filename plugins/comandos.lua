local triggers = {
	'^[!#/][Cc]omandos'
}

local action = function(msg, blocks, ln)
        api.sendReply(msg, '*Comandos basicos de admin*\n\n🔨 *Comandos de Ban y Kick*\n\n/ban- expulsa al miembro permanentemente\n/kick- expulsa con opcion a volver\n/unban- quita el ban a ese user\n\n_Los comandos de ban, usarlos preferentemente respondiendo a un mensaje de la persona a banear_\n\n🔧 *Comandos de ajustes de flood, media..*\n\n/config- te manda por privado todos los ajustes para configurar\n\n_Para que el bot te pueda escribir por privado, primero tienes que tener abierto chat con el_\n\n📛  *Anti Spam*\n\n/spam enable- Permite el envio de links de otros grupos\n/spam disable- si un user envia alguno de estos links, sera expulsado\n\n`Si quieres activar el sistema antispam que primero avisa al usuario antes de echarlo, pon /spam enable, luego /config y ve a Media. Ahi, desactiva la casilla SPAM (que quede asi: X ) abajo marcas el numero de avisos que el bot dara antes de expulsar`\n\n _el bot detectara los link que contengan: "telegram.me" y "telegram.me/joinchat"_ asi como los alias de canales y supergrupos\n\n💬 *Comandos interactivos*\n\n/say enable o disable para activar/desactivar los plugins interactivos\n\n_Estos son el envio de audios por parte del bot, que el bot repita lo que le mandes con el comando !di...etc_\n\n🔆 *Otros comandos*\n\n/id- respondiendo al mensaje, te devuelve la id de ese user\n/user- respondiendo al mensajes, te dice si ese user tiene bans, avisos..etc\n/warn- Respondiendo a su mensaje, le da un aviso. Si alcanza el num max de avisos, le echa\n\n*Los comandos se pueden activar con / # o !*', true)
    end
    
 return {
	action = action,
	triggers = triggers
}
