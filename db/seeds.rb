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

chains = [{ name: 'Mainnet', rpc_url: 'https://mainnet.infura.io/v3/', block_explorer_url: 'https://etherscan.io' },
          # { name: 'Ropsten', rpc_url: 'https://ropsten.infura.io/v3/', block_explorer_url: 'https://ropsten.etherscan.io' },
          { name: 'Rinkeby', rpc_url: 'https://rinkeby.infura.io/v3/', block_explorer_url: 'https://rinkeby.etherscan.io' },
          # { name: 'Goerli', rpc_url: 'https://goerli.infura.io/v3/', block_explorer_url: 'https://goerli.etherscan.io' },
          # { name: 'Kovan', rpc_url: 'https://kovan.infura.io/v3/', block_explorer_url: 'https://kovan.etherscan.io' },
          { name: 'Polygon', rpc_url: 'https://polygon-rpc.com/', block_explorer_url: 'https://polygonscan.com/' }]

chains.each do |net|
  Chain.find_or_create_by!(name: net[:name], rpc_url: net[:rpc_url], block_explorer_url: net[:block_explorer_url])
end
