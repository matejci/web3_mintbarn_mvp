# frozen_string_literal: true

App.find_or_create_by!(app_id: '17090582082047195423',
                       app_type: :web,
                       description: 'WEB3 MVP WEB',
                       name: 'WEB3 WEB',
                       public_key: '20b43633b066d56150dc7894ce1ca76813d9f866d3ffd48ba7',
                       status: true)

App.find_or_create_by!(app_id: '12171451176048326830',
                       app_type: :ios,
                       description: 'WEB3 MVP IOS',
                       name: 'WEB3 IOS',
                       public_key: '0b68924a696462acfa5f5a663ece24c52db099178b040babc2',
                       status: true)

User.create(first_name: 'Matej', last_name: 'Cica', email: 'matej@takkoapp.com', password: '123123',
            dob: Date.new(1986, 4, 13), tos_accepted: true, tos_accepted_at: Time.current,
            tos_accepted_ip: 'localhost', admin: true, active: true)

chains = [{ name: 'Devnet', rpc_url: 'https://api.devnet.solana.com' },
          { name: 'Testnet', rpc_url: 'https://api.testnet.solana.com' },
          { name: 'Mainnet', rpc_url: 'https://api.mainnet-beta.solana.com' }]

chains.each do |net|
  Chain.find_or_create_by(name: net[:name], rpc_url: net[:rpc_url])
end
