class Pair < ActiveRecord::Base

  def phrase
    a1 = Adjective.find(self.adjective_1_id).word
    n1 = Noun.find(self.noun_1_id).word
    a2 = Adjective.find(self.adjective_2_id).word
    n2 = Noun.find(self.noun_2_id).word

    phrase_output = "#{a1} #{n1} #{a2} #{n2}"
    phrase_output
  end


end
