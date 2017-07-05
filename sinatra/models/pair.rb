class Pair < ActiveRecord::Base

  def phrase
    words = []

    words.push Adjective.find(self.adjective_1_id).word

    if self.adjective_2_id != nil
      words.push Adjective.find(self.adjective_2_id).word
    end

    if self.noun_1_id != nil
      words.push Noun.find(self.noun_1_id).word
    end

    # n2 = Noun.find(self.noun_2_id).word


    words.join(' ')
  end

  def size
    if self.adjective_2_id == nil && self.noun_2_id == nil
      return 2
    elsif self.adjective_2_id != nil && self.noun_2_id == nil
      return 3
    else
      return 4
    end
  end

end
