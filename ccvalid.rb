# A credit card verifier that reads numbers from file and outputs validity.
# Tests are dependent on credit card type, and checks are performed for 
# starting digits, length, and the Luhn algorithm.  Whitespace stripped.
#
# Author:  A. Perkins <aperkins81@gmail.com>
# Date: 2013-04-30
# Notes:
# 1. if you add new cards, update display(card) to ensure longest card is used

class CCValid
  def usage
    puts "Usage: ccvalid [optional list of files]"
    puts " What: Processes a list of credit card numbers to determine validity."
    puts "  How: a) ensure \"#{SAMPLE_FILE}\" is in the same directory, or"
    puts "       b) specify filenames as arguements\n"
    puts "\nIt is nice to be important but it is more important to be nice"
  end
  
  SAMPLE_FILE = "samples.txt"
  UNKNOWN = "Unknown"
  MAX_LEN = 16 # maximum credit card digits to display
  ERROR_FILE_NOT_READABLE = -1

  def initialize()
    files = []
    ARGV.each do |arg|
      files << arg if File.readable?(arg)
    end
    files << SAMPLE_FILE if files.empty? and File.readable?(SAMPLE_FILE)
    if files.empty?
      puts "Error: Sample file \"#{SAMPLE_FILE}\" not readable."
      usage
      return ERROR_FILE_NOT_READABLE
    end
    files.each do |file|
      validate_from_file file
    end
  end
  
  def validate_from_file(file)
    cc = File.new file, "r"
    while card = cc.gets
      display card
    end
  end
  
  def display(card)
    card = card.gsub(/\s+/, "")
    type = type(card)
    pad_type = "MasterCard".length - type.length # longest in type(card)
    pad_card = (MAX_LEN - (card.length > MAX_LEN ? MAX_LEN : card.length))
    fill = " " * (pad_type + pad_card)
    valid = valid?(card) ? "valid" : "invalid"
    puts "#{type}: #{card} #{fill}(#{valid})"
  end
  
  def type(card)
    return "AMEX" if amex? card
    return "Discover" if discover? card
    return "MasterCard" if mastercard? card
    return "VISA" if visa? card
    return UNKNOWN
  end
  
  def valid?(card)
    card = card.gsub(/\s+/, "")
    valid_amex?(card) ||
        valid_discover?(card) ||
        valid_mastercard?(card) ||
        valid_visa?(card)
  end
  
  def amex?(card)
    (card.start_with?("34") || card.start_with?("37"))
  end
  
  
  def discover?(card)
    card.start_with?("6011")
  end
  
  
  def mastercard?(card)
    (51..55).each do |x|
      return true if card.start_with? x.to_s
    end
    false
  end
  
  def visa?(card)
    card.start_with? "4"
  end
  
  def valid_amex?(card)
    amex?(card) && card.length == 15 && luhn?(card)
  end
  
  def valid_discover?(card)
    discover?(card) && card.length == 16 && luhn?(card)
  end
  
  def valid_mastercard?(card)
    mastercard?(card) && card.length == 16 && luhn?(card)
  end
  
  def valid_visa?(card)
    visa?(card) && (card.length == 13 || card.length == 16) && luhn?(card)
  end

  def luhn?(card)
    card = card.gsub(/\s+/, "")
    nums = card.split(//)
    last = nums.pop.to_i
    newnums = []
    nums.reverse!
    pos = 0
    while pos < nums.length do
      x = nums[pos].to_i
      y = (pos % 2 == 0) ? x.to_i*2 : x.to_i
      if y < 10
        newnums.push y
      else
        arr_y = y.to_s.split(//)
        newnums.push arr_y[1].to_i
        newnums.push arr_y[0].to_i
      end
      pos += 1
    end 
    total = newnums.inject(last) { |sum, x|
      sum + x
    }
    total % 10 == 0
  end
end

validator = CCValid.new
