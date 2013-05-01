#!/usr/bin/ruby
# Testing file for the CCValid class
# 
# Examples:
# test(true, false, "failing") - this is a failing test (1st param != 2nd)
# test(false, false", "passing") - this is a passing test (1st param == 2nd)
#
# To add more tests, add calls to test function (within main_tests function)

# Author:  A. Perkins <aperkins81@gmail.com>
# Date: 2013-04-30

require './ccvalid.rb'

class Tester

  attr_accessor :tests, :passing
  WIDTH = 80 # columns
  PASS = "PASS"
  FAIL = "FAIL"
  SYM_PASS = "=="
  SYM_FAIL = "!="
  
  # test: an expression that evaluates to a boolean (t/f)
  # expecting: the expected boolean value of the above result
  # text: a description of the test
  def test(test=false, expecting=false, text="Unnamed Passing Test")
    passed = test == expecting
    @tests += 1
    @passing += 1 if test == expecting
    result = passed ? PASS : FAIL
    symbol = passed ? SYM_PASS : SYM_FAIL
    status = " #{result} (#{test.to_s[0]} #{symbol} #{expecting.to_s[0]})"
    
    len_dot = WIDTH - text.length - status.length
    len_dot = 0 if len_dot < 0
    dots = ("."*len_dot).to_s
    flex_len = WIDTH - (status.length + dots.length)
    text = text[0..(flex_len-1)]
    result = "#{text}#{dots}#{status}"
    puts result
    result
  end
  def show_summary_and_reset
    show_summary
    @tests = 0
    @passing = 0
  end
  
  def show_summary
    percent_p = (@passing * 100) / @tests unless @tests == 0
    percent_f = 100 - percent_p unless @tests == 0
    puts "\nTests: #{@tests}.  Passes: #{@passes} (#{percent_p}%).  Failures: #{@tests-@passing} (#{percent_f}%)\n"
  end
  
  
  def initialize
    @tests = @passing = 0
    lon = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur gravida iaculis dapibus." # test string
    #show_summary
    puts "\nTesting the testing functionality..."
    test((1 == 1), true, "Testing for truth...")
    test((1 == 2), false, "Testing for falsehood...")
    test((1 == 2), true, "This should be a failing test")
    test(true, true, "Testing text trimming on long text: #{lon}")
    show_summary_and_reset
    puts "\nPerforming main tests...\n"
    main_tests
    show_summary
    
  end
  
  def main_tests
    ct = CCValid.new
    
    test(ct.valid?("4408 0412 3456 7893"), true, "Valid card with spaces should be valid")
    test(ct.valid?("4417 1234 5678 9112"), false, "Invalid card with spaces should not be valid")
    test(ct.valid?("4111111111111111"), true, "Valid card should be valid")
    test(ct.valid?("4111111111111"), false, "Invalid card should not be valid")
    test(ct.valid?("4012888888881881"), true, "Valid card should be valid")
    test(ct.valid?("378282246310005"), true, "Valid card should be valid")
    test(ct.valid?("6011111111111117"), true, "Valid card should be valid")
    test(ct.valid?("5105105105105100"), true, "Valid card should be valid")
    test(ct.valid?("5105105105105106"), false, "Invalid card should not be valid")
    test(ct.valid?("9111111111111111"), false, "Invalid card should not be valid")
    
    test(ct.mastercard?("5023"), false, "Card starting with 50 should not be MasterCard")
    test(ct.mastercard?("5123"), true, "Card starting with 51 should be MasterCard")
    test(ct.mastercard?("5223"), true, "Card starting with 52 should be MasterCard")
    test(ct.mastercard?("5323"), true, "Card starting with 53 should be MasterCard")
    test(ct.mastercard?("5423"), true, "Card starting with 54 should be MasterCard")
    test(ct.mastercard?("5523"), true, "Card starting with 55 should be MasterCard")
    test(ct.mastercard?("5623"), false, "Card starting with 56 should not be MasterCard")
    test(ct.mastercard?("55"), true, "Card starting with 55 should be MasterCard")
    test(ct.mastercard?("5"), false, "Card starting with 5 should not be MasterCard")
    test(ct.mastercard?("6"), false, "Card starting with 6 should not be MasterCard")
    test(ct.mastercard?("7"), false, "Card starting with 7 should not be MasterCard")
    test(ct.mastercard?("8"), false, "Card starting with 8 should not be MasterCard")
    test(ct.mastercard?("9"), false, "Card starting with 9 should not be MasterCard")
    test(ct.mastercard?("0"), false, "Card starting with 0 should not be MasterCard")
    test(ct.mastercard?("1"), false, "Card starting with 1 should not be MasterCard")
    test(ct.mastercard?("2"), false, "Card starting with 2 should not be MasterCard")
    test(ct.mastercard?("3"), false, "Card starting with 3 should not be MasterCard")
    test(ct.mastercard?("4"), false, "Card starting with 4 should not be MasterCard")
    test(ct.mastercard?("51"), true, "Card starting with 51 should be MasterCard")
    
    test(ct.visa?("3321"), false, "Card starting with 3 should not be Visa")
    test(ct.visa?("4321"), true, "Card starting with 4 should be Visa")
    test(ct.visa?("5321"), false, "Card starting with 5 should not be Visa")
    test(ct.visa?("6321"), false, "Card starting with 6 should not be Visa")
    test(ct.visa?("1"), false, "Card starting with 1 should not be Visa")
    test(ct.visa?("2"), false, "Card starting with 2 should not be Visa")
    test(ct.visa?("3"), false, "Card starting with 3 should not be Visa")
    test(ct.visa?("4"), true, "Card starting with 4 should be Visa")
    test(ct.visa?("5"), false, "Card starting with 5 should not be Visa")
    test(ct.visa?("6"), false, "Card starting with 6 should not be Visa")
    test(ct.visa?("7"), false, "Card starting with 7 should not be Visa")
    test(ct.visa?("8"), false, "Card starting with 8 should not be Visa")
    test(ct.visa?("9"), false, "Card starting with 9 should not be Visa")
    test(ct.visa?("0"), false, "Card starting with 0 should not be Visa")
    
    test(ct.amex?("3321"), false, "Card starting with 33 should not be AMEX")
    test(ct.amex?("3421"), true, "Card starting with 34 should be AMEX")
    test(ct.amex?("3521"), false, "Card starting with 35 should not be AMEX")
    test(ct.amex?("3621"), false, "Card starting with 36 should not be AMEX")
    test(ct.amex?("3721"), true, "Card starting with 37 should be AMEX")
    test(ct.amex?("3821"), false, "Card starting with 38 should not be AMEX")
    test(ct.amex?("3921"), false, "Card starting with 39 should not be AMEX")
    test(ct.amex?("3021"), false, "Card starting with 30 should not be AMEX")
    test(ct.amex?("3121"), false, "Card starting with 31 should not be AMEX")
    test(ct.amex?("3221"), false, "Card starting with 32 should not be AMEX")
    test(ct.amex?("3"), false, "Card starting with 3 should not be AMEX")
    test(ct.amex?("7"), false, "Card starting with 7 should not be AMEX")
    test(ct.amex?("2"), false, "Card starting with 2 should not be AMEX")
    test(ct.amex?("8"), false, "Card starting with 8 should not be AMEX")
    test(ct.amex?("4"), false, "Card starting with 4 should not be AMEX")
    test(ct.amex?("5"), false, "Card starting with 5 should not be AMEX")
    test(ct.amex?("6"), false, "Card starting with 6 should not be AMEX")
    test(ct.amex?("9"), false, "Card starting with 9 should not be AMEX")
    test(ct.amex?("0"), false, "Card starting with 0 should not be AMEX")
    test(ct.amex?("1"), false, "Card starting with 1 should not be AMEX")
    
    test(ct.discover?("6010"), false, "Card starting with 6010 should not be Discover")
    test(ct.discover?("6011"), true, "Card starting with 6011 should be Discover")
    test(ct.discover?("6012"), false, "Card starting with 6012 should not be Discover")
    test(ct.discover?("601"), false, "Card starting with 601 should not be Discover")
    test(ct.discover?("60"), false, "Card starting with 60 should not be Discover")
    test(ct.discover?("6"), false, "Card starting with 6 should not be Discover")
    test(ct.discover?("7"), false, "Card starting with 7 should not be Discover")
    test(ct.discover?("8"), false, "Card starting with 8 should not be Discover")
    test(ct.discover?("9"), false, "Card starting with 9 should not be Discover")
    test(ct.discover?("0"), false, "Card starting with 0 should not be Discover")
    test(ct.discover?("1"), false, "Card starting with 1 should not be Discover")
    test(ct.discover?("2"), false, "Card starting with 2 should not be Discover")
    test(ct.discover?("3"), false, "Card starting with 3 should not be Discover")
    test(ct.discover?("4"), false, "Card starting with 4 should not be Discover")
    test(ct.discover?("5"), false, "Card starting with 5 should not be Discover")
    
    
    test(ct.luhn?("4111111111111111"), true, "4111111111111111 is a valid luhn number")
    test(ct.luhn?("4111111111111112"), false, "4111111111111112 is an invalid luhn number")
    
    test(ct.valid_amex?("378282246310005"), true, "378282246310005 is a valid AMEX card")
    test(ct.valid_amex?("378282246310006"), false, "378282246310006 is an invalid AMEX card")
    test(ct.valid_amex?("378282246310004"), false, "378282246310004 is an invalid AMEX card")
    
    test(ct.valid_discover?("6011111111111117"), true, "6011111111111117 is a valid Discover card")
    test(ct.valid_discover?("6011111111111118"), false, "6011111111111118 is an ivalid Discover card")
    test(ct.valid_discover?("601111111111116"), false, "601111111111116 is an invalid Discover card")
    
    test(ct.valid_mastercard?("5105105105105100"), true, "5105105105105100 is a valid MasterCard")
    test(ct.valid_mastercard?("5105105105105101"), false, "5105105105105101 is an invalid MasterCard")
    test(ct.valid_mastercard?("510510510510510"), false, "510510510510510 is an invalid MasterCard")

    test(ct.valid_visa?("4111111111111111"), true, "4111111111111111 is a valid VISA")
    test(ct.valid_visa?("4111111111111112"), false, "4111111111111112 is an invalid VISA")
    test(ct.valid_visa?("411111111111111"), false, "411111111111111 is an invalid VISA")
    test(ct.valid_visa?("4408041234567893"), true, "4408041234567893 is a valid VISA")
    test(ct.valid_visa?("4408041234567894"), false, "4408041234567894 is an invalid VISA")
    test(ct.valid_visa?("4408041234567892"), false, "4408041234567892 is an invalid VISA")
    
    test(ct.type("4") == "VISA", true, "Card starting with 4 is VISA")
    test(ct.type("5") == "VISA", false, "Card starting with 5 is not VISA")
    
    test(ct.type("34") == "AMEX", true, "Card starting with 34 is AMEX")
    test(ct.type("37") == "AMEX", true, "Card starting with 37 is AMEX")
    test(ct.type("38") == "AMEX", false, "Card starting with 38 is not AMEX")
    test(ct.type("3") == "AMEX", false, "Card starting with 3 is not AMEX")
    
    test(ct.type("6011") == "Discover", true, "Card starting with 6011 is Discover")
    test(ct.type("6012") == "Discover", false, "Card starting with 6012 is not Discover")
    test(ct.type("601") == "Discover", false, "Card starting with 601 is not Discover")
    test(ct.type("60") == "Discover", false, "Card starting with 60 is not Discover")
    test(ct.type("6") == "Discover", false, "Card starting with 6 is not Discover")
    
    test(ct.type("51") == "MasterCard", true, "Card starting with 51 is MasterCard")
    test(ct.type("52") == "MasterCard", true, "Card starting with 52 is MasterCard")
    test(ct.type("53") == "MasterCard", true, "Card starting with 53 is MasterCard")
    test(ct.type("54") == "MasterCard", true, "Card starting with 54 is MasterCard")
    test(ct.type("55") == "MasterCard", true, "Card starting with 55 is MasterCard")
    test(ct.type("56") == "MasterCard", false, "Card starting with 56 is not MasterCard")
    test(ct.type("5") == "MasterCard", false, "Card starting with 5 is not MasterCard")
    test(ct.type("57") == "MasterCard", false, "Card starting with 57 is not MasterCard")
    test(ct.type("50") == "MasterCard", false, "Card starting with 50 is not MasterCard")
  end
end

tester = Tester.new
