class ApplicationTelegram
  require "telegram/bot"

  def self.start
    token = ENV.fetch("TG_BOT_KEY").to_s.strip

    Telegram::Bot::Client.run(token) do |bot|
      p "Telegram bot started"
      # listen отдаёт Message ИЛИ CallbackQuery (и др.)
      bot.listen do |message|
        if message.text.eql?("/start")
          bot.api.send_message(chat_id: message.chat.id, text: "Приветствую тебя в Dunder Tickets!")
        else
          p "---___---"
          image = message.photo&.last
          document = message.document&.last
          text = message.text || message.caption
          p "Фото #{image.inspect}"
          p "Документ #{document.inspect}"
          p "---___---"

          ticket = Ticket.new
          ticket.message_payload = text
          ticket.save!

          if image.present?
            image_load_service = ImageLoadService.new(image.file_id, bot, ticket)
            image_load_service.load
          end

          ticket.reload
          message_text = "<b>Текст запроса:</b> #{ticket.message_payload ? ticket.message_payload : "Нет"}"
          image_text = "<b>Фото запроса:</b> #{ticket.image_payload ? ticket.image_payload : "Нет"}"
          document_text = "<b>Документ запроса:</b> #{document ? document.file_id : "Нет"}"

          # TicketTransformService.call(ticket)

          ticket.reload

          body = "<b>Преобразованный запрос:</b> #{ ticket.body ? ticket.body : "Нет"}"
          bot.api.send_message(chat_id: message.chat.id, text: "#{message_text}.\n#{image_text}.\n#{document_text}.\n#{body}", parse_mode: "HTML")
        end
      end
    end
  end
end
