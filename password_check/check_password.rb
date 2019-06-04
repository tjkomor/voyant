password = ARGV[0]
common_passwords = File.read('./common_passwords.txt')
hash = common_passwords.split("\n").map { |pw| [pw, 1] }.to_h
if hash.has_key?(password)
  puts 'Common password'
else
  puts 'Not common password'
end
