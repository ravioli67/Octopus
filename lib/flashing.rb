def create_key
    key = OpenSSL::Cipher.new('AES-256-CBC').random_key
    File.write('key.bin', key)
    puts "Key created and saved to key.bin"
    end

create_key()