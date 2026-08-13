require 'openssl'

KEY_FILE = 'generated.key'

# Read the 32-byte binary key
key = File.binread(KEY_FILE)
raise "Key must be 32 bytes!" if key.bytesize != 32

print "Do you want to (e)ncrypt or (d)ecrypt? "
mode = gets.chomp.downcase

print "Enter the file path: "
filepath = gets.chomp

raise "File not found!" unless File.exist?(filepath)

# Use a fixed IV (Initialization Vector) so we don't need to prepend a random IV to the file.
# Note: For maximum production security, an IV should be random and unique per encryption, 
# but a fixed IV satisfies the requirement to overwrite the exact same file cleanly.
iv = "\x00" * 16 

cipher = OpenSSL::Cipher.new('aes-256-cbc')

if mode == 'e'
  cipher.encrypt
  cipher.key = key
  cipher.iv = iv
  
  plaintext = File.binread(filepath)
  ciphertext = cipher.update(plaintext) + cipher.final
  
  File.binwrite(filepath, ciphertext)
  puts "Successfully encrypted #{filepath} in place."

elsif mode == 'd'
  cipher.decrypt
  cipher.key = key
  cipher.iv = iv
  
  ciphertext = File.binread(filepath)
  plaintext = cipher.update(ciphertext) + cipher.final
  
  File.binwrite(filepath, plaintext)
  puts "Successfully decrypted #{filepath} in place."
else
  puts "Invalid choice. Choose 'e' or 'd'."
end
