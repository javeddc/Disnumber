require 'pry'


class WordList

  def initialize(filepath)
    @filepath = filepath
    @word_arr = File.read(filepath).split(/\n|,| /)
    @word_arr.delete("")

    @word_arr.uniq!
    @word_arr.map! {|word| word.downcase}
    # .delete!("\r")
  end

  def arr
    @word_arr
  end

  def get(int)
    @word_arr[int]
  end

  def length
    @word_arr.size
  end

  def chomp_list
    @word_arr.each do |word|
      word.chomp!
    end
  end

  def add(word)
    @word_arr.push word.downcase
    @word_arr.uniq!
    # self.save
  end

  def save
    open(@filepath, 'w') do |f|
      f.puts @word_arr
    end
  end

  def undo
    @word_arr.pop
    # self.save
  end

  def remove_from_file(filepath)
    @words_to_remove = File.read(filepath).chomp.split(/\n|,| /)
    @words_to_remove.delete("")
    @words_to_remove.map {|word| word.downcase.delete!("\r")}
    @words_to_remove.each do |word|
      @word_arr.delete(word)
    end
    @word_arr.uniq!
    # self.save
  end

  def remove_wordlist(wordlist)
    @words_to_remove = wordlist.arr
    @words_to_remove.delete("")
    @words_to_remove.map {|word| word.downcase.delete!("\r")}
    @words_to_remove.each do |word|
      @word_arr.delete(word)
    end
    @word_arr.uniq!
    # self.save
  end

  def remove_word(str)
    @word_arr.delete(str)
  end

  def rand
    @word_arr.sample
  end


end


# binding.pry
