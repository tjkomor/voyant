require 'csv'
class PhoneParser
  attr_reader :country_codes

  def initialize
    @country_codes = CSV.read('countryCodes.csv').to_h
    @error_messages = []
  end

  def amount_of_digits(phone_number)
    phone_number.delete('^0-9').length
  end

  def valid_phone_number?(number)
    valid = true
    if amount_of_digits(number) > 9 && amount_of_digits(number) < 14
      number.chars.each do |c|
        if !valid_chars.include?(c)
          valid = false
          break
        end
      end
    else
      valid = false
    end
    valid
  end

  def formattedE164(number)
    if !plus_sign_exists(number) && is_american?(number)
      number = '+1' + number
    elsif !plus_sign_exists(number) && !is_american?(number)
      number = '+' + number
    end
    remove_leading_paren = number.gsub("(", '')
    remove_trailing_paren = remove_leading_paren.gsub(")", '')
    remove_hyphens = remove_trailing_paren.gsub("-", "")
    remove_spaces = remove_hyphens.gsub(" ", "")
  end

  def get_country_code(number)
    if plus_sign_exists(number)
      number[1..(length_of_country_code(number))]
    elsif is_american?(number)
      '1'
    else
      number[0..(length_of_country_code(number) - 1)]
    end
  end

  def parse_numbers(numbers)
    numbers.map do |num|
      if !valid_phone_number?(num)
        @error_messages.push(num, 'Invalid Phone Number')
      end
      country = country_codes.key(get_country_code(num))
      country + " " + formattedE164(num)
    end
  end

  def plus_sign_exists(number)
    number.include?('+')
  end

  def first_number(number)
    number.chars.each do |n|
      if numbers.include?(n)
        return n
      end
    end
  end

  def length_of_country_code(number)
    cc_map = {13 => 3, 12 => 2, 11 => 1, 10 => 1}
    cc_map[amount_of_digits(number)]
  end

  def is_american?(number)
    if amount_of_digits(number) == 10
      return true
    elsif amount_of_digits(number) == 11 && first_number(number) == '1'
      return true
    else
      return false
    end
  end

  private

  def valid_chars
    '()1234567890+- '
  end

  def numbers
    '123456789'
  end
end
