class OllamaApi
  include HTTParty
  OLLAMA_URL="http://host.docker.internal:11434"
  def initialize; end

  def process_files(files)
    response = self.class.post(
      "#{OLLAMA_URL}/api/generate",
      body: JSON.generate({
        model: "qwen2.5vl:3b",
        stream: false,
        system: "Тебе нужно извлечь текст из изображений ничего не меняя и не комментируя. Текст оставь с оригинальной офорграфией и формулировками",
        prompt: "Извлеки весь текст с изображений, не давай своих комментариев",
        images: files
      }),
      options: {
        "temperature": 0
      },
      headers: {
        "Content-Type" => "application/json"
      },
      timeout: 600,
    )
    response
  end

  def transform_ticket(system, prompt)
    response = self.class.post(
      "#{OLLAMA_URL}/api/generate",
      body: JSON.generate({
        model: "qwen2.5:3b",
        stream: false,
        system: system,
        prompt: prompt
      }),
      options: {
        "temperature": 0
      },
      format: {
        type: "object",
        properties: {
          issuer: { type: "string" },
          body: { type: "text" },
          status: { type: "string" },
          extra: { type: "text" }
        }
      },
      headers: {
        "Content-Type" => "application/json"
      },
      timeout: 600,
    )
    response
  end
end
