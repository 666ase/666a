class Glossary::Sentence < ApplicationRecord
  belongs_to :element, class_name: "LabourLaw::Element"
end
