require "socket" 

class GitHubReminder
	def initialize
		server = "chat.freenode.net"
		port = "6667"
		nick = "GitHubReminder"
		@channel = "#bitmaker"

		#GitHubReminderBot accesses the server under these condtions
		@irc_server = TCPSocket.open(server, port)
		@irc_server.puts "USER githubreminder 0 * GitHubReminder"
		@irc_server.puts "NICK #{nick}"
		@irc_server.puts "JOIN #{@channel}"
		@irc_server.puts "PRIVMSG #{@channel} :I'm the GitHubReminderBot. I remind you to push to github every now and again. Type in: Give me a push!"
	end

	def check_time
		
		until @irc_server.eof? do	
			@input = @irc_server.gets 

			if @input.include?("PRIVMSG #{@channel} :")
				if @input.include? "Give me a push!"
					@irc_server.puts "PRIVMSG #{@channel} :Be sure to push your work to github as often as possible."
					while true
						next_check = Time.now.min + 4
						next_check -= 60 if next_check >= 60
						while true
							if Time.now.min == next_check 
								@irc_server.puts "PRIVMSG #{@channel} :Don't forget to push to github!"
								break 
							end 
						end
					end
				end
			end
		end
	end
end

@reminder = GitHubReminder.new
@reminder.check_time