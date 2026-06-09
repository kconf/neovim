return {
  {
    "yetone/avante.nvim",
    opts = {
      provider = "bifrost",
      providers = {
        bifrost = {
          __inherited_from = "openai",
          endpoint = "http://127.0.0.1:4000/v1",
          model = "coding",
          api_key_name = "BIFROST_API_KEY",
          timeout = 30000,
        }
      }
    }
  }
}
