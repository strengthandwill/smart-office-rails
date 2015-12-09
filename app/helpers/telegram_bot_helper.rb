require 'telegram/bot'
require 'open-uri'
require_relative "./user_helper"

module TelegramBotHelper
  include UserHelper
  
  def pong(bot, user_id, chat_id, options = {})
    if is_authorized?(user_id)
      send_photo_webcam(bot, chat_id, @pong_ip, "pong.jpg", options)
    else
      401
    end
  end
  
  def recep(bot, user_id, chat_id, options = {})
    if is_authorized?(user_id)
      send_photo_webcam(bot, chat_id, @recep_ip, "recep.jpg", options)
    else
      401
    end
  end
  
  def send_photo_webcam(bot, chat_id, webcam_ip, filename, options = {})
    begin
      open(filename, 'wb') do |file|
        file << open("http://192.168.1.113:8080/photo.jpg").read
        # file << open("http://#{webcam_ip}", http_basic_authentication: ["admin", ""]).read
      end
      post_photo(bot, chat_id, filename, options)
      200
    rescue Exception => e
      400
      # post_message(bot, chat_id, e.message)
    end
  end
  
  def action(message)
    action = message.text
    index = action.index('@')
    if index != nil
      action = action[0..(index-1)]
    end
    action
  end

  def chat_title(message)
    message.chat.type == "private" ? "private" : message.chat.title
  end
  
  def post_message(bot, chat_id, text)
    bot.api.send_message(chat_id: chat_id, text: text)
  end

  def post_photo(bot, chat_id, filename, options = {})
    if !options[:caption].nil?
      bot.api.send_photo(chat_id: chat_id, caption: options[:caption], photo: File.new(filename))
    else
      bot.api.send_photo(chat_id: chat_id, photo: File.new(filename))
    end
  end
end