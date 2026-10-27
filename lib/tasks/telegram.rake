namespace :telegram do
  desc "Long-polling Telegram bot"
  task bot: :environment do
    ApplicationTelegram.start
  end
end
