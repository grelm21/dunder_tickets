class ImageLoadService
  def initialize(file_id, bot, ticket)
    @file_id = file_id
    @bot = bot
    @ticket = ticket
    raise "File id is empty" if @file_id.nil?
    raise "Bot is empty" if @bot.nil?
  end

  def load
    file_info = @bot.api.get_file(file_id: @file_id)
    p "=: = = = = = = = = = = = = = = = = = = = = = = ="
    p file_info

    telegram_api = TelegramApi.new
    response = telegram_api.download_file(file_info.file_path)
    p "----------------------------"
    p response.code
    p response.body.bytesize

    filename = File.basename(file_info.file_path)
    content_type = response.headers["content-type"]

    @ticket.images.attach(
      io: StringIO.new(response.body),
      content_type: content_type,
      filename: filename
    )
    @ticket.save!
    # base_64_images = Base64.strict_encode64(response.body)
    # images = @ticket.images.map { |img| Base64.strict_encode64(img.download) }
    # ollama_api = OllamaApi.new
    # response = ollama_api.process_files(images)
    #
    # image_text = response.parsed_response["response"]
    # p "image_text"
    # p image_text
    # @ticket.image_payload = image_text
    # @ticket.save!
  end
end
