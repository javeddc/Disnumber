class Pair < ActiveRecord::Base
  def phrase
    words = []

    words.push Adjective.find(adjective_1_id).word

    words.push Adjective.find(adjective_2_id).word unless adjective_2_id.nil?

    words.push Noun.find(noun_1_id).word unless noun_1_id.nil?

    # n2 = Noun.find(self.noun_2_id).word

    words.join(' ')
  end

  def size

    if adjective_2_id.nil? && noun_2_id.nil?
      2

    elsif !adjective_2_id.nil? && noun_2_id.nil?
      3

    else
      4
    end

  end

end
