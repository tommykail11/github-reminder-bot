require "socket"

class History_Bot
	def initialize
		server = "chat.freenode.net"
		port = "6667"
		nick = "HistoryBot"
		@channel = "#botmaker"
		
		@irc_server = TCPSocket.open(server, port)
		@irc_server.puts "USER historybot 0 * HistoryBot"
		@irc_server.puts "NICK #{nick}"
		@irc_server.puts "JOIN #{@channel}"
		@irc_server.puts "PRIVMSG #{@channel} :This is the HistoryBot. The command is !get_me_up_to_speed(num), where num gets the last num lines"
	end

	def librarian
		@records = File.new("records.md", "a+")
		until @irc_server.eof? do
			@input = @irc_server.gets
			
			if @input.include?("PRIVMSG #{@channel} :")
				usr = @input[/:[a-zA-Z_\-@]*!/]
				msg = @input.sub(/.*?(?=PRIVMSG #{@channel})PRIVMSG #{@channel} :/, '')
				@records.syswrite(usr[1...-1] + ': ' + msg + "\n")
			#else
				#@records.syswrite("Input is not coming from IRC")
			end
		end
	end

	def get_me_up_to_speed(num)

	end
end


@historyBot = History_Bot.new
@historyBot.librarian