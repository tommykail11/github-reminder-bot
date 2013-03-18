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
		#@records = File.open("records.md", "a+")
		@chat_history = []
	end

	def librarian # defined librarian method
		until @irc_server.eof? do # at the end of the chat a character that represents the end of the file is sent [eof stands for end of file]
			@input = @irc_server.gets # this gets the message
			
			if @input.include?("PRIVMSG #{@channel} :") #if the input is a message from the botmaker channel
				msg = @input.sub(/.*?(?=PRIVMSG #{@channel})PRIVMSG #{@channel} :/, '')  #substitute the mumbo jumbo with a blank
				usr = @input[/:[a-zA-Z_\-@]*!/] # this gets rid of the colon and everything after
				@chat_history << (usr[1...-1] + ': ' + msg) #this adds the user and the message put together to the chat history
				get_me_up_to_speed if @input.include? "!get_me_up_to_speed" # if the command is called, call the method
			end
		end
	end

	def get_me_up_to_speed # defines method
		if @chat_history.size < 10 # if array contains fewer than 10 messages
			@chat_history.each do |line| # loops through the whole array
				@irc_server.puts "PRIVMSG #{@channel} :#{line}" # this sends the message
			end	
		else 
			@chat_history[-10..-1].each do |line| # if the number is greater or equal to 10 get the last 10 lines
				@irc_server.puts "PRIVMSG #{@channel} :#{line}" # this sends the message
			end
		end
	end
end


@historyBot = History_Bot.new # this is a new instance of the History_Bot class
@historyBot.librarian #this calls the method librarian