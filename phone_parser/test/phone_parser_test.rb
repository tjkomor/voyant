gem 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require './lib/phone_parser.rb'

class PhoneParserTest < Minitest::Test

  def setup
    @pp = PhoneParser.new
  end

  def test_can_initialize_class_with_country_code_hash
    assert @pp.country_codes
    assert_equal @pp.country_codes.key('93'), 'Afghanistan'
    assert_equal @pp.country_codes.key('376'), 'Andorra'
    assert_equal @pp.country_codes.key('39'), 'Italy'
  end

  def test_can_determine_amount_of_digits_in_number
    assert_equal @pp.amount_of_digits('(405) 405 4055'), 10
    assert_equal @pp.amount_of_digits('(405)-405-4055'), 10
    assert_equal @pp.amount_of_digits('+1234567899'), 10
    assert_equal @pp.amount_of_digits('123456789'), 9
    assert_equal @pp.amount_of_digits('+1 (405)-405-4055'), 11
    assert_equal @pp.amount_of_digits('+23 (405)-405-4055'), 12
    assert_equal @pp.amount_of_digits('+233 (405)-405-4055'), 13
  end

  def test_can_detemrine_length_of_country_code
    assert_equal @pp.length_of_country_code('+1234567891233'), 3
    assert_equal @pp.length_of_country_code('+123456789123'), 2
    assert_equal @pp.length_of_country_code('+12345678912'), 1
  end

  def test_valid_phone_number_can_identify_invalid_phone_numbers
    refute @pp.valid_phone_number?('+12abce')
    refute @pp.valid_phone_number?('+12')
    refute @pp.valid_phone_number?('+123435879382473927533553')
    refute @pp.valid_phone_number?('405 a12 b234')
  end

  def test_valid_phone_number_can_identify_valid_phone_numbers
    assert @pp.valid_phone_number?('+1405405405')
    assert @pp.valid_phone_number?('23405405405')
    assert @pp.valid_phone_number?('+23405405405')
    assert @pp.valid_phone_number?('+1 405-405-4055')
  end

  def test_first_number_will_return_first_num_in_string
    assert_equal @pp.first_number('+14054054055'), '1'
    assert_equal @pp.first_number('abcdf3'), '3'
    assert_equal @pp.first_number('+74054054055'), '7'
    assert_equal @pp.first_number('9876'), '9'
  end

  def test_can_get_country_code_from_number
    assert_equal @pp.get_country_code('+14054054055'), '1'
    assert_equal @pp.get_country_code('+234054054055'), '23'
    assert_equal @pp.get_country_code('+2334054054055'), '233'
  end

  def test_is_american_can_identify_american_numbers
    assert @pp.is_american?('+14054054055')
    assert @pp.is_american?('+14054054055')
    assert @pp.is_american?('4054054055')

    refute @pp.is_american?('+24054054055')
    refute @pp.is_american?('+2334054054055')
  end

  def test_parse_numbers_can_return_correct_string
    numbers = ['4145341207', '+14145341207',
               '(414) 534-1207', '497113804761']

    result = ['United States +14145341207', 'United States +14145341207',
              'United States +14145341207', 'Germany +497113804761']

    assert_equal @pp.parse_numbers(numbers), result
  end
end
