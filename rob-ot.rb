require "socket"


server = "chat.freenode.net"
port = "6667"
nick = "HelloBot"
channel = "#bitmaker"
greeting_prefix = "privmsg #bitmaker :"
greetings = ['hello', 'hi', 'hola', 'yo', 'wazup', 'guten tag', 'howdy', 'salutations', 'who the hell are you?']


irc_server = TCPSocket.open(server, port)

# You need to talk to the server by using IRC protocol.
irc_server.puts "USER historybot 0 * HistoryBot"
irc_server.puts "NICK #{nick}"
irc_server.puts "JOIN #{channel}"
irc_server.puts "PRIVMSG #{channel} :"


# priv is a msg to only the channel that you've joined

until irc_server.eof? do
	msg = irc_server.gets.downcase
	puts msg

	was_greeted = false
	greetings.each do |g|
		was_greeted = true if msg.include? greetings[0]
	end

	if msg.include? command
		response = "w00t! Someone talked to me!!!!"
		irc_server.puts "PRIVMSG #{channel} :#{response}"
	end

end

