require_relative 'RedBotRestApiHelper'
require 'socket'
require 'rest_client'
require 'json'

class RedBot

  def botName
	  @botName
  end
  
  def initialize(server, port, channel)
    @channel = channel
	  @socket = TCPSocket.open(server, port)
	  @botName = "RedBot"
    say "NICK #{botName}" 
    say "USER #{botName} 0 * #{botName}"
    say "JOIN ##{@channel}"
    say_to_channel "#{1.chr}ACTION is here to help#{1.chr}"
  end

  def say(msg)
    puts msg
    @socket.puts msg
  end

  def say_to_channel(msg)
    say "PRIVMSG ##{@channel} :#{msg}"
  end

  def run
    until @socket.eof? do
      msg = @socket.gets
      puts msg

      if msg.match(/^PING :(.*)$/)
        say "PONG #{$~[1]}"
        next
      end

      if msg.match(/PRIVMSG ##{@channel} :(.*)$/)
        content = $~[1]
        splitContent = content.split(" ")

        splitContent.each do |val|
            puts val
        end

        if splitContent[0] == botName || splitContent[0] == "#{botName}:"
          case splitContent[1]

          when /(-)*help/
            say_to_channel('soon™')
          when /(-)*restart/
           
          else
            say_to_channel('heya')            
          end

        end
      end
    end
  end

  def quit
    say "cya hoomanz"
    say 'QUIT'
  end
end

bot = RedBot.new("irc.freenode.net", 6667, '')

trap("INT"){ bot.quit }

bot.run