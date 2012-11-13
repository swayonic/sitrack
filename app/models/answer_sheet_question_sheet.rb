class AnswerSheetQuestionSheet < ActiveRecord::Base
  self.table_name = "si_answer_sheet_question_sheets"
  belongs_to :answer_sheet
  
  attr_accessible :question_sheet_id
end
