class AnswerSheet < ActiveRecord::Base
  self.abstract_class = true # To fix rails 3.2 bug: https://github.com/rails/rails/issues/4578
end