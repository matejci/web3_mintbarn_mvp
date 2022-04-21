# frozen_string_literal: true

SolanaRpcRuby.config do |c|
  # These are options that you can set before using gem:
  #
  # You can use this setting or pass cluster directly, check the docs.

  solana_url = ENV.fetch('SOLANA_RPC_URL', 'api.mainnet-beta.solana.com')

  c.cluster = "https://#{solana_url}"
  c.ws_cluster = "ws://#{solana_url}"

  # This one is mandatory.
  c.json_rpc_version = '2.0'
end
