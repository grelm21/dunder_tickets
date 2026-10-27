class TelegramApi
  include HTTParty

  def initialize; end

  def download_file(file_path)
    response = self.class.get("https://api.telegram.org/file/bot#{ENV.fetch('TG_BOT_KEY')}/#{file_path}")
    response
  end
end
