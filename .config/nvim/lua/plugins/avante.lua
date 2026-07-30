return {
  {
    "yetone/avante.nvim",
    opts = {
      provider = "pi",
      providers = {
        pi = {
          __inherited_from = "openai",
          endpoint = os.getenv("PI_BASE_URL") or "http://127.0.0.1:4000/v1",
          model = os.getenv("PI_MODEL") or "coding",
          api_key_name = "PI_API_KEY",
          timeout = 30000,
        }
      }
    }
  }
}
